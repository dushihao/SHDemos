////////////////////////////////////////////////////////////////////////////////
/// CORYRIGHT NOTICE
/// Copyright 2012年 hundsun. All rights reserved.
///
/// @系统名称   投资赢家5.0 IPhone
/// @模块名称   HsStyle
/// @文件名称   HsStyle.h
/// @功能说明   样式管理类
///
/// @软件版本   1.0.0.0
/// @开发人员   cfen
/// @开发时间   2012-02-14
///
/// @修改记录：最初版本
///
////////////////////////////////////////////////////////////////////////////////

#ifndef HS_STYLE_H
#define HS_STYLE_H

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "HsCssProc.h"
NSDictionary * getStaticRef(void);

@interface HsStyle : NSObject {

}

+ (UIColor *) uiColorFromString:(NSString *)clrString;
+ (UIFont *) systemFontOfSize:(CGFloat)fontSize;

//lcPrice:preCloseValue Price:now value
#define PRICE_CLASS(lcPrice,Price) (Price == lcPrice?@",fcw":(Price > lcPrice?@",fcr":@",fcg"))

@end

@interface UIView (HsConfigExtention)

// x,y,width,height
- (void)setFrameWithString:(NSString*)string;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

@end

@interface UITableViewCell (HsStyleConfig)

- (void)setLightStyle;

- (void)setDrakStyle;

@end

#endif
