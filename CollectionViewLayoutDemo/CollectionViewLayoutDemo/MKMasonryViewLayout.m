//
//  MKMasonryViewLayout.m
//  CollectionViewTest
//
//  Created by shihao on 2017/8/28.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "MKMasonryViewLayout.h"


@interface MKMasonryViewLayout (/*Private Methods*/)
@property (nonatomic, strong) NSMutableDictionary *lastYValueForColumn;
@property (nonatomic, strong) NSMutableArray *lastYValueMapArray; // 二维数组
@property (nonatomic, strong) NSMutableArray <NSNumber *>*headerYForSectionArray; // 区头Y值
@property (nonatomic, strong) NSMutableArray <NSNumber *>*footerYForSectionArray; // 区尾Y值
@property (nonatomic, assign) CGFloat maxContentHeight;
@property (strong, nonatomic) NSMutableArray *layoutInfo;
@end

@implementation MKMasonryViewLayout

- (void)prepareLayout {
    
    self.maxContentHeight = 0;
    self.numberOfColumns = 3;
    self.interItemSpacing = 12.5;
    
    self.lastYValueForColumn = [NSMutableDictionary dictionary];
    self.lastYValueMapArray = [NSMutableArray array];
    
    CGFloat currentColumn = 0;
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat availableSpaceExcludingPadding = fullWidth - (self.interItemSpacing * (self.numberOfColumns + 1));
    CGFloat itemWidth = availableSpaceExcludingPadding / self.numberOfColumns;
    self.layoutInfo = [NSMutableArray array];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    self.headerYForSectionArray = [NSMutableArray array];
    self.footerYForSectionArray = [NSMutableArray array];
    NSInteger currentSection = 0;
    while (currentSection < numSections) {
        [self.headerYForSectionArray addObject:@(0)];
        [self .footerYForSectionArray addObject:@(0)];
        currentSection++;
    }
    
    for(NSInteger section = 0; section < numSections; section++)  {
        NSMutableDictionary *lastYValueForColumn = [NSMutableDictionary dictionary];
        NSInteger i = 0;
        while (i < self.numberOfColumns) {
            [lastYValueForColumn setObject:@(0) forKey:@(i)];
            i++;
        }
        [self.lastYValueMapArray addObject:lastYValueForColumn];
        
        // add header attributes
        indexPath = [NSIndexPath indexPathWithIndex:section];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
//        CGFloat sectionHeight = self.headerYForSectionArray[section].doubleValue;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            CGSize size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
            CGFloat y = self.maxContentHeight;
            headerAttributes.frame = CGRectMake(0, y, size.width, size.height);
            self.maxContentHeight += size.height;
            self.headerYForSectionArray[section] = @(self.maxContentHeight);
            
            for (int i=0; i<lastYValueForColumn.count; i++) {
                lastYValueForColumn[@(i)] = @(self.maxContentHeight);
            }
        }
        if (headerAttributes) { [self.layoutInfo addObject:headerAttributes]; }
        
        // collectionViewCell
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSDictionary *param = [self getMinHeightDic];
            NSInteger currenColumn = ((NSNumber *)param.allKeys.firstObject).integerValue;
            CGFloat x = self.interItemSpacing + (self.interItemSpacing + itemWidth) * currenColumn;
            CGFloat y = ((NSNumber *)param[@(currenColumn)]).floatValue;
            
            CGFloat height = [((id<MKMasonryViewLayoutDelegate>)self.collectionView.delegate) collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
            
            itemAttributes.frame = CGRectMake(x, y, itemWidth, height);
            y += (height + self.interItemSpacing);
            
            lastYValueForColumn[@(currenColumn)] = @(y);
            
            self.maxContentHeight = [self getMaxHeight];
            
            [self.layoutInfo addObject:itemAttributes];
        }
        
        // add header attributes
        indexPath = [NSIndexPath indexPathWithIndex:section];
        UICollectionViewLayoutAttributes *footerAtributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            CGSize size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
            CGFloat y = self.maxContentHeight - self.interItemSpacing;
            footerAtributes.frame = CGRectMake(0, y, size.width, size.height);
            self.maxContentHeight += size.height;
            self.footerYForSectionArray[section] = @(self.maxContentHeight);
        }
        if (footerAtributes) { [self.layoutInfo addObject:footerAtributes]; }
        
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutInfo;
}

//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *attributes =  [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
//    if (elementKind) {
//
//    }
//    return attributes;
//}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.maxContentHeight);
}

- (CGFloat)getMaxHeight {
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    self.lastYValueForColumn = self.lastYValueMapArray.lastObject;
    do {
        CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
        if(height > maxHeight) maxHeight = height;
        currentColumn ++;
    } while (currentColumn < self.numberOfColumns);
    
    return maxHeight;
}

- (NSDictionary *)getMinHeightDic {
    NSUInteger currentColumn = 0;
    NSUInteger minHeightColumn = 0;
    self.lastYValueForColumn = self.lastYValueMapArray.lastObject;
    
    CGFloat minHeight = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
    do {
        CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
        if (height == 0) {
            minHeight = 0;
            minHeightColumn = currentColumn;
            break;
        }
        
        if (height < minHeight) {
            minHeight = height;
            minHeightColumn = currentColumn;
        }
        
        currentColumn ++;
    } while (currentColumn < self.numberOfColumns);
    
    return @{@(minHeightColumn): @(minHeight)};
}

@end
