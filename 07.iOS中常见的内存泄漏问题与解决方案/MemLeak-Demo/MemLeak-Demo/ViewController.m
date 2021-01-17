//
//  ViewController.m
//  MemLeak-Demo
//
//  Created by Luo Wei on 2021/1/12.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <OOMDetector/OOMDetector.h>
#import "ViewController.h"
#import "AViewController.h"


#define kTenMB  1048576 * 10
@implementation TableView
- (instancetype)init {
    self = [super init];
    if (self) {
        //分配 10MB 内存
        self.space = malloc(kTenMB);
        memset(self.space, 0, kTenMB);
    }
    return self;
}
-(void)sayHello {
    NSLog(@"Hello!");
}
- (void)dealloc {
    NSLog(@"=== %s",__func__);
    free(self.space);
}
@end

@implementation TableViewController
- (void)dealloc {
    NSLog(@"=== %s",__func__);
}
@end



@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // ---- 自我强引用 ----
//    TableView *tableView = [TableView new];
//    tableView.subTableView = tableView;

    // ---- 相互引用 ----
//    TableView *tableView = [TableView new];
//    TableViewController *tVC = [TableViewController new];
//    tableView.delegate = tVC;
//    tVC.tableView = tableView;

}

- (IBAction)aBtnAction:(UIButton *)sender {
    AViewController *aViewController = [AViewController new];
    [self.navigationController pushViewController:aViewController animated:YES];
}

- (IBAction)checkBtnAction:(UIButton *)sender {
//    [[OOMDetector getInstance] executeLeakCheck:^(NSString *leakStack, size_t total_num){
//        NSLog(@"==== 内存泄漏检测结果：\n,total_num:%lu \n leakStack:\n%@\n",total_num,leakStack);
//    }];
}

@end
