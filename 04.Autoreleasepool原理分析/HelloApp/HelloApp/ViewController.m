//
//  ViewController.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/7.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSString *str = [NSString stringWithFormat:@"Hello World"];
    //设置一个weak的引用来观察str
    reference = str;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"== %@", reference); // Console: Hello World
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"== %@", reference); // Console: (null)
}


@end
