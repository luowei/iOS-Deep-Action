//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface NSString (Category)
@property(nonatomic,strong) NSString *name;
//@property(nonatomic,assign) int age;
@end

@implementation NSString (Category)

//static NSString *_name;
-(void)setName:(NSString *)name {
//    _name = name;
    //设置关联对象实现
//    objc_setAssociatedObject(self, @"name",name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @selector(name),name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)name {
//    return _name;
//    return objc_getAssociatedObject(self, @"name");
    
    //_cmd在Objective-C的方法中表示当前方法的selector，同self表示当前方法调用的对象实例
    return objc_getAssociatedObject(self, _cmd);

    //SEL Method IMP
}

- (void)removeAssociatedObjects {
    // 移除所有关联对象
    objc_removeAssociatedObjects(self);
}

@end


int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSString *str = @"Hello";
        str.name = @"ZhangSan";
        NSLog(@"== str: %@ %@",str,str.name);
        
        NSString *str2 = @"Hi";
        str2.name = @"Lisi";
        NSLog(@"== str2: %@ %@",str2,str2.name);
    }
    return 0;
}


