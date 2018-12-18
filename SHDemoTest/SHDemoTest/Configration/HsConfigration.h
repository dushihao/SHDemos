////////////////////////////////////////////////////////////////////////////////
/// CORYRIGHT NOTICE
/// Copyright 2012年 hundsun. All rights reserved.
///
/// @系统名称   投资赢家5.0 IPhone
/// @模块名称   HsConfigration
/// @文件名称   HsConfigration.h
/// @功能说明   配置管理
///
/// @软件版本   1.0.0.0
/// @开发人员   cfen
/// @开发时间   2012-02-14
///
/// @修改记录：最初版本
///
////////////////////////////////////////////////////////////////////////////////


#ifndef HS_CONFIGRATION_H
#define HS_CONFIGRATION_H

#import <Foundation/Foundation.h>
#import "HsStyle.h"

@interface HsConfigration : NSObject

/**
 * @brief   根据Selector和Property查找Value，并返回对应的颜色指针。
 * @param   -CssString为CSS文件中的Selector。
 * @param   -aKey为CSS文件中的Property。
 * @return  CSS文件中对应Selector中Property的颜色。
 * @desc    为了便于样式继承实现，这里的-CssString允许传入一串Selector，此函数会选取最后一个包含对应Property的Selector。
 */
+ (UIColor *)uiColorOfCSS: (NSString *)CssString forKey: (NSString *)aKey;

/**
 * @brief   根据字符串获取颜色的函数
 * @param   -clrString为颜色字符串，形如：“#rrggbb”或“#rrggbbaa”,最后两位为透明度。
 * @return  颜色对象指针
 * @desc    透明度没有则默认为完全不透明
 */
+ (UIColor *)uiColorFromString:(NSString *)clrString;

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize WithStyleType:(NSString *)styleType;

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;

@end


#endif
