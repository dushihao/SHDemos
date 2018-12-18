//
//  HSLinkAlertView.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/9/10.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import "HSLinkAlertView.h"
#import "Masonry.h"

static NSString * const gotItString = @"  已阅读并同意上述内容";
static inline NSNumber * numberWithFloat(CGFloat a) {
    return [NSNumber numberWithFloat:a];
}

@interface HSLinkAlertView()
{
    CGFloat _marginWidth;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *separatorView_2;
@property (nonatomic, strong) UIView *separatorView_3;

@property (nonatomic, strong) NSMutableArray *checkBoxs;

@end

@implementation HSLinkAlertView

#pragma mark - Initialization
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message links:(NSArray *)links {
    return [[self alloc] initWithTitle:title message:message links:links];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message links:(NSArray *)links {
    
    self.title = title;
    self.message = message;
    self.links = links;
    self = [super init];
    if (self) {}
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _marginWidth = 21; // 左右间距
        self.checkBoxs = [NSMutableArray arrayWithCapacity:5];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    //label文字布局属性
    NSParagraphStyle *paraStyle = [self createParagraphStyle];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 7.0;
    contentView.backgroundColor = [UIColor whiteColor];
    _contentView = contentView;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.greaterThanOrEqualTo(@105);
        make.width.equalTo(self.mas_width).multipliedBy(0.75);
    }];
    
    if (_title) {
        _titleLabel = [self creatLabelWithText:_title textColor:HsColorWithHexStr(@"#414141") titleFont:FONT(18) textAlignment:NSTextAlignmentCenter];
        [contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(contentView.mas_top).offset(21);
            make.height.equalTo(@18);
        }];
    }
    
    if (_message.length != 0) {
        _messageLabel = [self creatLabelWithText:_message textColor:HsColorWithHexStr(@"#414141") titleFont:FONT(16) textAlignment:NSTextAlignmentLeft];
        [contentView addSubview:_messageLabel];
        
        CGFloat messageLabelHeight = [self calculateLabelHeight:_message withParaStyle:paraStyle withFontSize:16.0];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(21);
            make.right.equalTo(contentView).offset(-21);
            make.top.equalTo(self->_titleLabel.mas_bottom).offset(16);
            make.height.equalTo(numberWithFloat(messageLabelHeight));
        }];
    }
    
    // 链接部分
    __block UIButton *linkButton;
    __block CGFloat linkButtonHeight = 0;
    __block UIButton *checkBox;
    __block CGFloat tempHeight = _message.length == 0 ? 16 : 10;
    UIView *referenceView = _message.length == 0 ? self.titleLabel : self.messageLabel;
    [self.links enumerateObjectsUsingBlock:^(NSString *link, NSUInteger idx, BOOL * _Nonnull stop) {
        linkButton = [self createUnderLineButtonWithTitle:link titleColor:HsColorWithHexStr(@"#4685e3") titleFont:FONT(16) selector:@selector(linkButtonClick:)];
        linkButton.tag = idx;
        [contentView addSubview:linkButton];
        
        checkBox = [self createButtonWithTitle:gotItString titleColor:HsColorWithHexStr(@"#414141") titleFont:FONT(16) selector:@selector(checkButtonClick:)];
        [checkBox setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [contentView addSubview:checkBox];
        [self.checkBoxs addObject:checkBox];
        
        CGFloat pading = linkButtonHeight + 10 + 23 + 24;
        if (idx != 0) tempHeight += pading;
        linkButtonHeight = [self calculateLabelHeight:link withParaStyle:paraStyle withFontSize:16.0];
        [linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(21);
            make.right.equalTo(contentView).offset(-21);
            make.height.equalTo(numberWithFloat(linkButtonHeight));
            make.top.equalTo(referenceView.mas_bottom).offset(tempHeight);
        }];
        [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(21);
            make.top.equalTo(linkButton.mas_bottom).offset (11);
            make.height.equalTo(@23);
        }];
    }];
    
    //分割线2
    _separatorView_2 = [[UIView alloc]init];
    _separatorView_2.backgroundColor = [HsConfigration uiColorFromString:@"#dddddd"];
    [contentView addSubview:_separatorView_2];
    [_separatorView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.equalTo(contentView);
        make.top.equalTo(checkBox.mas_bottom).offset(25);
    }];
    
    //分割线3
    _separatorView_3 = [[UIView alloc]init];
    _separatorView_3.backgroundColor = [HsConfigration uiColorFromString:@"#dddddd"];
    [contentView addSubview:_separatorView_3];
    [_separatorView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(self->_separatorView_2.mas_bottom);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    //确认按钮
    _confirmBtn = [self createButtonWithTitle:@"确定" titleColor:HsColorWithHexStr(@"#f24957") titleFont:FONT(18) selector:@selector(confirmClick)];
    [_contentView addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_separatorView_2.mas_bottom);
        make.right.bottom.equalTo(contentView);
        make.left.equalTo(self->_separatorView_3.mas_right);
        make.height.equalTo(@50);
    }];
    //取消按钮
    _cancelBtn = [self createButtonWithTitle:@"取消" titleColor:HsColorWithHexStr(@"#414141") titleFont:FONT(18) selector:@selector(cancelClick)];
    [_contentView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_separatorView_2.mas_bottom);
        make.left.bottom.equalTo(contentView);
        make.right.equalTo(self->_separatorView_3.mas_left);
        make.height.equalTo(@50);
    }];
}

#pragma mark - UI
- (UILabel *)creatLabelWithText:(NSString *)text
                      textColor:(UIColor *)textColor
                       titleFont:(UIFont *)font
                   textAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                         titleFont:(UIFont *)titleFont
                          selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = titleFont;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)createUnderLineButtonWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   titleFont:(UIFont *)titleFont
                                    selector:(SEL)selector
{
    UIButton *attributedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    attributedButton.titleLabel.numberOfLines = 0;
    attributedButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    attributedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSFontAttributeName value:titleFont range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:titleColor range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [attributedButton setAttributedTitle:str forState:UIControlStateNormal];
    return attributedButton;
}

- (NSParagraphStyle *)createParagraphStyle {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3.5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    return paraStyle;
}

#pragma mark - UIControl Event
- (void)confirmClick {
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(linkAlertView:dismissWithClickedButtonIndex:checkCount:)]) {
        [self.delegate linkAlertView:self dismissWithClickedButtonIndex:1 checkCount:[self checkCount]];
    }
}

- (void)cancelClick {
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(linkAlertView:dismissWithClickedButtonIndex: checkCount:)]) {
        [self.delegate linkAlertView:self dismissWithClickedButtonIndex:0 checkCount:[self checkCount]];
    }
}

- (void)linkButtonClick:(UIButton *)linkButton {
    NSInteger selectTag = linkButton.tag;
    
    if ([self.delegate respondsToSelector:@selector(linkAlertView:didSelectLinkAtIndex:)]) {
        [self.delegate linkAlertView:self didSelectLinkAtIndex:selectTag];
    }
}

- (void)checkButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - Show & Dismiss
- (void)show {
    UIWindow *delegateWindow = [UIApplication sharedApplication].delegate.window;
    [delegateWindow addSubview:self];
    self.frame = delegateWindow.bounds;
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark -
- (NSInteger)checkCount {
    NSInteger count = 0;
    for (UIButton *checkBox in self.checkBoxs) {
        if (checkBox.isSelected) count ++;
    }
    return count;
}

//计算富文本label高度
- (CGFloat)calculateLabelHeight:(NSString *)str withParaStyle:(NSParagraphStyle *)paraStyle withFontSize:(CGFloat)fontSize
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    CGFloat textWidth = keyWindow.bounds.size.width/4*3-_marginWidth*2;
    CGSize textMaxSize = CGSizeMake(textWidth, CGFLOAT_MAX);
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paraStyle};
    CGSize textSize = [str boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    
    CGFloat labelHeight = 0;
    //判断行数与是否存在中文，当行数为一行，并且存在中文时，需要将计算结果的高度减去行间距。此时才为正确文本正确高度。
    if (textSize.height < fontSize*2)
    {
        if ([self containChinese:str]) { //如果包含中文
            labelHeight = fontSize;
        } else {
            labelHeight = textSize.height;
        }
    } else {
        labelHeight = textSize.height + 2;
    }
    
    return labelHeight;
}

//判断如果包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
