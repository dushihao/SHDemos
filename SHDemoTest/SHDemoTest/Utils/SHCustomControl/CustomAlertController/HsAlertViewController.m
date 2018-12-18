//
//  HsAlertViewController.m
//  SHDemoTest
//
//  Created by dush on 2018/11/2.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "HsAlertViewController.h"

#define Font(a) [UIFont systemFontOfSize:a]

static CGFloat const AlertContentMaxWidth = 270;

@interface HsAlertAction ()
@property (nonatomic, copy) alertAction handler;
@property (nonatomic, weak) HsAlertViewController *viewController;
@end

@implementation HsAlertAction

- (instancetype)initWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler {
    self = [super init];
    if (self) {
        self.title = title;
        self.style = style;
        self.handler = handler;
        
        self.button = [[UIButton alloc] init];
        [self updateButtonApperance];
        [self.button addTarget:self action:@selector(handelAlertActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (void)updateButtonApperance {
    self.button.backgroundColor = [UIColor whiteColor];
    [self.button setTitle:self.title forState:UIControlStateNormal];
    
    UIColor *titleColor = HsColorWithHexStr(@"#919191");
    if (self.style == HsAlertActionStyleDestructive) {
        titleColor = HsColorWithHexStr(@"#eb333b");
    } else if (self.style == HsAlertActionStyleCancel) {
        titleColor = HsColorWithHexStr(@"#919191");
    } else {
        titleColor = HsColorWithHexStr(@"#000000");
    }
    [self.button setTitleColor: titleColor forState:UIControlStateNormal];
}

- (void)handelAlertActionEvent:(UIButton *)sender {
    if (self.handler) {
        self.handler(self);
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end


@interface HsAlertViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) HsAlertAction *cancelAction; /// 取消action

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *headerScrollView;
@property (nonatomic, strong) UIScrollView *buttonScrollView;

@property (nonatomic, strong) UILabel *titleLabel; /// 标题
@property (nonatomic, strong) UILabel *contentLabel; /// 内容标签
@property (nonatomic, strong) UILabel *tipsLabel; /// 提示标签

@end

#pragma mark - transitionAnimation

@interface HsPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresented; // 1: presented 2: dismiss
@end

@implementation HsPresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (self.isPresented) {
        HsAlertViewController *toAlertController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [[transitionContext containerView] addSubview:toAlertController.view];
        toAlertController.view.alpha = 0;
        toAlertController.containerView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        [UIView animateWithDuration:duration delay:0 options:7<<16 animations:^{
            toAlertController.view.alpha = 1;
            toAlertController.containerView.alpha = 1;
            toAlertController.containerView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        HsAlertViewController *fromAlertController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromAlertController.view.alpha = 0;
            fromAlertController.containerView.alpha = 0;
        } completion:^(BOOL finished) {
            [fromAlertController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
}

@end

@implementation HsAlertViewController
@dynamic title;


/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
CG_INLINE CGRect
CGRectFlatted(CGRect rect) {
    return CGRectMake(flat(rect.origin.x), flat(rect.origin.y), flat(rect.size.width), flat(rect.size.height));
}

CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

CG_INLINE CGFloat
pixelOne() {
    return 1 / [[UIScreen mainScreen] scale];
}

#pragma mark - initialization

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                         tips:(NSString *)tips
               preferredStyle:(HsAlertControllerStyle)preferredStyle
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.alertTitle = title;
        self.message = message;
        self.tips = tips;
        // TODO:目前只有alert style 类型
        self.preferredStyle = preferredStyle;
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message tips:(NSString *)tips preferredStyle:(HsAlertControllerStyle)preferredStyle {
   return [[self alloc] initWithTitle:title message:message tips:tips preferredStyle:preferredStyle];
}
    
+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(HsAlertControllerStyle)preferredStyle
{
    return [[self alloc] initWithTitle:title message:message tips:nil preferredStyle:preferredStyle];
}

- (void)commonInit {
    //
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    self.titleColor = [UIColor blackColor];
    self.titleFont = [UIFont boldSystemFontOfSize:18];
    
    self.containerView = [UIView new];
    self.headerScrollView = [[UIScrollView alloc] init];
    self.buttonScrollView = [[UIScrollView alloc] init];
    
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.headerScrollView.backgroundColor = [UIColor whiteColor];
    self.buttonScrollView.backgroundColor = HsColorWithHexStr(@"#dddddd");
    
    [self updateCornerRadius];
}

# pragma mark - Getter & Setter

- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle;
    [self.headerScrollView addSubview:self.titleLabel];
    [self updateAlertLabel];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    [self.headerScrollView addSubview:self.contentLabel];
    [self updateContentLabel];
}

- (void)setTips:(NSString *)tips {
    _tips = tips;
    self.tipsLabel.text = tips;
    [self.headerScrollView addSubview:self.tipsLabel];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self updateAlertLabel];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self updateAlertLabel];
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        UIFont *titleButtonFont = FONT(18);
        _titleLabel.font = titleButtonFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        UIFont *messageFont = FONT(16);
        _contentLabel.font = messageFont;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = HsColorWithHexStr(@"#919191");
        _tipsLabel.font = FONT(15);
    }
    return _tipsLabel;
}

- (NSMutableArray<HsAlertAction *> *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _actions;
}

# pragma mark - UI
- (void)updateAlertLabel {
    self.titleLabel.text = _alertTitle;
    self.titleLabel.font = self.titleFont;
    self.titleLabel.textColor = self.titleColor;
}

- (void)updateContentLabel {
    if (!self.contentLabel || self.contentLabel.hidden) { return; }
    
    NSMutableParagraphStyle *pgStyle = [[NSMutableParagraphStyle alloc] init];
    pgStyle.lineSpacing = 3;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_message attributes:@{NSParagraphStyleAttributeName : pgStyle}];
    NSArray *labels = [self hintLabels:_message];
    for (NSString *labelString in labels) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:HsColorWithHexStr(@"#919191") range:[_message rangeOfString:labelString]];
    }
    self.contentLabel.attributedText = attributedString;
}

- (void)updateCornerRadius {
    self.containerView.layer.cornerRadius = 7;
    self.containerView.clipsToBounds = YES;
}

# pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.containerView];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.containerView addSubview:self.headerScrollView];
    [self.containerView addSubview:self.buttonScrollView];
}

#pragma mark - Layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    BOOL hasMessage = (self.contentLabel.text && ![self.contentLabel.text isEqualToString:@""] && !self.contentLabel.hidden);
    BOOL hasTips = (self.tipsLabel.text.length != 0 && !self.tipsLabel.hidden);
    
    UIEdgeInsets alertHeaderInset = UIEdgeInsetsMake(20, 15, 22, 15);
    CGFloat contentPaddingLeft = alertHeaderInset.left;
    CGFloat contentPaddingRight = alertHeaderInset.right;
    CGFloat contentPaddingTop = alertHeaderInset.top;
    CGFloat contentPaddingBottom = alertHeaderInset.bottom;
    CGFloat contentOriginY = contentPaddingTop;
    
    self.containerView.center = self.view.center;
    self.containerView.bounds = CGRectMake(0, 0, AlertContentMaxWidth, 0);
    self.headerScrollView.frame = CGRectMake(0, 0, self.containerView.width, 0);
   
    // title
    CGFloat titleLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelLimitWidth, CGFLOAT_MAX)];
    self.titleLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, titleLabelLimitWidth, titleLabelSize.height));
    BOOL a = [_message containsString:@"\n"];
    contentOriginY = CGRectGetMaxY(self.titleLabel.frame) + (a ? contentPaddingBottom : 9);
    
    // message
    CGFloat messageBottom = 27;
    if (hasMessage) {
        CGFloat messageLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - contentPaddingLeft - contentPaddingRight;
        CGSize messageLabelSize = [self.contentLabel sizeThatFits:CGSizeMake(messageLabelLimitWidth, CGFLOAT_MAX)];
        if (self.contentLabel.textAlignment == NSTextAlignmentCenter) {
            self.contentLabel.frame = CGRectFlatted(CGRectMake(contentPaddingLeft, contentOriginY, messageLabelLimitWidth, messageLabelSize.height));
        } else {
            // alignment Left
            self.contentLabel.frame = CGRectFlatted(CGRectMake((CGRectGetWidth(self.headerScrollView.bounds) - messageLabelSize.width) / 2,
                                                               contentOriginY,
                                                               messageLabelSize.width,
                                                               messageLabelSize.height));
        }
        
        contentOriginY = CGRectGetMaxY(self.contentLabel.frame) + messageBottom;
    }
    
    if (hasTips) {
        UIEdgeInsets tipEdge = UIEdgeInsetsMake(12, 21, 27, 21);
        CGFloat tipLabelLimitWidth = CGRectGetWidth(self.headerScrollView.bounds) - 2 * tipEdge.left;
        CGSize tipLabelSize = [self.tipsLabel sizeThatFits:CGSizeMake(tipLabelLimitWidth, CGFLOAT_MAX)];
        self.tipsLabel.frame = CGRectFlatted(CGRectMake(tipEdge.left, contentOriginY - messageBottom + tipEdge.top, tipLabelLimitWidth, tipLabelSize.height));
        contentOriginY = CGRectGetMaxY(self.tipsLabel.frame) + tipEdge.bottom;
    }
    
    // headerScrollView layout
    self.headerScrollView.height = contentOriginY;
    self.headerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.headerScrollView.bounds), contentOriginY);
    contentOriginY = CGRectGetMaxY(self.headerScrollView.frame);
    
    // 按钮布局
    self.buttonScrollView.frame = CGRectMake(0, contentOriginY, CGRectGetWidth(self.containerView.bounds), 0);
    contentOriginY = 0;
    // actions
    CGFloat alertButtonHeight = 50;
    NSArray *orderedActions = [self orderedAlertAction:self.actions];
    if (self.actions.count > 0) {
        if (self.actions.count == 2) {
            HsAlertAction *action1 = orderedActions[0];
            HsAlertAction *action2 = orderedActions[1];
            action1.button.frame = CGRectMake(0, contentOriginY + pixelOne(), self.buttonScrollView.width / 2, alertButtonHeight);
            action2.button.frame = CGRectMake(CGRectGetMaxX(action1.button.frame) + pixelOne(), contentOriginY + pixelOne(), self.buttonScrollView.width / 2, alertButtonHeight);
            contentOriginY = CGRectGetMaxY(action1.button.frame);
        } else {
            for (HsAlertAction *action in orderedActions) {
                action.button.frame = CGRectMake(0, contentOriginY + pixelOne(), self.buttonScrollView.width, alertButtonHeight);
                contentOriginY = CGRectGetMaxY(action.button.frame);
            }
            
        }
    }
    // 按钮scrollView的布局
    self.buttonScrollView.height = contentOriginY;
    self.buttonScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.buttonScrollView.bounds), contentOriginY);
    
    // finally layout
    CGFloat screen_width = self.view.width;
    CGFloat screen_height = self.view.height;
    CGFloat contentHeight = CGRectGetHeight(self.headerScrollView.bounds) + CGRectGetHeight(self.buttonScrollView.bounds);
    CGRect containerRect = CGRectMake((CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.containerView.bounds)) / 2,
                                      (screen_height - contentHeight) / 2,
                                      CGRectGetWidth(self.containerView.bounds),
                                      contentHeight);
    self.containerView.frame = CGRectFlatted(CGRectApplyAffineTransform(containerRect, self.containerView.transform));
}

# pragma mark - operation
- (void)addAction:(HsAlertAction *)action {
    if (self.preferredStyle == HsAlertActionStyleCancel && self.cancelAction) {
        NSAssert(YES, @"同一个alertController不可以同时添加两个cancel按钮");
    }
    if (action.style == HsAlertActionStyleCancel) {
        self.cancelAction = action;
    }
    action.viewController = self;
    [self.buttonScrollView addSubview:action.button];
    [self.actions addObject:action];
}

- (NSArray *)orderedAlertAction:(NSArray *)actions {
    NSMutableArray *orderedActions = [[NSMutableArray alloc] initWithCapacity:5];
    [orderedActions addObjectsFromArray:actions];
    if (self.cancelAction) {// cancelAction 放在数组尾部
        [orderedActions removeObject:self.cancelAction];
        [orderedActions addObject:self.cancelAction];
    }
    return orderedActions;
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    // TODO:有需求在做
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    HsPresentAnimation *animation = [HsPresentAnimation new];
    animation.isPresented = YES;
    return animation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    HsPresentAnimation *animation = [HsPresentAnimation new];
    animation.isPresented = NO;
    return animation;
}

#pragma mark - Others
// 获取标签数组
- (NSArray *)hintLabels:(NSString *)message {
    NSArray *tempArray = [message componentsSeparatedByString:@"\n"];
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSString *string in tempArray) {
        [resultArr addObject:[string componentsSeparatedByString:@"："][0]];
    }
    return resultArr;
}
@end
