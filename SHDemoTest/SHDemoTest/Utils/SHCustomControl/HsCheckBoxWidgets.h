////////////////////////////////////////////////////////////////////////////////
/// CORYRIGHT NOTICE
/// Copyright 2012年 hundsun. All rights reserved.
///
/// @系统名称   投资赢家5.0 IPhone
/// @模块名称   HsCheckBoxWidgets
/// @文件名称   HsCheckBoxWidgets.h
/// @功能说明   CheckBox组件
///
/// @软件版本   1.0.0.0
/// @开发人员   zhangcheng
/// @开发时间   2012-02-28
///
/// @修改记录：最初版本
///
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@protocol HsCheckBoxWidgetsDelegate <NSObject>

@optional
- (void) onCheckBoxClick:(id)sender;

@end

@interface HsCheckBoxWidgets : UIButton {
    BOOL                            _isChecked;
    BOOL                            _repeat;
    id<HsCheckBoxWidgetsDelegate>   __weak _deletegate;
}
@property (nonatomic,assign) BOOL                             isChecked;
@property (nonatomic,weak) id<HsCheckBoxWidgetsDelegate>    deletegate;

-(void)setIsChecked:(BOOL)isChecked;

- (id)initWithFrame:(CGRect)frame onrepeatclick :(BOOL)repeat;

@end
