//
//  AppDelegate.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/7.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Observer：activities = 0x1, order = -2147483647，它监听的事件是即将进入 RunLoop,优先级最高,保证 AutoReleasePool 的创建和重置发生在其他所有回调之前.
    char enterActive = 0x1;
    //Observer：activities = 0xa0, order = 2147483647，0xa0 转换成二进制即 1 << 5 && 1 << 7，因此它监听的事件是即将进入休眠和即将退出 RunLoop,优先级最低,保证 AutoReleasePool 的释放发生在其他所有回调之后。
    char exitActive = 0xa0;
    
    CFRunLoopObserverRef enterObserver = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), enterActive, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"****:_wrapRunLoopWithAutoreleasePoolHandler Runloop进入");
    });
    CFRunLoopObserverRef exitObserver = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), exitActive, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"****:_wrapRunLoopWithAutoreleasePoolHandler Runloop即将休眠或退出");
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), enterObserver, kCFRunLoopDefaultMode);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), exitObserver, kCFRunLoopDefaultMode);
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
