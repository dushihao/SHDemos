//
//  HsPopLabel.m
//  SHDemoTest
//
//  Created by dush on 2018/11/6.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "HsPopLabel.h"

static const float kTriangleHeight = 5;
static const float kTriangleWidth = 10;

@interface HsPopLabel()
@property (nonatomic, strong) UIImageView *triangelImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation HsPopLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    _triangelImageView = [[UIImageView alloc] init];
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_triangelImageView];
    [self addSubview:_label];
    
    return self;
}

- (void)layoutSubviews {
    _triangelImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - kTriangleWidth) / 2,
                                          CGRectGetHeight(self.bounds),
                                          kTriangleWidth,
                                          kTriangleHeight);
    _label.frame = self.bounds;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)radius {
    _label.layer.cornerRadius = radius;
    _label.layer.masksToBounds = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:[UIColor clearColor]];
    _label.backgroundColor = backgroundColor;
    _triangelImageView.image = [self triImgeWithColor:backgroundColor];
    _triangelImageView.layer.allowsEdgeAntialiasing = YES;
    
}

- (void)setText:(NSString *)text {
    [_label setText:text];
}

- (void)setFont:(UIFont *)font {
    [_label setFont:font];
}

- (void)setTextColor:(UIColor *)textColor {
    [_label setTextColor:textColor];
}

- (void)sizeToFit {
    [_label sizeToFit];
    self.frame = ({
        CGRect frame = self.frame;
        frame.size = self.label.bounds.size;
        frame;
    });
}

- (UIImage *)triImgeWithColor:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kTriangleWidth, kTriangleHeight), NO, 0.0);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    CGPoint point1 = CGPointMake(kTriangleHeight, kTriangleHeight);
    CGPoint point2 = CGPointMake(0, 0);
    CGPoint point3 = CGPointMake(kTriangleWidth, 0);
    
    CGContextMoveToPoint(gc, point2.x, point2.y);
    CGContextAddLineToPoint(gc, point1.x, point1.y);
    CGContextAddLineToPoint(gc, point3.x, point3.y);
    CGContextClosePath(gc);
    [color setFill];
    [color setStroke];
    CGContextDrawPath(gc, kCGPathFillStroke);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)showDelay:(NSTimeInterval)duration {
    self.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hidePopLabel) withObject:nil afterDelay:duration];
}

- (void)hidePopLabel {
    self.hidden = YES;
}
@end
