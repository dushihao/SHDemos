//
//  SHCollectionViewFlowlayout.m
//  CollectionViewTest
//
//  Created by shihao on 2017/8/28.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "SHCollectionViewFlowlayout.h"



@implementation SHCollectionViewFlowlayout

#define ZOOM_FACTOR 0.35

-(void) prepareLayout {
    
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   // self.itemSize = CGSizeMake(120, 120);
    self.minimumLineSpacing = 30;
    CGFloat inset = (self.collectionView.bounds.size.width - 120) * 0.5;
    self.sectionInset =  UIEdgeInsetsMake(0, inset, 0, inset);
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
///    第一种布局方式
//    NSArray* array = [super layoutAttributesForElementsInRect:rect];
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    float collectionViewHalfFrame = self.collectionView.frame.size.width/2.0f;
//    
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
//            CGFloat normalizedDistance = distance / collectionViewHalfFrame;
//            if (ABS(distance) < collectionViewHalfFrame) {
//                
//                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
//                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//                rotationAndPerspectiveTransform.m34 = 1.0 / -500;
//                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (normalizedDistance) * M_PI_4, 0.0f, 1.0f, 0.0f);
//                CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);
//                attributes.transform3D = CATransform3DConcat(zoomTransform, rotationAndPerspectiveTransform);
//                attributes.zIndex = ABS(normalizedDistance) * 10.0f;
//                CGFloat alpha = (1 - ABS(normalizedDistance)) + 0.1;
//                if(alpha > 1.0f) alpha = 1.0f;
//                attributes.alpha = alpha;
//            } else {
//                
//                attributes.alpha = 0.0f;
//            }
//        }
//    }
//    return array;
    
  
/// 第二种展示方式
    //获取可见范围内 UICollectionViewLayoutAttributes array
    CGRect visibleRect = self.collectionView.bounds;
    NSArray *attrsArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    //
    for (UICollectionViewLayoutAttributes *attributes in attrsArray) {
        
        CGFloat delta = fabs(attributes.center.x - (CGRectGetWidth(self.collectionView.bounds)/2 + self.collectionView.contentOffset.x));
        
        // 缩放比例 （1 ~ 1.1）
        CGFloat scale = 1 -  0.1 * delta / (CGRectGetWidth(self.collectionView.bounds)/2);
       // CGFloat scale =  1 - delta / (CGRectGetWidth(self.collectionView.bounds) * 0.5) * 0.25;
        NSLog(@"scale ==== %@",@(scale));
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attrsArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // get visibleRect rect
    CGRect visibleRect = CGRectMake(proposedContentOffset.x, 0, CGRectGetWidth(self.collectionView.bounds), MAXFLOAT);
    
    // get visible attributes array
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    // ergodic, find nearest attributes
    CGFloat minDelta = MAXFLOAT;
    CGFloat centerX = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds)/2 ;
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        
        CGFloat delta = attributes.center.x - centerX;
        if (fabs(delta) <fabs(minDelta)) {
            minDelta = delta;
        }
    }
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}


- (CGSize)collectionViewContentSize{
  return  [super collectionViewContentSize];
}

@end
