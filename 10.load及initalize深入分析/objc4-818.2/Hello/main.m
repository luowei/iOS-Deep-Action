//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Human : NSObject @end
@interface Person : Human
@property(nonatomic,copy) NSString *p_name;
@end

//@interface Animal : NSObject @end
//@interface Dog : NSObject @end
//@interface Cat : NSObject @end

@implementation Human : NSObject
+(void)load {
//    NSLog(@"== %s",__func__);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"== %s",__func__);
        
        unsigned int countIval = 0;
        __unsafe_unretained Ivar *ivals = class_copyIvarList([Person class], &countIval);
        for (unsigned int i = 0; i < countIval; i++) {
            NSLog(@"Person变量为：%s", ivar_getName(ivals[i]));
        }
    });

}
@end


@implementation Person : Human
+(void)load {
//    [super load]; //会导致父类 +[Human load] 再调一次
    NSLog(@"== %s",__func__);
}

+ (void)initialize {
    NSLog(@"%s",__FUNCTION__);
    
//    //initalize可能被调用多次，所以一般业务代码写到dispatch_once
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//          //......
//    });
}

- (instancetype)init {
    NSLog(@"%s",__FUNCTION__);
    if (self = [super init]) {
    }
    return self;
}
@end


@implementation Man : Person
+(void)load {
    NSLog(@"== %s",__func__);
}

//Man是从Person继承下来，基Man没实现initialize，那会自动调用用父类的initialize
+ (void)initialize {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)init {
    NSLog(@"%s",__FUNCTION__);
    if (self = [super init]) {
    }
    return self;
}
@end

@implementation Man(Category)
+(void)load {
    NSLog(@"== %s",__func__);
}

+ (void)initialize {
    NSLog(@"%s",__FUNCTION__);
}
@end

@implementation Woman : Person
+(void)load {
    NSLog(@"== %s",__func__);
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Man *man = [Man new];
        NSLog(@"Hello");
    }
    return 0;
}
