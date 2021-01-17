//
//  main.m
//  Hello_objc
//
//  Created by Luo Wei on 2020/12/5.
//

#import <Foundation/Foundation.h>
#import "objc.h"

int main(int argc, const char * argv[]) {
    
    NSObject *obj = [NSObject new];
    struct objc_object *objStruct = (__bridge struct objc_object *)obj;
    Class clazz = objStruct->isa;
    
    return 0;
}
