//
//  ZFSelectionView.h
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/29.
//  Copyright © 2018 hundsun. All rights reserved.
//  切换模式控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFSelectionView : UIView

@property (nonatomic, copy) NSArray <NSString *>*imageStrArray;

- (instancetype)initWithImageStringArray:(NSArray *)imageStrArray;

@end

NS_ASSUME_NONNULL_END
