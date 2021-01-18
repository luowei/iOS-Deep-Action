//
//  LWDispatchProxy.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
// 实现多个不同对象的消息分发

#import "LWDispatchProxy.h"
#import <objc/runtime.h>

@interface LWDispatchProxy ()
@property(nonatomic,strong) NSMutableDictionary *selectorDictionary;
@end

@implementation LWDispatchProxy

 +(instancetype)sharedInstance {
    static LWDispatchProxy *proxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       proxy = [LWDispatchProxy alloc];
       proxy.selectorDictionary = [NSMutableDictionary dictionary];
    });
     return proxy;
 }

 -(void)registerMethodWithTarget:(id)target {
     unsigned int count = 0;
     Method *methodList = class_copyMethodList([target class], &count);
     
     for (int i=0; i<count; i++) {
          Method method = methodList[i];
          SEL selector = method_getName(method);
          const char *method_name = sel_getName(selector);
         
         NSString *key = [NSString stringWithUTF8String:method_name];
         self.selectorDictionary[key] = target;
         NSLog(@"== method_name:%s",method_name);
     }
     free(methodList);
 }
 
 -(NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
       NSString *methodStr = NSStringFromSelector(sel);
       if ([self.selectorDictionary.allKeys containsObject:methodStr]) {
           id target = self.selectorDictionary[methodStr];
           return [target methodSignatureForSelector:sel];
        }
       return [super methodSignatureForSelector:sel];
 }

 -(void)forwardInvocation:(NSInvocation *)invocation {
        NSString *methodName = NSStringFromSelector(invocation.selector);
        if ([self.selectorDictionary.allKeys containsObject:methodName]) {
            id target = self.selectorDictionary[methodName];
            [invocation invokeWithTarget:target];
            
        }else {
            [super forwardInvocation:invocation];
         }
 }


@end
