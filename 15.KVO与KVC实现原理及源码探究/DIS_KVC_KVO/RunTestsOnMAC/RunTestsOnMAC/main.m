//
//  main.m
//  RunTestsOnMAC
//
//  Created by renjinkui on 2017/5/25.
//  Copyright © 2017年 JK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCDemo.h"
#import "KVODemo.h"

int main(int argc, const char * argv[]) {
//    void tests_main();
//    tests_main();
    
//        //KVO
//        KVOViewController *kvo_vc = [KVOViewController new];
////        [kvo_vc testKVO];
//        [kvo_vc testKVO_OnOtherThread];

        //KVC
        KVCViewController *kvc_vc = [KVCViewController new];
        [kvc_vc testKVC];
    
    [NSRunLoop.currentRunLoop run]; //启动runloop让应用不退出
    return 0;
}
