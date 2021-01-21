//
//  KVCDemo.h
//  RunTestsOnIOS
//
//  Created by Luo Wei on 2021/1/21.
//  Copyright © 2021 JK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    float x, y, z;
} Score; //成绩

@interface KVCPerson : NSObject {
//kvc设置会按照setKey、_setKey 方法顺序查找；取值按照 getKey、key、iskey、_key顺序查找方法.
//kvc访问会按照 _key、_isKey、key、iskey的顺序查找成员变量,找到直接复制,未找到报错NSUnkonwKeyException;
@public
//    NSString *_name;
//    NSString *_isName;
    NSString *name;
    NSString *isName;

    int _age;
    int _isAge;
    int age;
    int isAge;

    NSArray<NSString *> *xx_friends;
    NSDictionary<NSString *,KVCPerson *> *xx_students;
}

//@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) KVCPerson *son;

@property (nonatomic) Score score;
//@property (nonatomic, strong) NSArray<NSString *> *friends;

@end



@interface KVCViewController : NSObject
@property(nonatomic, strong) KVCPerson *p1;
@property(nonatomic, strong) KVCPerson *p2;

//测试KVC
-(void)testKVC;

@end
