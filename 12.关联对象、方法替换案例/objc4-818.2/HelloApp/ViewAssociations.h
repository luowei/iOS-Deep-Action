//
//  ViewAssociations.h
//  HelloApp
//
//  Created by Luo Wei on 2021/1/16.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickCallBack)(UIButton *);

@interface UIButton (ClickAction)

- (void)handleClickCallBack:(ButtonClickCallBack)callBack;

@end


@interface UIView(ErrorToast)
@property (nonatomic,strong) UIView  *errorToastView;

@end
