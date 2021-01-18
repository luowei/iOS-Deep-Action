//
//  LWMulInheritProxy.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "LWMulInheritProxy.h"

@implementation LWMulInheritProxy

-(void)transformToObject:(NSObject *)obj {
    self.obj = obj;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (self.obj && [self.obj respondsToSelector:aSelector]) {
        return [self.obj methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL aSelector = [anInvocation selector];
    if (self.obj && [self.obj respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.obj];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end
