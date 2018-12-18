//
//  YZAlertView.h
//
//  Created by 从今以后 on 16/2/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZAlertView : UIView

/// 创建 Alert View
+ (instancetype)alertView;

/// 子类返回自定义视图
- (UIView *)customView;

/// 呈现 Alert View
- (void)show;

/// 移除 Alert View
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
