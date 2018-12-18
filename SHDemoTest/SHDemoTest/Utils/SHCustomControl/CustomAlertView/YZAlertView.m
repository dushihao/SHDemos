//
//  YZAlertView.m
//  这到底是个什么鬼
//
//  Created by 从今以后 on 16/2/21.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "YZAlertView.h"

@interface YZAlertView ()


@end

@implementation YZAlertView

+ (instancetype)alertView
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:[self customView]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.subviews[0].center = ({
        CGPoint center = self.center;
        center.y = self.center.y;
        center;
    });
    
}

- (UIView *)customView
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-[YZAlertView customView] 方法需由子类重写"
                                 userInfo:nil];
    return nil;
}

- (void)show
{
//    UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self];

    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    NSString *visualFormats[] = { @"H:|[self]|", @"V:|[self]|" };
    for (int i = 0; i < 2; ++i) {
        [keyWindow addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:visualFormats[i]
                                                 options:kNilOptions
                                                 metrics:nil
                                                   views:views]];
    }

    self.alpha = 0.5;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickBg{
    [self dismiss];
}

@end
