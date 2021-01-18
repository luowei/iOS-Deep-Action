//
//  main.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@implementation A : NSObject
-(void)printA{
    NSLog(@"== %s",__FUNCTION__);
}
@end

@implementation B : NSObject
-(void)printB{
    NSLog(@"== %s",__FUNCTION__);
}
@end



////模拟多继承
//#import "LWMulInheritProxy.h"
//
//void testMultiInherit() {
//    A *a = [A new];
//    B *b = [B new];
//    id proxy = [LWMulInheritProxy alloc];
//    // 变身为A的代理
//    [proxy transformToObject:a];
//    [proxy performSelector:@selector(printA) withObject:nil];
//    // 变身为B的代理
//    [proxy transformToObject:b];
//    [proxy performSelector:@selector(printB) withObject:nil];
//
//}




////多对象消息分发
//#import "LWDispatchProxy.h"
//
//void testMultiDispatch() {
//     A *a = [A new];
//     B *b = [B new];
//     id proxy = [LWDispatchProxy sharedInstance];
//     [proxy registerMethodWithTarget:a];
//     [proxy registerMethodWithTarget:b];
//
//     [proxy printA];
//     [proxy printB];
//}



//测试自省
#import "LWProxy.h"
#import "LWMulInheritProxy.h"
#import "LWDispatchProxy.h"

void testSelfInspect() {
    A *a = [A new];
    B *b = [B new];
    
    id proxy = [LWMulInheritProxy alloc];
    
    [proxy transformToObject:a]; //变身为A的代理
    NSLog(@"== [proxy isKindOfClass:A.class] : %i",[proxy isKindOfClass:A.class]);
    [proxy transformToObject:b]; //变身为B的代理
    NSLog(@"== [proxy respondsToSelector:@selector(printB)] : %i",[proxy respondsToSelector:@selector(printB)]);
    
    proxy = [LWProxy proxyForObject:a];
    NSLog(@"== [proxy isKindOfClass:A.class] : %i",[proxy isKindOfClass:A.class]);
    NSLog(@"== [proxy isMemberOfClass:A.class] : %i",[proxy isMemberOfClass:A.class]);
    NSLog(@"== [proxy respondsToSelector:@selector(printA)] : %i",[proxy respondsToSelector:@selector(printA)]);
}



int main(int argc, char * argv[]) {
    
//    testMultiInherit();
//    testMultiDispatch();
    testSelfInspect();
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
