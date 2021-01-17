//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//#import "Header.h"


/*

@implementation Person

//@synthesize为属性指定一个实例变量.
@synthesize name = p_name;
@synthesize phone = _phone;

//@dynamic告诉编译器不自动为属性在当前类中生成setter与getter方法.
//@dynamic age;

- (instancetype)init {
    NSLog(@"%s",__FUNCTION__);
    if (self = [super init]) {
        self.name = @"<name>";
        self.address = @"address";
        self.age = -1;
        self.salary = -1;
        self.phone = @"<phone>";
    }
    return self;
}
-(NSString *)description {
    unsigned int countProperty = 0;
    objc_property_t *properties = class_copyPropertyList(Person.class, &countProperty);
    for (unsigned int i = 0; i < countProperty; i++) {
        NSLog(@"%@属性：%s",NSStringFromClass(self.class), property_getName(properties[i]));
    }
    if(properties) free(properties);

    unsigned int countIval = 0;
    Ivar *ivals = class_copyIvarList([Person class], &countIval);
    for (unsigned int i = 0; i < countIval; i++) {
        NSLog(@"%@实例变量：%s",NSStringFromClass(self.class),ivar_getName(ivals[i]));
    }
    if(ivals) free(ivals);
    
    NSString *phone = self.phone;
    NSString *name = self.name;
    NSString *address = self.address;
    int age = self.age;
    int salary = self.salary;
    return [NSString stringWithFormat:@"%@ name:%@\naddress:%@\nage:%d\nsalary:%d\nphone:%@\n",
                                      NSStringFromClass(self.class),name,address,age,salary,phone];
}
@end


@implementation Man

-(NSString *)description {
    //return [super description];
    unsigned int countProperty = 0;
    objc_property_t *properties = class_copyPropertyList(Person.class, &countProperty);
    for (unsigned int i = 0; i < countProperty; i++) {
        NSLog(@"%@属性：%s",NSStringFromClass(self.class), property_getName(properties[i]));
    }
    if(properties) free(properties);

    unsigned int countIval = 0;
    Ivar *ivals = class_copyIvarList([Person class], &countIval);
    for (unsigned int i = 0; i < countIval; i++) {
        NSLog(@"%@实例变量：%s",NSStringFromClass(self.class),ivar_getName(ivals[i]));
    }
    if(ivals) free(ivals);
    
    NSString *phone = self.phone;
    NSString *name = self->p_name;
    NSString *address = self.address;
    int age = self.age;
    int salary = self.salary;//self->_salary_xxx;
    return [NSString stringWithFormat:@"\n== %@\nname:%@\naddress:%@\nage:%d\nsalary:%d\nphone:%@\n",
                                      NSStringFromClass(self.class),name,address,age,salary,phone];
}

@end
*/

@interface Animal : NSObject
@property(atomic,copy) NSString *a_name;
@property(nonatomic) int a_age;

@property(atomic,copy,setter=setFd:,getter=getFd,readwrite,nullable) NSString *food;
@end

@implementation Animal{
@public
    BOOL _isQueue1Running;
    BOOL _isQueue2Running;
}

////若设置了 null_resettable 修饰,就会要求重写属性的 setter 或 getter 方法做非空处理
@synthesize food = _food_xxx;
-(void)setFd:(NSString *)fd {
    _food_xxx = fd;
}
-(NSString *)getFd {
    return _food_xxx ?: nil ;
}

- (void)competition {
    dispatch_queue_t queue1 = dispatch_queue_create("aaa", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("bbb", DISPATCH_QUEUE_CONCURRENT);
    self.a_age = 0;
    _isQueue1Running = YES;
    dispatch_async(queue1, ^{
        for (int i = 0; i < 10000; i++) {
            self.a_age = self.a_age + 1;
        }
        self->_isQueue1Running = NO;
    });
    _isQueue2Running = YES;
    dispatch_async(queue2, ^{
        for (int i = 0; i < 10000; i++) {
            self.a_age = self.a_age + 1;
        }
        self->_isQueue2Running = NO;
    });
}

@end


//测试原子性
void testAtomic(Animal *animal) {
    [animal competition];


    //等10秒
    [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    if(animal->_isQueue1Running || animal->_isQueue2Running){
        NSLog(@"queue1 & queue2 is running!");
    }else{
        NSLog(@"queue1 & queue2 is completed!");
    }

    NSLog(@"== age:%d",animal.a_age);
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
//        Person *pson = [Person new];
//        NSLog(@"%@",pson);

//        Man *man = [Man new];
//        NSLog(@"%@",man);

        Animal *animal = [Animal new];
        animal.a_name = @"Tom";
//        animal.a_age = 3;
//        NSLog(@"== a_name:%@ a_age:%d", animal.a_name, animal.a_age);
//
//        animal.food = @"meat";
//        NSLog(@"== animal.food: %@",animal.food);
        
        testAtomic(animal);
    }
    return 0;
}


