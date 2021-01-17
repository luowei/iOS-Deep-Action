//
//  Header.h
//  objc
//
//  Created by Luo Wei on 2021/1/15.
//


@protocol Phonable <NSObject>
//在protocol中声明的属性只有getter和setter方法，没有属性变量，
//所以在使用它之前，需要使用@synthesize来合成实例变量
@property NSString *phone;

@end



@interface Person : NSObject<Phonable>
{ //花括号内的里实例变量
    
    NSString *_phone;  //默认是protected

@public  //公有成员，可以被外部函数访问，可以被继承
    NSString *p_name;

@package  //只能在当前框架中才能被访问，可以被继承
    NSString *_address;

@protected  //保护成员，不能被外部函数访问，可以被子类继承
    int _age;

@private   //私有成员，不能被外部的函数访问，也不能被子类继承
    int _salary;
    
}

//@property 声明属性
@property NSString *name;
@property NSString *address;
@property int age;
@property int salary;

@end

@interface Man : Person

@end


