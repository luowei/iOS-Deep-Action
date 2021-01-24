//
//  main.m
//  RunLoop-Demo
//
//  Created by Luo Wei on 2021/1/23.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    
    NSLog(@"== App Begin");
    int ret = UIApplicationMain(argc, argv, nil, appDelegateClassName);
    NSLog(@"== App End");
    
    return ret;
}
