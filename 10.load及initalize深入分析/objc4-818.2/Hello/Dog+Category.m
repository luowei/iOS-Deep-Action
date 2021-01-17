//
//  Dog+Category.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject @end

@implementation Dog(Category)
+(void)load {
    NSLog(@"== %s",__func__);
}

@end
