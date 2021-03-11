//
//  ViewController.m
//  Kqueue-Demo
//
//  Created by Luo Wei on 2021/2/21.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "ViewController.h"
#import "FileChangeObserver.h"

@interface ViewController ()<FileChangeObserverDelegate>

@property(nonatomic, strong) FileChangeObserver *fileObserver;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *txtPath = [self getTxtFilePath];

    NSURL *txtURL = [NSURL fileURLWithPath:txtPath];
    enum FileChangeNotificationType typeMask = kFileChangeType_Write|kFileChangeType_Delete;
    self.fileObserver = [FileChangeObserver observerForURL:txtURL types:typeMask delegate:self];
}

- (void)dealloc {
    [self.fileObserver invalidate];
}


#pragma mark - FileChangeObserverDelegate

- (void)fileChanged:(FileChangeObserver *)observer typeMask:(enum FileChangeNotificationType)type{
    if (type != 0) {
        NSLog(@"== 监听到文件变化了");
    }
}

- (IBAction)writeBtnAction:(id)sender {
    NSString *txtPath = [self getTxtFilePath];
    NSURL *txtURL = [NSURL fileURLWithPath:txtPath];

    NSError *error;
    NSString* txt = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:&error];
    if(error){
        NSLog(@"文件读取失败,error:%@",error);
        return;
    }
    
    txt = [txt stringByAppendingFormat:@"\n%@", [self randomStringWithLength:10]];
    
    BOOL ok = [txt writeToURL:txtURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(!ok){
        NSLog(@"文件写入失败,error:%@",error);
    }
}

//- (IBAction)deleteBtnAction:(id)sender {
//    NSString *txtPath = [self getTxtFilePath];
//    if([NSFileManager.defaultManager fileExistsAtPath:txtPath]){
//        NSError *error;
//        [NSFileManager.defaultManager removeItemAtPath:txtPath error:&error];
//        if(error){
//            NSLog(@"文件删除失败,error:%@",error);
//        }
//    }
//}

- (NSString *)getTxtFilePath {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *txtPath = [documentsDir stringByAppendingPathComponent:@"test.txt"];

    //拷贝文件
    if(![NSFileManager.defaultManager fileExistsAtPath:txtPath]){
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
        NSError *error;
        [NSFileManager.defaultManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
        if(error){
            NSLog(@"文件拷贝失败,error:%@",error);
        }
    }

    return txtPath;
}

-(NSString *)randomStringWithLength: (NSUInteger) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t) letters.length)]];
    }
    return randomString;
}




@end
