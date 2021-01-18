//
//  LWProxy.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//  解决NSTimer/CADisplayLink的循环引用问题

#import "LWProxy.h"

@implementation LWProxy

+ (instancetype)proxyForObject:(id)obj {
    //NSProxy没有init初始化方法，所以这里也不需要调用也不用实现
    LWProxy *instance = [LWProxy alloc];
    instance->_object = obj;
    
    return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_object respondsToSelector:invocation.selector]) {
        NSString *selectorName = NSStringFromSelector(invocation.selector);
        
//        NSLog(@"== Before calling \"%@\".", selectorName);
        [invocation invokeWithTarget:_object];
//        NSLog(@"== After calling \"%@\".", selectorName);
        
//        //获取返回值
//        NSURL *retValue;
//        [invocation getReturnValue:&retValue];
//        NSLog(@"== returnValue:%@",retValue);
    }
}

@end
