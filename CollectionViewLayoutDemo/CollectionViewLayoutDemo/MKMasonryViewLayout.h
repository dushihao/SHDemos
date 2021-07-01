//
//  MKMasonryViewLayout.h
//  CollectionViewTest
//
//  Created by shihao on 2017/8/28.
//  Copyright © 2017年 shihao. All rights reserved.
//  瀑布流布局

#import <UIKit/UIKit.h>
@class MKMasonryViewLayout;

@protocol MKMasonryViewLayoutDelegate <NSObject, UICollectionViewDelegateFlowLayout>
@required
- (CGFloat) collectionView:(UICollectionView*) collectionView layout:(MKMasonryViewLayout*) layout heightForItemAtIndexPath:(NSIndexPath*) indexPath;

- (CGSize)collection:(UICollectionView *)collectionView sizeForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@interface MKMasonryViewLayout : UICollectionViewLayout
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;
@property (weak, nonatomic) IBOutlet id<MKMasonryViewLayoutDelegate> delegate;
@end
