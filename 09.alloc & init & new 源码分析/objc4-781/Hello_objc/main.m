//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2020/12/5.
//

#import <Foundation/Foundation.h>
#import "objc.h"

@interface Person : NSObject
@property(nonatomic,copy) NSString *name;
@end
@implementation Person

@end

int main(int argc, const char * argv[]) {
    
    
    Person *pson1 = [Person alloc];
    Person *pson2 = [pson1 init];
    Person *pson3 = [pson1 init];
    
    Person *pson4 = [Person new];
    
    NSLog(@"== %@ -- %p -- %p",pson1,pson1,&pson1);
    NSLog(@"== %@ -- %p -- %p",pson2,pson3,&pson2);
    NSLog(@"== %@ -- %p -- %p",pson3,pson3,&pson3);
    
    int i = 3;
    NSLog(@"==i %p ",&i);

    id a = [@"aa" stringByAppendingString:@"a"];
    NSLog(@"==a %@ -- %p -- %p",[a class],a,&a);
    
    return 0;
}
