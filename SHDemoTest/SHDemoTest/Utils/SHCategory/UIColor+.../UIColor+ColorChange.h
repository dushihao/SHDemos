//
//  UIColor+ColorChange.h
//  FundBook
//
//  Created by laoduan on 2018/5/29.
//  Copyright © 2018年 laoduan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
