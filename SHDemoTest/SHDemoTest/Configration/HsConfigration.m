//
//  Configration.m
//  HsBrowser
//
//  Created by si xin on 09-4-21.
//  Copyright 2009 hundsun. All rights reserved.
//

#import "HsConfigration.h"

@interface HsConfigration ()

@property(nonatomic, assign) BOOL bIsNeedSaveCfg;

@end

@implementation HsConfigration

+ (UIColor *)uiColorFromString:(NSString *)clrString
{
    return [HsStyle uiColorFromString:clrString];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize WithStyleType:(NSString *)styleType
{
    if ([styleType isEqualToString:@"bold"]) {
        return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
    }
    return [HsStyle systemFontOfSize:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [HsConfigration systemFontOfSize:fontSize WithStyleType:@""];
}
@end
