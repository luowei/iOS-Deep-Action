//
//  LWProxy.h
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWProxy : NSProxy
/*
 解决NSTimer/CADisplayLink的循环引用问题:
 通过Proxy的弱引用代理对象可以解决像NSTimer的Target强引用产生的循环引用问题.
*/
@property (nonatomic, weak, readonly) NSObject *object;

+ (instancetype)proxyForObject:(id)obj;

@end

