//
//  AViewController.m
//  MemLeak-Demo
//
//  Created by Luo Wei on 2021/1/12.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "AViewController.h"
#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface AViewController ()<WKScriptMessageHandler>
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, copy) void (^block)();
@property(nonatomic, strong) TableView *tableView;

@property(nonatomic, strong) NSThread *subThread;

@property(nonatomic, strong) WKWebViewConfiguration *configuration;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"A";
    self.view.backgroundColor = UIColor.greenColor;
    
// ---- Block ----
    
////    __weak typeof(self) wkSelf = self;
//    self.block = ^{
////        [self test];
////        NSLog(@"== title:%@",wkSelf.title);
//        NSLog(@"== title:%@",self.title);
//    };
//    self.block();
//
//    //tableView 不会释放内存漏泄
//    TableView *tableView = [TableView new];
//    tableView.block = ^{
//        [tableView sayHello];
//    };
    
    
// ---- NSTimer ----
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(test) userInfo:nil repeats:NO];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(test) userInfo:nil repeats:YES]; //会持有target,直到invalidate

//    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(test) userInfo:nil repeats:NO];
////    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
//
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 100, 300, 500)];
//    [self.view addSubview:textView];
//    NSString *text = @"Hello World!";
//    for(int i=0;i<8;i++){
//        text = [text stringByAppendingString:text];
//    }
//    textView.text = text;
    
    
// ------- performSelector --------
    
//    [self performSelector:@selector(test) withObject:nil afterDelay:0.2];
//    [self performSelector:@selector(test) withObject:nil afterDelay:1 inModes:@[UITrackingRunLoopMode]]; //leak
    
//    self.subThread = [[NSThread alloc] initWithBlock:^{
//        NSThread.currentThread.name = @"subThread子线程";
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
////        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:120]];
//        [runloop runMode:UITrackingRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:120]];
//
//    }];
//    [self.subThread start];
//    [self performSelector:@selector(test) onThread:self.subThread withObject:nil waitUntilDone:NO];
    
    
// ----- webview -----
    
//    //设置webView
//    [self setupWebView];
    
    
// ---- NSNotificationCenter ----
//        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(test) name:@"TestNotification" object:nil];
}

- (void)setupWebView {
    self.configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration.userContentController = [WKUserContentController new];
    [self.configuration.userContentController addScriptMessageHandler:self name:@"msgHandler"];

    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:self.configuration];
    [self.view addSubview:webview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.timer invalidate];
    
//    [self.configuration.userContentController removeScriptMessageHandlerForName:@"msgHandler"];
    
//    //iOS 9之前要手动调用这个removeObserver
//    [NSNotificationCenter.defaultCenter removeObserver:self name:@"TestNotification" object:nil];
    
    NSLog(@"==== %s",__func__);
}

- (void)dealloc {
    NSLog(@"==== %s %@",__func__,self);

}

-(void)test{
    NSLog(@"==== %s %@",__func__,self);

}


@end
