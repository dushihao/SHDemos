//
//  SHCardView.m
//  SHCardView
//
//  Created by shihao on 2017/9/19.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "SHCardView.h"

typedef NSMutableDictionary<NSString * ,NSMutableSet<SHReusableCard *> *> LXReusableCardCache;

static CGFloat const kThrowingSpeedThreshold = 1000;
static NSTimeInterval const kThrowAnimationDuration = 0.25;
static NSTimeInterval const kResetAnimationDuration = 0.5;
static NSTimeInterval const kInsertAnimationDration = 0.5;

@interface SHCardView () <UIDynamicAnimatorDelegate>

@property (nonatomic)NSUInteger numberOfCards;
@property (nonatomic)NSUInteger indexForTopCard;
@property (nonatomic)NSUInteger maxIndexForVisibleCard;
@property (nonatomic)NSMutableArray<UIView *> *visibleCards;
@property (nonatomic)LXReusableCardCache *reusableCardCache;

@property (nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation SHCardView


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit{
    
    _dragEnabled = YES;
    _maxCountOfVisibleCards =3;
    _visibleCards = [NSMutableArray new];
    _reusableCardCache = [NSMutableDictionary new];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(_panGestureHandle:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
}

#pragma mark - 刷新数据
- (void)reloadData {
    [self.visibleCards makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.visibleCards removeAllObjects];
    [self.reusableCardCache removeAllObjects];
    
    self.numberOfCards = [self.datasource numberOfCardsInCardView:self];
    NSUInteger countOfVisibleCards = MIN(self.numberOfCards, self.maxCountOfVisibleCards);
    
    if (countOfVisibleCards == 0) {
        self.panGestureRecognizer.enabled = NO;
        return;
    }
    
    for (NSUInteger idx = 0; idx<countOfVisibleCards; ++idx) {
        [self _setupConstraintsForCard: [self _getAndAppendCardForIndex:idx]];
    }
    
    self.indexForTopCard = 0;
    self.maxIndexForVisibleCard = countOfVisibleCards - 1;
    self.panGestureRecognizer.enabled = self.isDragEnabled;
    
    [self _configureVisibleCard];
    
    if ([self.delegate respondsToSelector:@selector(cardView:didDisPlayTopCard:)]) {
        [self.delegate cardView:self didDisPlayTopCard: self.topCard];
    }
}

#pragma mark - 创建卡片
- (UIView *)_getAndAppendCardForIndex:(NSUInteger)index {
    UIView *card = [self.datasource cardView:self viewForCardAtIndex:index];
    NSAssert(card, @"[SHCardViewDataSource cardView:viewForCardAtIndex: 方法不能返回nil" );
    [self insertSubview:card atIndex:0];
    [self.visibleCards addObject:card];
    return card;
}

- (UIView<SHCardViewReuseableCard> *)dequeueReuseIdentifier:(NSString *)identifier {
    NSMutableSet<SHReusableCard *> *cacheForIdentifier = self.reusableCardCache[identifier];
    
    if (!cacheForIdentifier) { return nil; }
    if (cacheForIdentifier.count == 0) { return nil; }
    
    SHReusableCard *card = [cacheForIdentifier anyObject];
    [card prepareForReuse];
    //TODO:前后打断点查看 self.reusableCardCache[identifier] 中的值
    [cacheForIdentifier removeObject:card];
    return card;
}

#pragma mark - 配置卡片

- (void)_setupConstraintsForCard:(UIView *)card {
    // NSLayoutAnchor 布局方式
    if (card.translatesAutoresizingMaskIntoConstraints) {
        card.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat constants[] = {CGRectGetWidth(card.bounds),CGRectGetHeight(card.bounds)};
        [card.widthAnchor constraintEqualToConstant:constants[0]].active = YES;
        [card.heightAnchor constraintEqualToConstant:constants[1]].active = YES;
    }
    [card.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [card.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    /**
     * NSLayoutConstraint 布局方式
    if (card.translatesAutoresizingMaskIntoConstraints) {
        card.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat constants[] = {CGRectGetWidth(card.bounds),CGRectGetHeight(card.bounds)};

        // NSLayoutConstraint 布局方式
        
        NSLayoutAttribute attributes[] = {NSLayoutAttributeWidth,NSLayoutAttributeHeight};
        for (NSUInteger i = 0; i<2; ++i) {
            [NSLayoutConstraint constraintWithItem:card attribute:attributes[i]
                                         relatedBy:NSLayoutRelationEqual toItem:nil attribute:attributes[i] multiplier:1 constant:constants[i]].active = YES;
        }
    }
    
    NSLayoutAttribute attributes[] = {NSLayoutAttributeCenterX,NSLayoutAttributeCenterY};
    for (NSUInteger i = 0; i<2; ++i) {
        [NSLayoutConstraint constraintWithItem:card attribute:attributes[i] relatedBy:NSLayoutRelationEqual toItem:self attribute:attributes[i] multiplier:1 constant:0].active = YES;
    }
     */
}

- (void)_configureVisibleCard {
    [self.visibleCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _configureCard:obj atIndex:idx];
    }];
}

- (void)_configureCard:(UIView *)card atIndex:(NSUInteger)index {
    // 随着索引变化，透明度变化30% 水平缩放10% 向下平移 10点
    card.alpha = 1 - 0.3 * index;
    card.transform = CGAffineTransformMake(1-0.1*index, 0, 0, 1, 0, 10*index);
}

#pragma mark - 卡片光栅化
- (void)_enableTopCardRasterize {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在");
    topCard.layer.shouldRasterize = YES;
    topCard.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)_disableTopCardRasterize {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在");
    topCard.layer.shouldRasterize = NO;
}

#pragma mark - 拖拽处理
- (void)_panGestureHandle:(UIPanGestureRecognizer *)panGR {
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            {
                //顶层卡片不存在，或者触摸点不在顶层卡片上，直接取消手势
                if (!self.topCard || !CGRectContainsPoint(self.topCard.frame, [panGR locationInView:self])) {
                    panGR.enabled = NO;
                }else{
                    [self _enableTopCardRasterize];
                    [self _setupAttachmentBehaviorForTopCard];
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self _updateTopCardPositionBypan];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (!panGR.isEnabled) {
                panGR.enabled = YES;
                break;
            }
            
            [self _removeAllBehaviors];
            
            UIView *topCard = [self topCard];
            NSAssert(topCard, @"topCard 不存在.");
#warning 阅读理解
            CGPoint currentPosition = topCard.layer.presentationLayer.position;
            CGPoint originalPosition = { CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) };
            CGFloat offsetH = ABS(currentPosition.x - originalPosition.x);
            CGFloat offsetV = ABS(currentPosition.y - originalPosition.y);
            UIOffset maxOffset = {
                self.maxOffset.horizontal > 0 ? self.maxOffset.horizontal : CGRectGetWidth(topCard.bounds) / 2,
                self.maxOffset.vertical > 0 ? self.maxOffset.vertical : CGRectGetHeight(topCard.bounds) / 2,
            };
            
            CGPoint velocity = [panGR velocityInView:self];
            CGFloat speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
            
            if (speed > kThrowingSpeedThreshold) {
                NSLog(@"speed > kThrowingSpeedThreshold :P 快速滑动");
                UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[topCard]];
                [dynamicItemBehavior addLinearVelocity:velocity forItem:topCard];
                [self _throwTopCardWithDynamicBehavior:dynamicItemBehavior];
            }
            else if (offsetH > maxOffset.horizontal || maxOffset.vertical < offsetV) {
                NSLog(@"offsetH > maxOffset.horizontal || maxOffset.vertical < offsetV :P ");
                CGVector vector = { currentPosition.x - originalPosition.x, currentPosition.y - originalPosition.y };
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[topCard] mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = vector;
                [self _throwTopCardWithDynamicBehavior:pushBehavior];
            }
            else {
                NSLog(@"重置卡片 :P");
                [self _resetTopCard];
            }
        }
            break;
        default: break;
    }
}

- (void)_setupAttachmentBehaviorForTopCard {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在");
    
    CGPoint location = [self.panGestureRecognizer locationInView:self];
    CGPoint locationInCard = [self.panGestureRecognizer locationInView:topCard];
    CGPoint position = CGPointMake(CGRectGetMidX(topCard.bounds), CGRectGetMidY(topCard.bounds));
    UIOffset offset = UIOffsetMake(locationInCard.x - position.x, locationInCard.y - position.y);
    
    [self.dynamicAnimator removeAllBehaviors];
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:topCard offsetFromCenter:offset attachedToAnchor:location];
    [self.dynamicAnimator addBehavior:self.attachmentBehavior];
}

- (void)_updateTopCardPositionBypan {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在");
    NSAssert(self.attachmentBehavior, @"attachmentBehavior 属性为nil");
    NSAssert(self.dynamicAnimator.behaviors.count == 1, @"尚有其他 Dynamic Behavior.");
    NSAssert(self.dynamicAnimator.behaviors[0] == self.attachmentBehavior, @"尚未添加 Attachment Behavior.");
    
    CGPoint tranlation = [self.panGestureRecognizer translationInView:self];
    CGPoint location = [self.panGestureRecognizer locationInView:self];
    self.attachmentBehavior.anchorPoint = location;
    
    if ([self.delegate respondsToSelector:@selector(cardView:didDragTopCard:anchorPoint:translation:)]) {
        [self.delegate cardView:self didDragTopCard:topCard anchorPoint:location translation:tranlation];
    }
}

- (void)_removeAllBehaviors {
    self.attachmentBehavior = nil;
    [self.dynamicAnimator removeAllBehaviors];
}

#pragma mark - 复原卡片

- (void)_resetTopCard {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topcard 不存在");
    NSAssert(self.dynamicAnimator.behaviors.count == 0, @"尚未清空 Dynamic Behavior.");
    
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(cardView:willResetTopCard:)]) {
        [self.delegate cardView:self willResetTopCard:topCard];
    }
    
    topCard.center = topCard.layer.presentationLayer.position;
    [UIView animateWithDuration:kResetAnimationDuration animations:^{
       
        topCard.transform = CGAffineTransformIdentity;
        topCard.center = (CGPoint){CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds)};
    } completion:^(BOOL finished) {
        [self _disableTopCardRasterize];
        self.userInteractionEnabled = YES;
        
        if ([self.delegate respondsToSelector:@selector(cardView:didResetTopCard:)]) {
            [self.delegate cardView:self didResetTopCard:topCard];
        }
    }];
}

#pragma mark - 移除卡片

- (void)_throwTopCardWithDynamicBehavior:(UIDynamicBehavior *)dynamicBehavior {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在");
    NSAssert(self.dynamicAnimator.behaviors.count == 0, @"尚未清空 Dynamic Behavior");
    
    topCard.center = topCard.layer.presentationLayer.position;
    self.userInteractionEnabled = NO;
    
    __block NSInteger count = 0;
    __weak __typeof(self) weakSelf = self;
    dynamicBehavior.action = ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (count++ %2) {
            return ;
        }
        if (!CGRectIntersectsRect(self.bounds, topCard.frame)) {
            [strongSelf _removeAllBehaviors];
            [strongSelf _recycleThrowedCard];
            [strongSelf _updateVisibleCardAfterThrow];
        }
    };
    
    [self.dynamicAnimator addBehavior:dynamicBehavior];
}

- (void)throwTopCardOnDirection:(SHCardViewDirection)direction angle:(CGFloat)angle {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在.");
    
    CGFloat factorH = (angle < M_PI_2) ? +1.0 : -1.0 ;
    CGFloat factorV = (direction == SHCardViewDirectionTop) ? -1.0 : 1.0;
    CGFloat horizontaldistance = (CGRectGetWidth(self.bounds) + CGRectGetWidth(topCard.bounds))/2;
    CGPoint position = {};
    position.x = CGRectGetMidX(self.bounds) + factorH * horizontaldistance;
    position.y = CGRectGetMidY(self.bounds) + factorV * tan(angle) * position.x;
    
    [self _enableTopCardRasterize];
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:kThrowAnimationDuration animations:^{
       
        topCard.center = position;
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(cardView:didThrowTopCard:)]) {
            [self.delegate cardView:self didThrowTopCard:topCard];
        }
        [self _recycleThrowedCard];
        [self _updateVisibleCardAfterThrow];
    }];
}

#pragma mark - 回收卡片
- (void)_recycleThrowedCard {
    SHReusableCard *topCard = [self topCard];
    NSAssert(topCard, @"topCard不存在");
    
    NSMutableSet<SHReusableCard *> *cacheForIdentifier = self.reusableCardCache[topCard.reuseIdentifier];
    if (!cacheForIdentifier) {
        cacheForIdentifier = [NSMutableSet new];
        self.reusableCardCache[topCard.reuseIdentifier] = cacheForIdentifier;
    }
    [cacheForIdentifier addObject:topCard];
}

#pragma mark - 更新卡片
- (void)_updateVisibleCardAfterThrow {
    UIView *topCard = [self topCard];
    NSAssert(topCard, @"topCard 不存在.");
    
    [topCard removeFromSuperview];
    [self _disableTopCardRasterize];
    [self.visibleCards removeObjectAtIndex:0];
    
    if (self.countOfVisibleCards == 0) {
        self.userInteractionEnabled = YES;
        return;
    }
    
    if (self.indexForTopCard < self.numberOfCards - 1) {
        self.indexForTopCard += 1;
    }
    
    if (self.maxIndexForVisibleCard < self.numberOfCards -1) {
        self.maxIndexForVisibleCard +=1 ;
        [self _setupConstraintsForCard:[self _getAndAppendCardForIndex:self.maxIndexForVisibleCard]];
    }
    
    // 新插入到后方的卡片不要使用动画，直接和前一张卡片重合
    if (self.countOfVisibleCards == self.maxCountOfVisibleCards) {
        [self _configureCard:self.visibleCards.lastObject atIndex:self.maxIndexForVisibleCard-1];
    }
    
    [UIView animateWithDuration:kInsertAnimationDration animations:^{
        [self.visibleCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _configureCard:obj atIndex:idx];
        }];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if ([self.delegate respondsToSelector:@selector(cardView:didDisPlayTopCard:)]) {
            [self.delegate cardView:self didDisPlayTopCard:topCard];
        }
    }];
    
    
}

#pragma mark - 拖拽相关

- (void)setDragEnabled:(BOOL)dragEnabled {
    _dragEnabled = dragEnabled;
    self.panGestureRecognizer.enabled = dragEnabled;
}

#pragma mark - 卡片信息

- (UIView *)topCard {
    return self.visibleCards.firstObject;
}

- (NSUInteger)countOfVisibleCards {
    return self.visibleCards.count;
}

@end
