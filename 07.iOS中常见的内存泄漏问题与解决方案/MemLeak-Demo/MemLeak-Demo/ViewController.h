//
//  ViewController.h
//  MemLeak-Demo
//
//  Created by Luo Wei on 2021/1/12.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewController;

@interface TableView : NSObject
@property(nonatomic) Byte *space;

@property(nonatomic, strong) TableView *subTableView;

@property(nonatomic, strong) TableViewController *delegate;

@property(nonatomic, copy) void (^block)();
-(void)sayHello;
@end

@interface TableViewController : NSObject
@property(nonatomic, strong) TableView *tableView;
@end

@interface ViewController : UIViewController


@end

