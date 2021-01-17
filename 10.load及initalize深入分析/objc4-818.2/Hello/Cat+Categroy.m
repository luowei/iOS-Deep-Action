//
//  Cat+Categroy.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>

@interface Cat : NSObject @end

@implementation Cat(Category)
+(void)load {
    NSLog(@"== %s",__func__);
}
@end
