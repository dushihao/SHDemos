//
//  SHCardView.h
//  SHCardView
//
//  Created by shihao on 2017/9/19.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHCardView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,SHCardViewDirection){
    SHCardViewDirectionTop,
    SHCardViewDirectionBottom,
};


@protocol SHCardViewReuseableCard <NSObject>
/// 重用标识符
@property (nonatomic,readonly)NSString *reuseIdentifier;
/// 卡片即将重用
- (void)prepareForReuse;
@end


typedef UIView<SHCardViewReuseableCard> SHReusableCard;


@protocol SHCardViewDataSource <NSObject>

@required
/// 返回展示多少个卡片儿
- (NSUInteger)numberOfCardsInCardView:(SHCardView *)cardView;
/// 返回索引位置对应的卡片视图
- (SHReusableCard *)cardView:(SHCardView *)cardView viewForCardAtIndex:(NSUInteger)index;
@end


@protocol SHCardViewDelegate <NSObject>

@optional
/// 顶层卡片处于拖拽中
- (void)cardView:(SHCardView *)cardView didDragTopCard:(UIView *)topCard anchorPoint:(CGPoint)anchorPoint translation:(CGPoint)translation;

/// 顶层卡片即将回复原位
- (void)cardView:(SHCardView *)cardView willResetTopCard:(UIView *)topCard;
/// 顶层卡片已经回复原位
- (void)cardView:(SHCardView *)cardView didResetTopCard:(UIView *)topCard;

/// 顶层卡片已经被扔出
- (void)cardView:(SHCardView *)cardView didThrowTopCard:(UIView *)topCard;
/// 顶层卡片已经显示
- (void)cardView:(SHCardView *)cardView didDisPlayTopCard:(UIView *)topCard;
@end


@interface SHCardView : UIView

/// 是否允许拖拽卡片
@property (nonatomic,getter=isDragEnabled) BOOL dragEnabled;
/// 卡片拖拽点最大偏移量绝对值，默认：卡片宽高一半
@property (nonatomic)UIOffset maxOffset;
/// 最大可见卡片数量，默认为3
@property (nonatomic) NSUInteger maxCountOfVisibleCards;

@property (nonatomic,weak) id<SHCardViewDelegate> delegate;
@property (nonatomic,weak) id<SHCardViewDataSource> datasource;

/// 刷新数据
- (void)reloadData;
/// 从重用池重用卡片
- (nullable __kindof SHReusableCard *)dequeueReusrIdentifier:(NSString *_Nullable)identifier;

- (void)throwTopCardOnDirection:(SHCardViewDirection)direction angle:(CGFloat)angle;

/// 顶层卡片 索引
- (NSUInteger)indexForTopCard;
/// 屏幕上显示的卡片数量
- (NSUInteger)countOfVisibleCards;
/// 顶层卡片
- (nullable SHReusableCard *)topCard;

@end

NS_ASSUME_NONNULL_END
