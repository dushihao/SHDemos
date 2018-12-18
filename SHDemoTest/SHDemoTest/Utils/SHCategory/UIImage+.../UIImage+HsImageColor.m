//
//  UIImage+HsImageColor.m
//  TZYJ_IPhone
//
//  Created by wanghp on 2017/11/6.
//

#import "UIImage+HsImageColor.h"

@implementation UIImage (HsImageColor)
+ (UIImage *)Hs_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
