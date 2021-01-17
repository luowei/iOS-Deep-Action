//
//  main.m
//  CopyConst-Demo
//
//  Created by Luo Wei on 2021/1/5.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying,NSMutableCopying>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic,strong) NSArray *arr;
@property (nonatomic,strong) NSMutableArray *mutableArr;
@end

@implementation Person
//- (id)copy {
////    return [super copy];
//    return self;
//}
//
//- (id)mutableCopy {
//    return [super mutableCopy];
//}

- (id)copyWithZone:(nullable NSZone *)zone {
    Person *copy = [[Person allocWithZone:zone] init];
    copy.name = [self.name copy];
    copy.age = self.age;
    copy.arr = [self.arr copy];
    copy.mutableArr = [self.mutableArr mutableCopy];
    return copy;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
//    return self;
    Person *mcopy = [[Person allocWithZone:zone] init];
    mcopy.name = [self.name copy];
    mcopy.age = self.age;
    mcopy.arr = [self.arr copy];
    mcopy.mutableArr = [self.mutableArr copy];
    return mcopy;
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //NSString 的拷贝
        NSString *aString = @"Hello";
        NSString *copyString = [aString copy];
        NSMutableString *mutableString = [aString mutableCopy];

        NSLog(@"aString            :%p %@",(__bridge void *)aString,aString.class);
        NSLog(@"aString copy       :%p %@",(__bridge void *)copyString,copyString.class); //指针复制
        NSLog(@"aString mutableCopy:%p %@",(__bridge void *)mutableString,mutableString.class); //内容复制

        //NSMutableString
        NSMutableString *bString = [NSMutableString stringWithString:@"Hello"];
        NSMutableString *copyMutableString = [bString copy];
        NSMutableString *mutaCopyMutableString = [bString mutableCopy];

        NSLog(@"--------");
        NSLog(@"bString            :%p %@",(__bridge void *)bString,bString.class);
        NSLog(@"bString copy       :%p %@",(__bridge void *)copyMutableString,copyMutableString.class); //内容复制,类型改为NSString
        NSLog(@"bString mutableCopy:%p %@",(__bridge void *)mutaCopyMutableString,mutaCopyMutableString.class); //内容复制
        
        //自定义类,自定义对象不存在可变和不可变对象
        Person *pson = [Person new];
        pson.name = @"张三".mutableCopy;
        pson.age = 20;
        //集合
        pson.arr = @[@"arr_01",@"arr_02"];
        pson.mutableArr = [NSMutableArray array];

        Person *pson1 = [pson copy];
        Person *pson2 = [pson mutableCopy];

        NSLog(@"--------");
        NSLog(@"pson :%p name:%@ %p, age:%lu %p arr:%p mutalbeArr:%p",(__bridge void *)pson,pson.name,(__bridge void *)pson.name,pson.age,(void *)pson.age,(__bridge void *)pson.arr,(__bridge void *)pson.mutableArr);
        NSLog(@"pson1:%p name:%@ %p, age:%lu %p arr:%p mutalbeArr:%p",(__bridge void *)pson1,pson1.name,(__bridge void *)pson1.name,pson1.age,(void *)pson1.age,(__bridge void *)pson1.arr,(__bridge void *)pson1.mutableArr);
        NSLog(@"pson2:%p name:%@ %p, age:%lu %p arr:%p mutalbeArr:%p",(__bridge void *)pson2,pson2.name,(__bridge void *)pson2.name,pson2.age,(void *)pson2.age,(__bridge void *)pson2.arr,(__bridge void *)pson2.mutableArr);
        
        
        NSLog(@"======== const ======");
        int a = 3;
        int b = 4;
//        const int *p = &a;
//        int const *p = &a;
//        p = &b;
//        *p  = b; //error
        
        int *const p = &a;
//        p = &b; //error
        *p =b;
        
//        const int c = 5;
//        c = a; //error
//        c = 6.0; //error
        
        NSLog(@"const: %i",*p);
        
    }
    return 0;
}
