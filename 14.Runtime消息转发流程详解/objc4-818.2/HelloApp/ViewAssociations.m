//
//  ViewAssociations.m
//  HelloApp
//
//  Created by Luo Wei on 2021/1/16.
//

#import <objc/runtime.h>
#import "ViewAssociations.h"


static NSString *btnActionKey = @"btnAction";

@implementation UIButton (ClickAction)

- (void)handleClickCallBack:(ButtonClickCallBack)callBack {
    objc_setAssociatedObject(self, &btnActionKey, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    ButtonClickCallBack callBack = objc_getAssociatedObject(self, &btnActionKey);
    if (callBack) {
        callBack(self);
    }
}

@end

@implementation UIView(ErrorToast)

- (UIView*)errorToastView {
    UIView *errToastView = (UIView*)objc_getAssociatedObject(self, @selector(errorToastView));
    if (!errToastView) {
        errToastView = [UIView new];
        errToastView.backgroundColor = UIColor.redColor;
        [self addSubview:errToastView];
        
        errToastView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray <NSLayoutConstraint *>*constraints = @[
            [errToastView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [errToastView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-30],
            [errToastView.widthAnchor constraintEqualToConstant:60],
            [errToastView.heightAnchor constraintEqualToConstant:40],
        ];
        [NSLayoutConstraint activateConstraints:constraints];
        
        errToastView.hidden = YES;
        [self setErrorToastView:errToastView];
        
    }
    return errToastView;
}

- (void)setErrorToastView:(UIView *)errorToastView {
    objc_setAssociatedObject(self, @selector(errorToastView),errorToastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
