//
//  AppDelegate.m
//  MemLeak-Demo
//
//  Created by Luo Wei on 2021/1/12.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <OOMDetector/OOMDetector.h>
#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import <PLeakSniffer/PLeakSniffer.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#import "AppDelegate.h"

//@interface CacheCleanerPlugin : NSObject <FBMemoryProfilerPluggable>
//@end
//@implementation CacheCleanerPlugin
//- (void)memoryProfilerDidMarkNewGeneration {
//  [[NSURLCache sharedURLCache] removeAllCachedResponses];
//}
//@end
//
//@interface RetainCycleLoggerPlugin : NSObject <FBMemoryProfilerPluggable>
//@end
//@implementation RetainCycleLoggerPlugin
////发现循环引用打日志
//- (void)memoryProfilerDidFindRetainCycles:(NSSet *)retainCycles {
//    NSLog(@"=== 发现循环引用：%@\n", retainCycles);
//}
//@end


@interface AppDelegate () {
    FBMemoryProfiler *_memoryProfiler;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//    [[OOMDetector getInstance] setupWithDefaultConfig];
//    // 开启内存泄漏监控
//    [[OOMDetector getInstance] setupLeakChecker];
////
////
//    _memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[RetainCycleLoggerPlugin new]] retainCycleDetectorConfiguration:nil];
//    [_memoryProfiler enable];

    [[PLeakSniffer sharedInstance] installLeakSniffer];

    return YES;
}


@end


