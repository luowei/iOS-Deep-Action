//
//  ViewController.m
//  RunLoop-Demo
//
//  Created by Luo Wei on 2021/1/23.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "ViewController.h"

@interface MyView : UIView
@end
@implementation MyView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"== %s",__FUNCTION__);
}
@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MyView *myView;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //PerformSelectors同样是触发Source0事件
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:YES];
//    });
//    
//    //定时器，NSTimer 触发Timer
//    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"NSTimer ---- timer调用了");
//    }];
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

//    //添加手势，测试Observer _UIGestureRecognizerUpdateObserver
//    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
//    [self.view addGestureRecognizer:longRecognizer];
}

//触摸事件确实是会触发Source0事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了屏幕");

//    //测试界面更新回调 CA::Transaction::observer_callback
//    self.myView.bounds = CGRectMake(0, 0, 100 + arc4random() % 100, 100 + arc4random() % 100);
//    self.myView.center = CGPointMake(50 + arc4random() % 150, 50 + arc4random() % 300);
//    [self.myView setNeedsLayout];

    //RunLoop的6种状态
    [self showRunLoopActivity];
}

-(void)test{
    NSLog(@"%s",__FUNCTION__);
}

//RunLoop的6种状态
-(void)showRunLoopActivity {
    //创建监听者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(
            CFAllocatorGetDefault(),
            kCFRunLoopAllActivities,
            YES,
            0,
            ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;

            default:
                break;
        }
    });

    // 给RunLoop添加监听者
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

    //带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
    CFRelease(observer);
}

-(void)dealloc {
    
}

@end
