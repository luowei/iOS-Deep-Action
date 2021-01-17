//
//  ViewController.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/17.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "ViewController.h"
#import "ViewAssociations.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (strong, nonatomic) UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.testBtn handleClickCallBack:^(UIButton *btn) {
        self.view.errorToastView.hidden = !self.view.errorToastView.hidden;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"==  %s", __FUNCTION__);
}


-(UIButton *)testBtn {
    if(!_testBtn){
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBtn setTitle:@"测试按钮" forState:UIControlStateNormal];
        [_testBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:UIColor.systemGreenColor];
        [self.view addSubview:_testBtn];
        _testBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
            [_testBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [_testBtn.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:100],
            [_testBtn.widthAnchor constraintEqualToConstant:120],
            [_testBtn.heightAnchor constraintEqualToConstant:40],
        ]];
    }
    return _testBtn;
}

@end



#pragma mark - Method Swizzling

@implementation ViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"== %s",__FUNCTION__);
        swizzleMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
    });
}


- (void)swizzled_viewDidAppear:(BOOL)animated {
    NSLog(@"==  %s", __FUNCTION__);
    
    //这里再调用原方法，起到hook的作用
    [self swizzled_viewDidAppear:animated];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
//    //第一种方式,尽量使用method_exchangeImplementations函数来交换，因为它是原子操作的，线程安全
//    method_exchangeImplementations(originalMethod, swizzledMethod);

    
//    //第二种方式，class_replaceMethod
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
    
    
    //第三种方式
    IMP originIMP =  method_getImplementation(originalMethod);
    IMP swizzledIMP =  method_getImplementation(swizzledMethod);
    method_setImplementation(swizzledMethod,originIMP);
    method_setImplementation(originalMethod, swizzledIMP);
    
//    //把swizzledMethod设置为空实现
//    method_setImplementation(swizzledMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
}


@end


