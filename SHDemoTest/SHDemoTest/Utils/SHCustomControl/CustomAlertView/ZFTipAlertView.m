//
//  ZFTipAlertView.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/22.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "ZFTipAlertView.h"

@interface ZFTipAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ZFTipAlertView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title
                       content:(NSString *)content
                    confirmStr:(NSString *)confirmStr
{
    ZFTipAlertView *alertView = [[self alloc] initWithTitle:title content:content confirmStr:confirmStr];
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                   confirmStr:(NSString *)confirmStr
{
    self.title = title;
    self.content = content;
    self.confirmStr = confirmStr;
    if (self = [super init]) {}
    return self;
}

- (void)commonInit
{
  
}

- (UIView *)customView {
    
    NSArray *arrays = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZFTipAlertView class]) owner:self options:nil];
    _conTentLabel.text = self.content;
    _titleLabel.text = self.title;
    return arrays[0];
}

@end
