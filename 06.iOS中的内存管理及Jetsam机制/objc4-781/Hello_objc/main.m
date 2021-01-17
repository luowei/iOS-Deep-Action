//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2020/12/5.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
+(instancetype)new_p;
+(instancetype)pson;
@end

@implementation Person
+(instancetype)new_p {
    return [Person alloc];
}
+(instancetype)pson {
    return [Person alloc];
}
@end

int main(int argc, const char * argv[]) {
    
    const char *arg = argv[0];
    printf("%s\n", arg);

//    @autoreleasepool {
        
//        id a;
//        id b = a; //retain
        
//        __strong id object = [Person alloc];
//        id obj = [Person alloc];
//        id obj = [Person new_p];
//        id obj = [Person pson];
//        __strong id object = obj;

        
//        __weak id object = [Person alloc];
//        id obj = [Person alloc];
//        __weak id object = obj;

        
//        __autoreleasing id object = [Person alloc];
//        id obj = [Person alloc];
//        __autoreleasing id object = obj;

     
//        __unsafe_unretained id object = [Person alloc];
//        id obj = [Person alloc];
//        __unsafe_unretained id object = obj;
        
//    }
    
    return 0;
}
