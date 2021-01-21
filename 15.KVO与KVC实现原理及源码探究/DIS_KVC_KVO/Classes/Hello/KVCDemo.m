//
//  KVCDemo.m
//  RunTestsOnIOS
//
//  Created by Luo Wei on 2021/1/21.
//  Copyright © 2021 JK. All rights reserved.
//

#import "KVCDemo.h"
#import <objc/runtime.h>

@implementation NSArray (KVCOperator)
//取中位数
- (NSNumber *)_medianForKeyPath:(NSString *)keyPath {
    //排序
    NSArray *sortedArray = [self sortedArrayUsingSelector:@selector(compare:)];
    double median;
    if (self.count % 2 == 0) {
        NSInteger index1 = sortedArray.count * 0.5;
        NSInteger index2 = sortedArray.count * 0.5 - 1;
        median = ([sortedArray[index1] doubleValue] + [sortedArray[index2] doubleValue]) * 0.5;
    } else {
        NSInteger index = (sortedArray.count-1) * 0.5;
        median = [sortedArray[index] doubleValue];
    }
    return [NSNumber numberWithDouble:median];
}
@end

@implementation KVCPerson

//- (NSString *)getName {
//    NSLog(@"== %s",__func__);
//    return @"ABC";
//}
//
//- (NSString *)name {
//    NSLog(@"== %s",__func__);
//    return @"ABC";
//}
//
//- (NSString *)isName {
//    NSLog(@"== %s",__func__);
//    return @"ABC";
//}
//
//- (void)setName:(NSString *)name {
//    NSLog(@"== %s",__func__);
//}

#pragma mark - KVC

//是否直接访问实例的成员变量
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}
+ (BOOL)d_accessInstanceVariablesDirectly {
    return YES;
}

//- (id)valueForUndefinedKey:(NSString *)key {
//    NSLog(@"== %s key:%@",__FUNCTION__,key);
//    return nil;
//}
//
//- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"== %s key:%@",__FUNCTION__,key);
//}

#pragma mark - 对KVC操作数组与集合的响应

-(NSInteger)countOfFriends {
    NSLog(@"==kvc %s",__FUNCTION__);
    return xx_friends.count;
}
//对应NSArray的objectAtIndexe
-(id)objectInFriendsAtIndex:(NSUInteger)index {
    NSLog(@"==kvc %s",__FUNCTION__);
    return xx_friends[index];
}
//对应NSArray的objectsAtIndexes
-(NSArray *)friendsAtIndexes:(NSIndexSet *)indexes {
    NSLog(@"==kvc %s",__FUNCTION__);
    return [xx_friends objectsAtIndexes:indexes];
}

-(NSInteger)countOfStudents {
    NSLog(@"==kvc %s",__FUNCTION__);
    return xx_students.count;
}
//对应于NSSet或NSDictionary类定义的原始方法
-(id)memberOfStudents:(id)key{
    NSLog(@"==kvc %s",__FUNCTION__);
    return xx_students[key];
}
-(NSEnumerator *)enumeratorOfStudents{
    NSLog(@"==kvc %s",__FUNCTION__);
    return [xx_students objectEnumerator];
}

#pragma mark - 属性验证

-(BOOL)validateName:(inout id *)name error:(out NSError **)err {
    if([*name isEqualToString:@"ABC"]){
        return YES;
    }else{
        *err = [NSError errorWithDomain:@"validateName" code:-1 userInfo:@{@"msg":@"name值不是 ABC,验证失败。"}];
        return NO;
    }
}



+(instancetype)random{
    KVCPerson *p = [KVCPerson new];
    p->name = [NSString stringWithFormat:@"p_%02d",rand()%100];
    p.age = 5 + rand() % 80;
    return p;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"Person(%p) name:%@ age:%d",self,self->name,self.age];
}

@end


@implementation KVCViewController

- (instancetype)init {
    self.p1 = [KVCPerson new];
    self.p1->name = @"aaa";
    self.p1.age = 1;
    self.p2 = [KVCPerson new];
    self.p2->name = @"bbb";
    self.p2.age = 2;
    self.p1.son = self.p2;

    return self;
}

//测试KVC
-(void)testKVC {

    //KVC 取值
//    [self.p1 d_setValue:@"xxxx" forKeyPath:@"name"];
    NSLog(@"== name:%@",[self.p1 valueForKey:@"name"]);

//    //KVC 结构体赋值
//    Score score = {1.f,2.f,3.f};
//    NSValue *value = [NSValue valueWithBytes:&score objCType:@encode(Score)];
//    [self.p1 setValue:value forKey:@"score"];
//    //KVC 结构体取值
//    NSValue *scorVal = [self.p1 valueForKey:@"score"];
//    Score scor;
//    [scorVal getValue:&scor];
//    NSLog(@"== Score x:%f y:%f z:%f",scor.x,scor.y,scor.z);


//    //属性验证,默认实现是去收到这个验证消息的对象(或keyPath中最后的对象)中根据 key 查找是否有对应的 validate<Key>:error: 方法实现，如果没有，验证默认成功，返回 YES。
//    NSError *error;
//    NSString *name = @"ABE";
//    if (![self.p1 validateValue:&name forKey:@"name" error:&error]) {
//        NSLog(@"== error:%@",error);
//    }


    //KVC 数组的聚合操作
//    NSArray *team = @[[KVCPerson random],[KVCPerson random],[KVCPerson random],];
//    NSNumber *avg_age = [team valueForKeyPath:@"@avg.age"];
//    NSNumber *sum_age = [team valueForKeyPath:@"@sum.age"];
//    NSNumber *max_age = [team valueForKeyPath:@"@max.age"];
//    NSNumber *min_age = [team valueForKeyPath:@"@min.age"];
//    NSNumber *count = [team valueForKeyPath:@"@count"];
//    NSLog(@"==team count:%d avg_age:%d sum_age:%d max_age:%d min_age:%d",count.intValue,avg_age.intValue,sum_age.intValue,max_age.intValue,min_age.intValue);
//
//    //KVC 将符合运算符条件的对象以一个NSArray实例返回
//    NSArray *union_names = [team valueForKeyPath:@"@unionOfObjects.name"];
//    NSArray *distinct_names = [team valueForKeyPath:@"@distinctUnionOfObjects.name"];
//    NSLog(@"==team union_names:%@ \ndistinct_names:%@",union_names,distinct_names);
//
    //如果集合中的对象都是NSNumber，右键路径可以用self
    NSArray *array = @[@1, @2, @3, @4, @5];
    NSNumber *sumAge = [array valueForKeyPath:@"@sum.self"];
    NSLog(@"==sumAge:%d",sumAge.intValue);
//
//    //自定义集合运算符
//    NSArray *list = @[@9, @7, @8, @2, @6, @3];
//    NSNumber *medianAge = [list valueForKeyPath:@"@median.self"];
//    NSLog(@"==medianAge:%d",[medianAge intValue]);


//        //KVC 操作数组或集合属性的几个函数
//        self.p1->xx_friends = @[@"a",@"b",@"c"];
//        id arr_val = [self.p1 valueForKey:@"friends"];
//        NSLog(@"== arr_val:%@",arr_val);
//        //KVC 操作不存在的 字典 属性
//        KVCPerson *stu1 = [KVCPerson new];
//        KVCPerson *stu2 = [KVCPerson new];
//        stu1->name = @"name_aa";
//        stu2->name = @"name_bb";
//        self.p1->xx_students = @{ @"aa":stu1,@"bb":stu2 };
//        id dic_var = [self.p1 valueForKeyPath:@"students.name"];
//        NSLog(@"== xx_students:%@",dic_var);

}

@end
