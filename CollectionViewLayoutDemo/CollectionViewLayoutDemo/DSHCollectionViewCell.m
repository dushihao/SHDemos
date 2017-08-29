//
//  DSHCollectionViewCell.m
//  CollectionViewTest
//
//  Created by shihao on 2017/8/22.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "DSHCollectionViewCell.h"

@implementation DSHCollectionViewCell

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}


@end
