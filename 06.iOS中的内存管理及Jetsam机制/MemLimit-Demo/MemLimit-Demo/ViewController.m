//
//  ViewController.m
//  MemLimit-Demo
//
//  Created by Luo Wei on 2021/1/10.
//  Copyright © 2021 Luo Wei. All rights reserved.
//
// 获取应用的OOM值

//iOS13系统os/proc.h中提供了新的API，可以查看当前可用内存
#import <os/proc.h>
extern size_t os_proc_available_memory(void);


#import "ViewController.h"
#import <mach/mach.h>

#define kOneMB  1048576

@interface ViewController (){
    NSTimer *timer;

    int allocatedMB;
    Byte *p[10000];
    
    int physicalMemorySizeMB;
    int memoryWarningSizeMB;
    int memoryLimitSizeMB;
    BOOL firstMemoryWarningReceived;
}

@end

@implementation ViewController

+ (CGFloat)availableSizeOfMemory {
    if (@available(iOS 13.0, *)) {
        return os_proc_available_memory() / 1024.0 / 1024.0;
    }
    return -1.f;
}
+ (int)limitSizeOfMemory {
    if (@available(iOS 13.0, *)) {
        task_vm_info_data_t taskInfo;
        mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
        kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&taskInfo, &infoCount);

        if (kernReturn != KERN_SUCCESS) {
            return 0;
        }
        return (int)((taskInfo.phys_footprint + os_proc_available_memory()) / 1024.0 / 1024.0);
    }
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"availableSizeOfMemory:%i",[self.class limitSizeOfMemory]);
    NSLog(@"limitSizeOfMemory:%i",[self.class limitSizeOfMemory]);
    
    physicalMemorySizeMB = (int)([[NSProcessInfo processInfo] physicalMemory] / kOneMB);
    firstMemoryWarningReceived = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        
    if (firstMemoryWarningReceived == NO) {
        return ;
    }
    memoryWarningSizeMB = [self.class usedSizeOfMemory];
    firstMemoryWarningReceived = NO;
}

- (IBAction)memoryLimitTest:(UIButton *)button {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(allocateMemory) userInfo:nil repeats:YES];
}

//分配内存
- (void)allocateMemory {
    
    p[allocatedMB] = malloc(kOneMB);
    memset(p[allocatedMB], 0, kOneMB);
    allocatedMB += 1;
    
    memoryLimitSizeMB = [self.class usedSizeOfMemory];
    if (memoryWarningSizeMB && memoryLimitSizeMB) {
        NSLog(@"----- memory warnning:%dMB, memory limit:%dMB", memoryWarningSizeMB, memoryLimitSizeMB);
    }
}

//使用内存占用的大小
+ (int)usedSizeOfMemory {
    task_vm_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&taskInfo, &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    return (int)(taskInfo.phys_footprint / kOneMB);
}

@end
