//
//  KVODemo.h
//  RunTestsOnIOS
//
//  Created by Luo Wei on 2021/1/21.
//  Copyright © 2021 JK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVOPerson : NSObject {
@public
    NSString *_name;
    int _age;
    KVOPerson *_son;
    double _salary;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) KVOPerson *son;

@end

@interface KVOViewController : NSObject
@property(nonatomic, strong) KVOPerson *p1;
@property(nonatomic, strong) KVOPerson *p2;

//测试KVO
- (void)testKVO;
- (void)testKVO_OnOtherThread;

@end
