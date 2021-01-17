//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2020/12/5.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@end

@implementation Person
//-(void)dealloc{
//    NSLog(@"==== deallock");
//}
@end

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {

        Person *object = [Person alloc];
        __weak id objc = object;
        NSLog(@"aaa");
         __autoreleasing id objc2 = object;
        
        //__weak id objc = [Person alloc];
        
    }

    return 0;
}
