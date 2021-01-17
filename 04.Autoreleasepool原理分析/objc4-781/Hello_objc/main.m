//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2020/12/5.
//

#import <Foundation/Foundation.h>

void *getXXX(){
//    id obj = @(10);
//    id obj = [@"x" stringByAppendingString:@"xx"];
    id obj = @"xxx";
    return (__bridge void *)obj;
}

int main(int argc, const char * argv[]) {
    NSLog(@"==== before autoreleasepool");
    
    @autoreleasepool {
//        NSString *a1 = @"Hello";
//        [a1 stringByAppendingString:@"World!"];
//        
//        NSMutableArray *a2 = @[@"aaa"].mutableCopy;
//        [a2 addObject:@"bbb"];
//        
//        getXXX();
//        
//        NSLog(@"====== a1:%@ a2:%@",a1,a2.lastObject);
        
        
//        __weak NSString *string = nil;
//        @autoreleasepool{
//            NSString *str = [NSString stringWithFormat:@"test str"];
//            string = str;
//        }
//
        NSMutableArray *arr = @[].mutableCopy;
        for (int i=0; i < 100000; i++)
            [arr addObject:@(1)];

//        for (int i=0; i<arr.count; i++) {
//            @autoreleasepool {
//                [@"str_" stringByAppendingFormat:@"%d",rand()];
//            }
//        }

        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [@"str_" stringByAppendingFormat:@"%d",rand()];
        }];
        
        NSLog(@"for done!");
    }
    
//    NSLog(@"==== after autoreleasepool");
    return 0;
}
