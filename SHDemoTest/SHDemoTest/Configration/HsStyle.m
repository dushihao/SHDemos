//
//  HsStyle.m
//  TZYJ_IPAD
//
//  Created by xyfeng on 11-10-8.
//  Copyright 2011 Hundsun. All rights reserved.
//

/// @2012-08-01    xuyefeng        添加UIView扩展

#import "HsStyle.h"

static NSDictionary * staticRef = nil;

NSDictionary * getStaticRef(void)
{
    if (staticRef == nil)
    {
        staticRef = [[NSDictionary alloc]initWithObjectsAndKeys:
                     @"#00FFFF",@"aqua",
                     @"#000000",@"black",
                     @"#0000FF",@"blue",
                     @"#FF00FF",@"fuchsia",
                     @"#808080",@"gray",
                     @"#008000",@"green",
                     @"#00FF00",@"lime",
                     @"#800000",@"maroon",
                     @"#000080",@"navy",
                     @"#808000",@"olive",
                     @"#FFA500",@"orange",
                     @"#800080",@"purple",
                     @"#FF0000",@"red",
                     @"#C0C0C0",@"silver",
                     @"#008080",@"teal",
                     @"#FFFFFF",@"white",
                     @"#FFFF00",@"yellow",
                     
                     @"#00000000", @"clear",
                     nil];
    }
    
    return staticRef;
}

@implementation HsStyle

+ (UIColor *) uiColorFromString:(NSString *)clrString
{
    if ([clrString length] == 0) {
        return [UIColor clearColor];
    }
    
    if ([getStaticRef() objectForKey:clrString] != nil)
    {
        clrString = [getStaticRef() objectForKey:clrString];
    }
    
    if ( [clrString rangeOfString:@"#"].location != 0 )
    {
        // error
        return [UIColor redColor];
    }
    
    if ([clrString length] == 7)
    {
        clrString = [clrString stringByAppendingString:@"FF"];
    }
    
    if ([clrString length] != 9)
    {
        // error
        return [UIColor redColor];
    }
    
    const char * strBuf= [clrString UTF8String];
    
    unsigned long iColor = strtoul((strBuf+1), NULL, 16);
    typedef struct colorByte
    {
        unsigned char a;
        unsigned char b;
        unsigned char g;
        unsigned char r;
    }CLRBYTE;
    
    CLRBYTE  pclr ;
    memcpy(&pclr, &iColor, sizeof(CLRBYTE));
    
    return [UIColor colorWithRed:(pclr.r/255.0)
                           green:(pclr.g/255.0)
                            blue:(pclr.b/255.0)
                           alpha:(pclr.a/255.0)];
    
}


+ (UIFont*) systemFontOfSize:(CGFloat)fontSize
{
    //[UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
    return [UIFont fontWithName:@"Helvetica Neue" size:fontSize];
}

@end

@implementation UIView (HsConfigExtention)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


@end

@implementation UITableViewCell (HsStyleConfig)

- (void)setLightStyle
{
    UIView *selectedBackView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.selectedBackgroundView = selectedBackView;
}

- (void)setDrakStyle
{
    UIView *selectedBackView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.selectedBackgroundView = selectedBackView;
}

@end
