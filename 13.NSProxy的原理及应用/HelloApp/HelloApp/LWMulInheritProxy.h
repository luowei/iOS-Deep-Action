//
//  LWMulInheritProxy.h
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
// 模拟多继承

#import <Foundation/Foundation.h>


@interface LWMulInheritProxy : NSProxy
@property (nonatomic, strong) NSObject *obj;

-(void)transformToObject:(NSObject *)obj;

@end

