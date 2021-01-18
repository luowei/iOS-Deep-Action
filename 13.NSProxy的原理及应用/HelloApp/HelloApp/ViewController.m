//
//  ViewController.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "LWProxy.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic) CFTimeInterval beginTime;
@property (nonatomic) UIColor *randomColor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];

    id proxy = [LWProxy proxyForObject:self];
    self.displayLink = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(updateBgColor)];
    //self.displayLink.paused = YES;
    
    [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
    
    self.randomColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    [self startAnimation];
}


-(void)updateBgColor {
    CFTimeInterval now = CACurrentMediaTime();
    
//    CGFloat hsba1[4]; //定义一个大小为4的数组
//    [self.view.backgroundColor getHue:&hsba1[0] saturation:&hsba1[1] brightness:&hsba1[2] alpha:&hsba1[3]];
    
    CGFloat rgba1[4];
    [self.view.backgroundColor getRed:&rgba1[0] green:&rgba1[1] blue:&rgba1[2] alpha:&rgba1[3]];
    CGFloat rgba2[4];
    [self.randomColor getRed:&rgba2[0] green:&rgba2[1] blue:&rgba2[2] alpha:&rgba2[3]];
    
    CGFloat duration = 0.5f;
    CGFloat percentage = (now-self.beginTime)/duration;
    CGFloat rgba[4] = {
        rgba1[0] + (rgba2[0] - rgba1[0]) * percentage,
        rgba1[1] + (rgba2[1] - rgba1[1]) * percentage,
        rgba1[2] + (rgba2[2] - rgba1[2]) * percentage,
        rgba1[3] + (rgba2[3] - rgba1[3]) * percentage,
    };
    
    NSLog(@"== color r:%f,g:%f,b:%f,a:%f",rgba[0],rgba[1],rgba[2],rgba[3]);
    self.view.backgroundColor = [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
    
    if(now - self.beginTime >= duration){ //2.5秒后，生成一个新颜色
        self.randomColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
        self.beginTime = CACurrentMediaTime();
    }
}

-(void)dealloc {
    NSLog(@"== %s",__FUNCTION__);
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)startAnimation{
   self.beginTime = CACurrentMediaTime();
   self.displayLink.paused = NO;
}

//- (void)stopAnimation{
//  self.displayLink.paused = YES;
//  [self.displayLink invalidate];
//  self.displayLink = nil;
//}

@end
