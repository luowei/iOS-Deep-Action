//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>


@implementation Person : NSObject

- (void)personInstanceMethod1 {
    NSLog(@"%s", __FUNCTION__);
}
- (int)appendName:(NSString *)name  {
    NSLog(@"== appendName:%@", name);
    return (int)name.length;
}



#pragma mark - 动态方法解析: Method Resolution

//类方法的动态解析过程中会调用到该方法
+(BOOL)resolveClassMethod:(SEL)sel{
    NSLog(@"== resolveInstanceMethod: %@", NSStringFromSelector(sel));

    if(sel ==@selector(appendString:)) { //动态方法实现
        class_addMethod([self class], sel, (IMP)dynamicAdditionMethodIMP,"v@:");
        return YES;
    }
    return[super resolveClassMethod:sel];
}

//实例方法的动态解析过程中会调用到该方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"== resolveInstanceMethod: %@", NSStringFromSelector(sel));

    if(sel ==@selector(appendString:)) {  //动态方法实现
//        class_addMethod([self class], sel, (IMP)dynamicAdditionMethodIMP,"v@:");
        
        IMP imp = class_getMethodImplementation(self.class, @selector(appendName:));
        class_addMethod([self class], sel, imp,"i@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

//自定义一个C实现方法
void dynamicAdditionMethodIMP(id self,SEL _cmd){
    NSLog(@"== dynamicAdditionMethodIMP");
}

 
 

#pragma mark - 快速转发: Fast Rorwarding

//重定向接收者
- (id)forwardingTargetForSelector:(SEL)sel {
   NSLog(@"== forwardingTargetForSelector");
   NSString *selectorString = NSStringFromSelector(sel);
   // 将消息转发给 NSMutableString 来处理
   if ([selectorString isEqualToString:@"appendString:"]) {
       return [NSMutableString string];
   }
   return [super forwardingTargetForSelector:sel];
}

 

#pragma mark - 完整消息转发: Normal Forwarding

//必须重新这个方法，消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象,返回nil上面方法不执行
- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if(!signature){
        //判断NSMutableString的实例是否能处理这个selector
        if ([NSMutableString instancesRespondToSelector:aSelector]){
            signature = [NSMutableString instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;

}

-(void)forwardInvocation:(NSInvocation*)anInvocation{
    NSLog(@"== forwardInvocation");

    if ([NSMutableString instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[NSMutableString string]];
    } else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
}


@end


int main(int argc, const char *argv[]) {
    @autoreleasepool {
        id person = [[Person alloc] init];
        //直接调用
        [person appendName:@"王五"];
        
//        [person appendString:@" Tom"];

        
        SEL sel = @selector(appendString:);

        //objc_msgSend 方式调用函数
        int returnValue1 = ((int (*)(id, SEL, NSString *))objc_msgSend) ((id)person, sel, @"李四 objc_msgSend");
        NSLog(@"objc_msgSend返回值： %d", returnValue1);

        //method_invoke 方式调用函数
        Method method = class_getInstanceMethod([person class], sel); // 获取Method
        int returnValue2 = ((int (*)(id, Method, NSString *))method_invoke) ((id)person, method, @"张三 method_invoke");
        NSLog(@"method_invoke返回值： %d", returnValue2);
        
    }
    return 0;
}


