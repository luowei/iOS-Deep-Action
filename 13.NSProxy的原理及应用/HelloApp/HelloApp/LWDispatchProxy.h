//
//  LWDispatchProxy.h
//  HelloApp
//
//  Created by Luo Wei on 2021/1/18.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWDispatchProxy : NSProxy
+(instancetype)sharedInstance;
-(void)registerMethodWithTarget:(id)target;

@end

