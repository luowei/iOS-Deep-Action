//
//  DSKeyValuePropertyCreate.m
//  DIS_KVC_KVO
//
//  Created by renjinkui on 2017/2/24.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "DSKeyValuePropertyCreate.h"
#import "DSKeyValueUnnestedProperty.h"
#import "DSKeyValueNestedProperty.h"
#import "DSKeyValueComputedProperty.h"
#import "DSKeyValueContainerClass.h"

CFMutableSetRef DSKeyValueProperties;

//判等，根据class与keypath
BOOL DSKeyValuePropertyIsEqual(DSKeyValueProperty *property1, DSKeyValueProperty *property2) {
    return (property1.containerClass == property2.containerClass) &&
    (property1.keyPath == property2.keyPath || [property1.keyPath isEqual: property2.keyPath]);
}

//hash为keypath的hash值与class异或
NSUInteger DSKeyValuePropertyHash(DSKeyValueProperty *property) {
    return property.keyPath.hash ^ (NSUInteger)(void *)property.containerClass;
}

// 根据class和keyPath获取DSKeyValueProperty
DSKeyValueProperty *DSKeyValuePropertyForIsaAndKeyPath(Class isa, NSString *keypath) {
    DSKeyValueContainerClass *containerClass = _DSKeyValueContainerClassForIsa(isa);
    if(DSKeyValueProperties) {
        DSKeyValueProperty *finder = [DSKeyValueProperty new];
        finder.containerClass = containerClass;
        finder.keyPath = keypath;
        DSKeyValueProperty *property = CFSetGetValue(DSKeyValueProperties,finder);
        if(property) {
            return property;
        }
    }
    
    CFSetCallBacks callbacks = {0};
    callbacks.version =  kCFTypeSetCallBacks.version;
    callbacks.retain =  kCFTypeSetCallBacks.retain;
    callbacks.release =  kCFTypeSetCallBacks.release;
    callbacks.copyDescription =  kCFTypeSetCallBacks.copyDescription;
    //判等函数
    callbacks.equal =  (CFSetEqualCallBack)DSKeyValuePropertyIsEqual;
    //Hash函数
    callbacks.hash =  (CFSetHashCallBack)DSKeyValuePropertyHash;
    CFMutableSetRef initializedProperties = CFSetCreateMutable(NULL,0,&callbacks);
    
    //根据class和keyPath获取DSKeyValueProperty,传入一个初始化的容器
    DSKeyValueProperty *property = DSKeyValuePropertyForIsaAndKeyPathInner(isa, keypath, initializedProperties);
    
    CFRelease(initializedProperties);
    
    return property;
}

//根据class和keyPath获取NSKeyValueProperty,传入一个初始化的容器
DSKeyValueProperty * DSKeyValuePropertyForIsaAndKeyPathInner( Class isa, NSString *keyPath, CFMutableSetRef initializedProperties) {
    DSKeyValueContainerClass *containerClass = _DSKeyValueContainerClassForIsa(isa);
    
    DSKeyValueProperty *finder = [DSKeyValueProperty new];
    finder.containerClass = containerClass;
    finder.keyPath = keyPath;
    
    //先尝试去容器里找
    DSKeyValueProperty *property = CFSetGetValue(initializedProperties,finder);
    
    if(!property) {
        if(DSKeyValueProperties) {
            property = CFSetGetValue(DSKeyValueProperties, finder);
            if(property) {
                return property;
            }
        }
        
        //构造Property
        char c = [keyPath characterAtIndex:0];
        if(c == '@') {
            property = [[DSKeyValueComputedProperty alloc] _initWithContainerClass:containerClass keyPath:keyPath propertiesBeingInitialized:initializedProperties];
        }
        else {
            NSRange range = [keyPath rangeOfString:@"."];
            if (range.length != 0) {
                property = [[DSKeyValueNestedProperty alloc] _initWithContainerClass:containerClass keyPath:keyPath firstDotIndex: range.location propertiesBeingInitialized:initializedProperties];
            }
            else {
                property = [[DSKeyValueUnnestedProperty alloc] _initWithContainerClass: containerClass key: keyPath propertiesBeingInitialized: initializedProperties];
            }
        }
        
        // 创建集合NSKeyValueProperties
        if(!DSKeyValueProperties) {
            CFSetCallBacks callbacks = {0};
            callbacks.version =  kCFTypeSetCallBacks.version;
            callbacks.retain =  kCFTypeSetCallBacks.retain;
            callbacks.release =  kCFTypeSetCallBacks.release;
            callbacks.copyDescription =  kCFTypeSetCallBacks.copyDescription;
            // 设置CFSet集合中元素判等的依据
            callbacks.equal =  (CFSetEqualCallBack)DSKeyValuePropertyIsEqual;
            // 设置CFSet集合中元素的hash值获取函数
            callbacks.hash =  (CFSetHashCallBack)DSKeyValuePropertyHash;
            DSKeyValueProperties =  CFSetCreateMutable(NULL, 0, &callbacks);
        }
        // 把property添加到NSKeyValueProperties集合中
        CFSetAddValue(DSKeyValueProperties, property);
        
        CFSetRemoveValue(initializedProperties, property);
    }
    return property;
}
