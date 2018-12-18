//
//  HsNoticeTooltipView.m
//  TZYJ_IPhone
//
//  Created by zhuqiongyao on 2018/6/14.
//

#import "HsNoticeTooltipView.h"

@interface HsNoticeTooltipView()
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIImageView *titleImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *alertLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *separatorView_1;
@property(nonatomic,strong)UIView *separatorView_2;
@property(nonatomic,strong)UIView *separatorView_3;
@property(nonatomic,assign)HsNoticeTooltipViewType type;
@property(nonatomic,assign)NSTextAlignment textAlignment;
@property(nonatomic,assign)CGFloat marginWidth;//留边宽度
@property(nonatomic,copy)NSString *imageName;//标题图标
@property(nonatomic,copy)NSString *title;//抬头文字
@property(nonatomic,copy)NSString *alert;//警示文字
@property(nonatomic,copy)NSString *content;//内容文字
@end

@implementation HsNoticeTooltipView

+ (instancetype)tipWithTitle:(NSString *)title
                       Alert:(NSString *)alert
                     Content:(NSString *)content
                  TitleImage:(NSString *)imageName
                       Style:(HsNoticeTooltipViewType)type
                 MarginWidth:(CGFloat)marginWidth
               TextAlignment:(NSTextAlignment)textAlignment
{
    return [[self alloc] initWithTitle:title withAlert:alert withContent:content withTitleImage:imageName withStyle:type withMarginWidth:marginWidth withTextAlignment:textAlignment];
}

- (instancetype)initWithTitle:(NSString *)title
                   withAlert:(NSString *)alert
                 withContent:(NSString *)content
              withTitleImage:(NSString *)imageName
                   withStyle:(HsNoticeTooltipViewType)type
             withMarginWidth:(CGFloat)marginWidth
           withTextAlignment:(NSTextAlignment)textAlignment
{
    _title = [title copy];
    _alert = [alert copy];
    _content = [content copy];
    _imageName = [imageName copy];
    _type = type;
    _marginWidth = marginWidth;
    _textAlignment = textAlignment;
    self = [self init];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    //整体输入框
    _backgroundView = [[UIView alloc]init];
    _backgroundView.layer.cornerRadius = 7;
    _backgroundView.backgroundColor = [HsConfigration uiColorFromString:@"#ffffff"];
    [self addSubview:_backgroundView];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    _backgroundView.frame = CGRectMake(keyWindow.width * 0.25/ 2, 0, keyWindow.width * 0.75, 105);
    
    //title
    if (_title != nil && ![_title isEqualToString:@""]) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [HsConfigration uiColorFromString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
        //动态计算宽度
        CGSize titleLabelSize = [_title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
        CGFloat titleLabelWidth = titleLabelSize.width + 2;
        
        CGFloat titleTotalWidth = 0;//包含图片的title总长度
        if (_imageName != nil && ![_imageName isEqualToString:@""]) {
            titleTotalWidth = 18+6+titleLabelWidth;
        }else{
            titleTotalWidth = titleLabelWidth;
        }
        
//        CGFloat titleLabelRightDistance = (keyWindow.bounds.size.width/4*3 - titleTotalWidth)/2;
        [_backgroundView addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake((_backgroundView.width - titleTotalWidth)/2, 25, titleLabelWidth, 18);
        
        if (_imageName != nil && ![_imageName isEqualToString:@""]) {
            _titleImageView = [[UIImageView alloc]init];
            _titleImageView.backgroundColor = [UIColor clearColor];
            UIImage *titleImage = [UIImage imageNamed:_imageName];
            _titleImageView.image = titleImage;
            [_backgroundView addSubview:_titleImageView];
            _titleImageView.frame = CGRectMake(_titleLabel.left - 6 - 18, 25, 18, 18);
        }
    }
    
    //label文字布局属性
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = _textAlignment;
    paraStyle.lineSpacing = 3.5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    CGFloat alertLabelHeight = 0;
    if (_alert != nil && ![_alert isEqualToString:@""]) {

        _alertLabel = [[UILabel alloc]init];
        _alertLabel.numberOfLines = 0;
        _alertLabel.textColor = [HsConfigration uiColorFromString:@"#f24957"];
        
        NSDictionary *alertDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *alertAttributeStr = [[NSAttributedString alloc] initWithString:_alert attributes:alertDic];
        _alertLabel.attributedText = alertAttributeStr;
        [_backgroundView addSubview:_alertLabel];
        
        //警示文字alert高度计算
        alertLabelHeight = [self calculateLabelHeight:_alert withParaStyle:paraStyle withFontSize:14];
        CGFloat alertTopDistance;
        if (_title != nil && ![_title isEqualToString:@""]) {
            alertTopDistance = 25+18+15;
        }else{
            alertTopDistance = 25;
        }
        _alertLabel.frame = CGRectMake(_marginWidth, alertTopDistance, _backgroundView.width - 2 * _marginWidth, alertLabelHeight);
    }
    
    //内容content
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.numberOfLines = 0;
    CGFloat textFontOfSize;
    if (_title == nil || [_title isEqualToString:@""] || [_content containsString:@"\r"] || [_content containsString:@"\n"]) {
        _contentLabel.textColor = [HsConfigration uiColorFromString:@"#333333"];
        textFontOfSize = 15;
    }else{
        _contentLabel.textColor = [HsConfigration uiColorFromString:@"#919191"];
        textFontOfSize = 14;
    }
    //label文字布局属性
    NSDictionary *contentDic = @{NSFontAttributeName:[UIFont systemFontOfSize:textFontOfSize], NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *contentAttributeStr = [[NSAttributedString alloc] initWithString:_content attributes:contentDic];
    _contentLabel.attributedText = contentAttributeStr;
    [_backgroundView addSubview:_contentLabel];

    CGFloat contentLabelHeight = [self calculateLabelHeight:_content withParaStyle:paraStyle withFontSize:textFontOfSize];
    
    CGFloat contentTopDistance;
    if ((_alert != nil && ![_alert isEqualToString:@""]) && (_title != nil && ![_title isEqualToString:@""])) {
        contentTopDistance = 25 + 18 + 15 + alertLabelHeight + 10;
    }else if ((_alert != nil && ![_alert isEqualToString:@""]) && !(_title != nil && ![_title isEqualToString:@""])){
        contentTopDistance = 25 + alertLabelHeight + 10;
    }else if (!(_alert != nil && ![_alert isEqualToString:@""]) && (_title != nil && ![_title isEqualToString:@""])){
        contentTopDistance = 25 + 18 + 15;
    }else{
        contentTopDistance = 25;
    }
    _contentLabel.frame = CGRectMake(_marginWidth, contentTopDistance, _backgroundView.width - 2 * _marginWidth, contentLabelHeight);
    
    //分割线2
    _separatorView_2 = [[UIView alloc]init];
    _separatorView_2.backgroundColor = [HsConfigration uiColorFromString:@"#dddddd"];
    [_backgroundView addSubview:_separatorView_2];
    _separatorView_2.frame = CGRectMake(0, _contentLabel.bottom + 20, _backgroundView.width, 0.5);
    
    if (_type == HsNoticeTooltipViewTypeSingle)
    {
        //确认按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[HsConfigration uiColorFromString:@"#eb333b"] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_confirmBtn];
        _confirmBtn.frame = CGRectMake(0, _separatorView_2.bottom, _backgroundView.width, 50);
    }
    else
    {
        //分割线3
        _separatorView_3 = [[UIView alloc]init];
        _separatorView_3.backgroundColor = [HsConfigration uiColorFromString:@"#dddddd"];
        [_backgroundView addSubview:_separatorView_3];
        _separatorView_3.frame = CGRectMake(_backgroundView.width / 2, _separatorView_2.bottom, 0.5, 50);
        //确认按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[HsConfigration uiColorFromString:@"#f24957"] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_confirmBtn];
        _confirmBtn.frame = CGRectMake(_separatorView_3.right, _separatorView_2.bottom, _backgroundView.width/2, 50);
        //取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[HsConfigration uiColorFromString:@"#414141"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_cancelBtn];
        _cancelBtn.frame = CGRectMake(0, _separatorView_2.bottom, _backgroundView.width/2, 50);
        
    }
    _backgroundView.height = _confirmBtn.bottom;
    _backgroundView.frame = CGRectMake(keyWindow.width * 0.25/ 2, (keyWindow.height - _backgroundView.height) /2, keyWindow.width * 0.75, _confirmBtn.bottom);
}

//计算富文本label高度
- (CGFloat)calculateLabelHeight:(NSString *)str withParaStyle:(NSMutableParagraphStyle *)paraStyle withFontSize:(CGFloat)fontSize
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
        }
        else {
            labelHeight = textSize.height;
        }
    }
    else
    {
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

-(void)confirmClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(noticeTooltipViewClickConfirm)]) {
        [self.delegate noticeTooltipViewClickConfirm];
    }
    
    if (self.noticeTooltipViewConfirmBlock) {
        self.noticeTooltipViewConfirmBlock();
    }
}

-(void)cancelClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(noticeTooltipViewClickCancel)]) {
        [self.delegate noticeTooltipViewClickCancel];
    }
    
    if (self.noticeTooltipViewCancelBlock) {
        self.noticeTooltipViewCancelBlock();
    }
}

-(void)show
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self];
    self.frame = keyWindow.bounds;
}

-(void)hide
{
    [self removeFromSuperview];
}

//-(void)setTitle:(NSString *)title
//{
//    _title = [title copy];
//    _titleLabel.text = _title;
//}
//
//-(void)setContent:(NSString *)content
//{
//    _content = [content copy];
//    _contentLabel.text = _content;
//}


/**
 *
 *  @brief 自定义设置确认按钮标题文字
 */
-(void)setConfirmText:(NSString *)confirmText
{
    _confirmText = [confirmText copy];
    [_confirmBtn setTitle:_confirmText forState:UIControlStateNormal];
}


/**
 *
 *  @brief 自定义设置取消按钮标题文字
 */
- (void)setCancelText:(NSString *)cancelText
{
    _cancelText = cancelText;
    [_cancelBtn setTitle:_cancelText forState:UIControlStateNormal];
}

/**
 *
 *  @brief 自定义设置内容文字颜色
 */
- (void)setContentTextColor:(UIColor *)contentTextColor
{
    _contentTextColor = contentTextColor;
    _contentLabel.textColor = contentTextColor;
}

-(void)dealloc
{

}

@end
