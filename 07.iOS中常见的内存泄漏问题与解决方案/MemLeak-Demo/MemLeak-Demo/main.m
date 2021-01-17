//
//  main.m
//  MemLeak-Demo
//
//  Created by Luo Wei on 2021/1/12.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBAllocationTracker/FBAllocationTrackerManager.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#import "AppDelegate.h"

int main(int argc, char *argv[]) {
//    [FBAssociationManager hook];
//    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
//    [[FBAllocationTrackerManager sharedManager] enableGenerations];

    NSString *appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
