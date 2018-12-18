//
//  ZFTipAlertView.h
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/22.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "YZAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFTipAlertView : YZAlertView

/// 标题 default为"温馨提示"
@property (nonatomic,copy) NSString *title;
/// 内容 default为""
@property (nonatomic,copy) NSString *content;
/// 确认按钮字样 default为"确认"
@property (nonatomic,copy) NSString *confirmStr;

/**
 类方法创建实例
 
 @param title 标题
 @param content 内容
 @param confirmStr 确认字样
 @return 实例
 */
+ (instancetype)alertWithTitle:(NSString *)title
                       content:(NSString *)content
                    confirmStr:(NSString *)confirmStr;


@end

NS_ASSUME_NONNULL_END
