//
//  DSObject+DSKeyValueObserverRegistration.m
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/1/11.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "NSObject+DSKeyValueObserverRegistration.h"
#import "DSKeyValueProperty.h"
#import "DSKeyValueContainerClass.h"
#import "DSKeyValueObservance.h"
#import "DSKeyValueObservationInfo.h"
#import "DSKeyValueChangeDictionary.h"
#import "DSKeyValuePropertyCreate.h"
#import "DSKeyValueObserverCommon.h"
#import "NSObject+DSKeyValueObservingPrivate.h"
#import "NSObject+DSKeyValueObserverNotification.h"

pthread_mutex_t _DSKeyValueObserverRegistrationLock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER;

pthread_t _DSKeyValueObserverRegistrationLockOwner = NULL;

BOOL _DSKeyValueObserverRegistrationEnableLockingAssertions;


void DSKeyValueObserverRegistrationLockUnlock() {
    _DSKeyValueObserverRegistrationLockOwner = NULL;
    pthread_mutex_unlock(&_DSKeyValueObserverRegistrationLock);
}

void DSKeyValueObserverRegistrationLockLock() {
    pthread_mutex_lock(&_DSKeyValueObserverRegistrationLock);
    _DSKeyValueObserverRegistrationLockOwner = pthread_self();
}

void DSKeyValueObservingAssertRegistrationLockNotHeld() {
    if(_DSKeyValueObserverRegistrationEnableLockingAssertions && _DSKeyValueObserverRegistrationLockOwner == pthread_self()) {
        assert(pthread_self() != _DSKeyValueObserverRegistrationLockOwner);
    }
}

@implementation NSObject (DSKeyValueObserverRegistration)

// 这是个接口方法, 添加观察者分为两个流程:
//1，根据class和keyPath获取NSKeyValueProperty对象。
//2，添加对property的观察。
- (void)d_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    LOG_KVO(@"object:%@, add observer:%@, for keyPath: %@, options:0X%02X, context: %p", simple_desc(self), simple_desc(observer), keyPath, (uint8_t)options, context);
    // 加锁
    pthread_mutex_lock(&_DSKeyValueObserverRegistrationLock);
    _DSKeyValueObserverRegistrationLockOwner = pthread_self();  // 获取当前线程pthread
    
    // 根据class和keyPath获取NSKeyValueProperty
    DSKeyValueProperty * property = DSKeyValuePropertyForIsaAndKeyPath(object_getClass(self),keyPath);
    
    // 添加对property的观察
    [self _d_addObserver:observer forProperty:property options:options context:context];
    
    pthread_mutex_unlock(&_DSKeyValueObserverRegistrationLock);  // 解锁
}

// 添加观察者过程中, 不是单纯地'观察'keyPath, 而是观察对keyPath封装的NSKeyValueProperty
- (void)_d_addObserver:(id)observer forProperty:(DSKeyValueProperty *)property options:(int)options context:(void *)context {
    LOG_KVO(@"object:%@, add observer:%@, for property:%@, options:0X%02X, context: %p",simple_desc(self), simple_desc(observer), simple_desc(property), (uint8_t)options, context);
    if(options & NSKeyValueObservingOptionInitial) {
        // NSKeyValueObservingOptionInitial: 观察最初的值（在注册观察服务时会调用一次触发方法）
        
        NSString *keyPath = [property keyPath];
        _DSKeyValueObserverRegistrationLockOwner = NULL;
        
        // 解锁
        pthread_mutex_unlock(&_DSKeyValueObserverRegistrationLock);
        
        id newValue = nil;
        if (options & NSKeyValueObservingOptionNew) {   // newValue就是当前的值
            newValue = [self valueForKeyPath:keyPath];
            if (!newValue) {
                newValue = [NSNull null];  // 使用NSNull对象
            }
        }
        
        DSKeyValueChangeDictionary *changeDictionary = nil;
        // 创建NSKeyValueChangeDetails结构体
        DSKeyValueChangeDetails changeDetails = {0};
        changeDetails.kind = NSKeyValueChangeSetting;
        changeDetails.oldValue = nil;
        changeDetails.newValue = newValue;
        changeDetails.indexes = nil;
        changeDetails.extraData = nil;
        
        LOG_KVO(@"options contains NSKeyValueObservingOptionInitial， will notify observer, changeDetails: %@", NSStringFromKeyValueChangeDetails(&changeDetails));
        
        // 函数1: 通知观察者, 传递结构体changeDetails
        DSKeyValueNotifyObserver(observer,keyPath, self, context, nil, NO,changeDetails, &changeDictionary);
        
        [changeDictionary release];
        // 加锁
        pthread_mutex_lock(&_DSKeyValueObserverRegistrationLock);
        // 获取当前pthread
        _DSKeyValueObserverRegistrationLockOwner = pthread_self();
    }
    
    // 函数2: 获取oldObservationInfo
    DSKeyValueObservationInfo *oldObservationInfo = _DSKeyValueRetainedObservationInfoForObject(self,property.containerClass);
    
    BOOL cacheHit = NO;
    DSKeyValueObservance *addedObservance = nil;
    id originalObservable = nil;
    
    if((options >> 8) & 0x01) {
        // _CFGetTSD: 获取线程信息, Get some thread specific data from a pre-assigned slot.
        DSKeyValueObservingTSD *TSD = _CFGetTSD(DSKeyValueObservingTSDKey);
        if (TSD) {
            originalObservable = TSD->implicitObservanceAdditionInfo.originalObservable;
        }
    }
    
    // 函数3: 获取newObservationInfo , 即’添加观察者’时所需要的ObservationInfo
    DSKeyValueObservationInfo *newObservationInfo = _DSKeyValueObservationInfoCreateByAdding(oldObservationInfo, observer, property, options, context, originalObservable,&cacheHit,&addedObservance);
    
    LOG_KVO(@"will replcae old observation info:%@, with new: %@, added observance: %@, originalObservable: %@",simple_desc(oldObservationInfo), simple_desc(newObservationInfo), simple_desc(addedObservance), simple_desc(originalObservable));
    
    // 函数4: 将self的observationInfo设置为newObservationInfo
    _DSKeyValueReplaceObservationInfoForObject(self,property.containerClass,oldObservationInfo,newObservationInfo);
    //此方法为空实现，啥也没干
    [property object:self didAddObservance:addedObservance recurse:YES];
    
    // 核心方法: 获取property中已经修改过的class
    Class isaForAutonotifying = [property isaForAutonotifying];
    if(isaForAutonotifying) {
        Class cls = object_getClass(self);
        if(cls != isaForAutonotifying) {
            LOG_KVO(@"isaForAutonotifying: %@, current class: %@, will change current class to: %@", isaForAutonotifying, cls, isaForAutonotifying);
            
            // 通过 object_setClass()修改isa指针, 设置自己的class为property的isaForAutonotifying
            object_setClass(self,isaForAutonotifying);
        }
    }
    
    [newObservationInfo release];
    [oldObservationInfo release];
}


- (void)d_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    LOG_KVO(@"object:%@, remove observer:%@, for keyPath:%@, context: %p",simple_desc(self), simple_desc(observer), keyPath,  context);
    DSKeyValueObservingTSD *TSD = _CFGetTSD(DSKeyValueObservingTSDKey);
    if (!TSD) {
        TSD = (DSKeyValueObservingTSD *)NSAllocateScannedUncollectable(sizeof(DSKeyValueObservingTSD));
        _CFSetTSD(DSKeyValueObservingTSDKey, TSD, DSKeyValueObservingTSDDestroy);
    }

    DSKeyValueObservingTSD backTSD = *(TSD);
    
    TSD->implicitObservanceRemovalInfo.removingObject = self;
    TSD->implicitObservanceRemovalInfo.observer = observer;
    TSD->implicitObservanceRemovalInfo.keyPath = keyPath;
    TSD->implicitObservanceRemovalInfo.originalObservable = nil;
    TSD->implicitObservanceRemovalInfo.context = context;
    TSD->implicitObservanceRemovalInfo.shouldCompareContext = YES;
    
    [self d_removeObserver:observer forKeyPath:keyPath];
    
    *(TSD) = backTSD;
}

- (void)d_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
   LOG_KVO(@"object:%@, remove observer:%@, for keyPath:%@",simple_desc(self), simple_desc(observer), keyPath);
    pthread_mutex_lock(&_DSKeyValueObserverRegistrationLock);
    _DSKeyValueObserverRegistrationLockOwner = pthread_self();
    
    DSKeyValueProperty * property = DSKeyValuePropertyForIsaAndKeyPath(self.class,keyPath);
    
    [self _d_removeObserver:observer forProperty:property];
    
    pthread_mutex_unlock(&_DSKeyValueObserverRegistrationLock);
}

- (void)_d_removeObserver:(id)observer forProperty:(DSKeyValueProperty *)property {
    LOG_KVO(@"object:%@, remove observer:%@, for property:%@",simple_desc(self), simple_desc(observer), simple_desc(property));
    DSKeyValueObservationInfo *oldObservationInfo = _DSKeyValueRetainedObservationInfoForObject(self, property.containerClass);
    if (oldObservationInfo) {
        void *context = NULL;
        BOOL shouldCompareContext = NO;
        id originalObservable = nil;
        BOOL cacheHit = NO;
        DSKeyValueObservance *removalObservance = nil;
        
        DSKeyValueObservingTSD *TSD = _CFGetTSD(DSKeyValueObservingTSDKey);
        if (TSD &&
            TSD->implicitObservanceRemovalInfo.removingObject == self &&
            TSD->implicitObservanceRemovalInfo.observer == observer &&
            [TSD->implicitObservanceRemovalInfo.keyPath isEqualToString:property.keyPath]) {
            originalObservable = TSD->implicitObservanceRemovalInfo.originalObservable;
            context = TSD->implicitObservanceRemovalInfo.context;
            shouldCompareContext = TSD->implicitObservanceRemovalInfo.shouldCompareContext;
        }
        
        DSKeyValueObservationInfo *newObservationInfo = _DSKeyValueObservationInfoCreateByRemoving(oldObservationInfo, observer, property, context, shouldCompareContext, originalObservable, &cacheHit, &removalObservance);
        
        if (removalObservance) {
            [removalObservance retain];
            
            _DSKeyValueReplaceObservationInfoForObject(self, property.containerClass, oldObservationInfo, newObservationInfo);
            
            LOG_KVO(@"object:%@,remove observer:%@, for property:%@,  has replcae old observation info:%@, with new: %@, removal observance: %@, originalObservable: %@",simple_desc(self), simple_desc(observer), simple_desc(property), simple_desc(oldObservationInfo), simple_desc(newObservationInfo), simple_desc(removalObservance), simple_desc(originalObservable));
            
            [property object:self didRemoveObservance:removalObservance recurse:YES];
            
            if (!newObservationInfo) {
                if (object_getClass(self) != property.containerClass.originalClass) {
                    object_setClass(self, property.containerClass.originalClass);
                }
            }
            
            [removalObservance release];
            [newObservationInfo release];
            [oldObservationInfo release];
            
            return;
        }
        //没有找到对应的observance，继续往下走，报Cannot remove an observer...异常
    }

    LOG_KVO(@"Cannot remove an observer <%@ %p> for the key path \"%@\" from <%@ %p> because it is not registered as an observer.",[observer class], observer, property.keyPath, self.class, self);
   
    [NSException raise:NSRangeException format:@"Cannot remove an observer <%@ %p> for the key path \"%@\" from <%@ %p> because it is not registered as an observer.",[observer class], observer, property.keyPath, self.class, self];
}

@end


