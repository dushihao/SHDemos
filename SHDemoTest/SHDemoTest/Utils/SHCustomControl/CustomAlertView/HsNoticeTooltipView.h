//
//  HsNoticeTooltipView.h
//  TZYJ_IPhone
//
//  Created by zhuqiongyao on 2018/6/14.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HsNoticeTooltipViewType) {
    HsNoticeTooltipViewTypeSingle = 0,//仅确认按钮
    HsNoticeTooltipViewTypeDouble = 1,//确认、取消按钮
};

//确认按钮
typedef void(^NoticeTooltipViewConfirm)(void);
//取消按钮
typedef void(^NoticeTooltipViewCancel)(void);

@protocol HsNoticeTooltipViewDelegate <NSObject>

@optional
//确认按钮代理事件
-(void)noticeTooltipViewClickConfirm;
//取消按钮代理事件
-(void)noticeTooltipViewClickCancel;
@end

@interface HsNoticeTooltipView : UIView

//@property(nonatomic,copy)NSString *title;//抬头文字
//@property(nonatomic,copy)NSString *content;//内容文字
@property(nonatomic,copy)NSString *confirmText;//设置确认按钮标题文字（默认确认）
@property(nonatomic,copy)NSString *cancelText;//设置取消按钮标题文字 （默认取消）
@property(nonatomic,strong)UIColor *contentTextColor;//设置内容文字颜色
@property(nonatomic,weak)id<HsNoticeTooltipViewDelegate>delegate;

//点击确认按钮
@property(nonatomic,copy)NoticeTooltipViewConfirm noticeTooltipViewConfirmBlock;
//点击取消按钮
@property(nonatomic,copy)NoticeTooltipViewCancel noticeTooltipViewCancelBlock;

/**
 *  @brief 类方法
 *
 *  @param title   表头内容
 *  @param alert   警示内容
 *  @param content 内容
 *  @param imageName 标题图标
 *  @param type    类型
 *  @param marginWidth  留边宽度
 *  @param textAlignment  内容对齐方式
 *
 *  @return 实例
 */
+ (instancetype)tipWithTitle:(NSString *)title
                       Alert:(NSString *)alert
                     Content:(NSString *)content
                  TitleImage:(NSString *)imageName
                       Style:(HsNoticeTooltipViewType)type
                 MarginWidth:(CGFloat)marginWidth
               TextAlignment:(NSTextAlignment)textAlignment;

-(void)show;
-(void)hide;


@end
