//
//  main.m
//  Hello_Blocks
//
//  Created by Luo Wei on 2020/12/6.
//

#import <Foundation/Foundation.h>

//
//void testBlock1() {
//    NSLog(@"====blk1:%@",^{NSLog(@"Hello");});
//
//    void (^blk)(void) = ^{
//        NSLog(@"Hello");
//    };
//
//    blk();
//    NSLog(@"====blk1:%@",blk);
//
//}
//
//@interface Hello : NSObject
//-(NSString *)uname;
//@end
//@implementation Hello
//-(NSString *)uname{
//    return @"张三";
//}
//@end
//
//void testBlock2() {
//    //void *hello = (__bridge void *)([[Hello alloc] init]);
//    Hello *hello = [[Hello alloc] init];
//
//    //分配1个32字节的空间
//    void *p1 = calloc(1, 32);
//    void *p2 = calloc(1, 16);
//
//    void (^blk)(void) = ^{
////        NSLog(@"hello size:%lu",sizeof(hello)); //这样引入就还是__NSGlobalBlock__
//         NSLog(@"hello:%@",hello);  //这样引入就变成了__NSMallocBlock__
//
//        NSLog(@"p1:%lu p2:%lu",sizeof(p1),sizeof(p2));
//        // 如果此时调用free释放掉p1,p2，则相当于引入了自动变量
////         free(p1);
////         free(p2);
//    };
//
//    blk();
//    NSLog(@"====blk2:%@",blk);
//}
//
//void testBlock3() {
//    int a = 10;
//    void (^blk)(void) = ^{
//        NSLog(@"a:%i",a);
//    };
//
//    blk();
//    NSLog(@"====blk3:%@",blk);
//
//    NSLog(@"====blk3:%@",^{NSLog(@"a:%i",a);});
//}
//
//void testBlock4() {
//    int a = 10;
//    void (__weak ^blk)(void) = ^{
//        NSLog(@"a:%i",a);
//    };
//
//    blk();
//    NSLog(@"====blk4:%@",blk);
//}
//
//int global_var = 1;
//static int static_global_var = 2;
//void testBlock5() {
//
//    //静态变量
//    static int static_var = 3;
//    void (^blk)(void) = ^{
//        global_var *= 3;
//        static_global_var *= 3;
//        static_var *= 3;
//        NSLog(@"global_var：%i",global_var);
//        NSLog(@"static_global_var：%i",static_global_var);
//        NSLog(@"static_var：%i",static_var);
//    };
//    blk();
//    NSLog(@"====blk5:%@ static_var:%i",blk,static_var);
//}
//
//
//typedef int (^Block_t) (int);
//Block_t getBlock(int rate){
//    return ^(int count){ return rate * count; };
//}
//void testBlock6(){
//    Block_t blk = getBlock(3);
//    int count = blk(2);
//    NSLog(@"====blk6:%@ returnValue:%i",blk,count);
//}
//
//NSArray* getBlockList(){
//    int a = 10;
//    return @[
//        ^{NSLog(@"block list 0:%i",a);},
//        ^{NSLog(@"block list 1:%i",a);},
//    ];
//}
//void testBlock7(){
//    NSArray *blockList = getBlockList();
//    typedef void(^blk_t)(void);
//    blk_t blk = (blk_t)blockList.firstObject;
//    blk();
//    NSLog(@"====blk7:%@",blk);
//}


//全局变量
//int a = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //static int a = 10;
        __block int a = 10;
//        int a = 10;
        void (^block)(void) = ^void {
            a++;
           NSLog(@"==== a:%d",a);
        };
        a = 20;
        block();
        NSLog(@"== Block is %@", block);
        
        
//        testBlock1();
//        testBlock2();
//        testBlock3();
//        testBlock4();
//        testBlock5();
//        testBlock6();
//        testBlock7();
    }
    return 0;
}
