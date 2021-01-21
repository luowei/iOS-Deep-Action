//
//  KVODemo.m
//  RunTestsOnIOS
//
//  Created by Luo Wei on 2021/1/21.
//  Copyright © 2021 JK. All rights reserved.
//

#import "KVODemo.h"
#import <objc/runtime.h>
#import "KVO.h"

#pragma mark - KVOPerson

@implementation KVOPerson

////是否自动KVO,返回NO就不自动KVO,在调用setXXX方法前后要调用willChangeValueForKey:与didChangeValueForKey:手动触发
//+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}
//+(BOOL)d_automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}

- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    NSLog(@"== %s", __FUNCTION__);
}

- (void)didChangeValueForKey:(NSString *)key {
    //tips:didChangeValueForKey:内部会调用observer的observeValueForKeyPath:ofObject:change:context:方法.
    NSLog(@"== begin %s", __FUNCTION__);
    [super didChangeValueForKey:key];
    NSLog(@"== end %s", __FUNCTION__);
}

@end


#pragma mark - ViewController

@implementation KVOViewController : NSObject

- (instancetype)init {
    self.p1 = [KVOPerson new];
    self.p1.name = @"aaa";
    self.p1.age = 1;
    self.p2 = [KVOPerson new];
    self.p2.name = @"bbb";
    self.p2.age = 2;
    
    self.p1.son = self.p2;

    NSLog(@"添加KVO之前 - p1：%@, p2：%@", object_getClass(self.p1), object_getClass(self.p2));
    NSLog(@"添加KVO之前IMP - p1：%p， p2：%p \n",[self.p1 methodForSelector:@selector(setAge:)], [self.p2 methodForSelector:@selector(setAge:)]); //把setAge:的IMP地址打出来

    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.p1 addObserver:self forKeyPath:@"name" options:options context:nil];
    [self.p1 addObserver:self forKeyPath:@"age" options:options context:nil];
    [self.p1 addObserver:self forKeyPath:@"son" options:options context:nil];
    [self.p1 addObserver:self forKeyPath:@"salary" options:options context:nil];

    //DSKVONotifying_KVOPerson
    [self.p2 d_addObserver:self forKeyPath:@"age" options:options context:nil];

    NSLog(@"添加KVO之后 - p1：%@, p2：%@", object_getClass(self.p1), object_getClass(self.p2));
    NSLog(@"添加KVO之后IMP - p1：%p， p2：%p \n",[self.p1 methodForSelector:@selector(setAge:)], [self.p2 methodForSelector:@selector(setAge:)]);
    //NSSetIntValueAndNotify();

    NSLog(@"== self.class的isa:%@, supper class:%@", NSStringFromClass(object_getClass(self.p1)), class_getSuperclass(object_getClass(self.p1)));

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    NSLog(@"== 监听到了%@的%@属性发生了改变%@", object, keyPath, change);
}


- (void)dealloc {
    NSLog(@"== %s", __FUNCTION__);
    [self.p1 removeObserver:self forKeyPath:@"name"];
    [self.p1 removeObserver:self forKeyPath:@"age"];
    [self.p1 removeObserver:self forKeyPath:@"son"];
    [self.p1 removeObserver:self forKeyPath:@"salary"];

    [self.p2 d_removeObserver:self forKeyPath:@"age"];
}


//测试KVO
- (void)testKVO {
//    int age1, age2;
//    NSLog(@"**** Enter p1.age and p2.age:");
//    scanf("%i %i", &age1, &age2);
//    printf("**** p1.age:%d p2.age:%d \n", age1, age2);

//    //直接修改成员变量,不会触发kvo，因为没有调用setXxx:方法
//    self.p1->_age = age1;
//    self.p2->_age = age2;
//    NSLog(@"== p1.age:%d  p2.age:%d",self.p1.age,self.p2.age);


//    //kvo，通过.语法,属性赋值自动触发
//    self.p1.age = age1;
//    self.p2.age = age2;
//
//    self.p1.son = [KVOPerson new];


//    //kvc操作，触发kvo
//    [self.p1 setValue:@(age1) forKey:@"age"];
//    [self setValue:@(age1) forKeyPath:@"p1.age"];
//    NSLog(@"**** p1.age valueForKey:%d \tvalueForKeyPath:%d", [[self.p1 valueForKey:@"age"] intValue], [[self valueForKeyPath:@"p1.age"] intValue]);

//    //kvc通过成员变量设值，也会触发kvo。因为会创建NSKeyValueIvarSetter对象，在该对象的构造方法中会调用_NSSetValueAndNotifyForKeyInIvar()函数,此函数内会调用willChangeValueForKey:与didChangeValueForKey:
//    [self.p1 setValue:@(500.f) forKey:@"salary"];
//    NSLog(@"**** p1->_salary:%.2f",self.p1->_salary);

//    //手动触发KVO,通过手动调willChangeValueForKey与didChangeValueForKey
//    [self.p1 willChangeValueForKey:@"name"];
//    [self.p1 setValue:@"DEF" forKey:@"name"];
//    [self.p1 didChangeValueForKey:@"name"];
//
//    [self.p2 d_willChangeValueForKey:@"age"];
//    [self.p2 d_setValue:@45 forKey:@"age"];
//    [self.p2 d_didChangeValueForKey:@"age"];
}

- (void)testKVO_OnOtherThread {
    [NSThread detachNewThreadWithBlock:^{
        NSThread.currentThread.name = @"子线程a";
        int age1, age2;
        NSLog(@"**** Enter p1.age and p2.age:");
        while (scanf("%i %i", &age1, &age2)) {
            printf("**** p1.age:%d p2.age:%d \n", age1, age2);

            //kvo，自动触发
            self.p1.age = age1;
            self.p2.age = age2;

            NSLog(@"**** Enter p1.age and p2.age:");
        }
//        char *str;
//        while (gets(str)) { printf("\n You enterd:"); puts(str); }
    }];
}

@end
