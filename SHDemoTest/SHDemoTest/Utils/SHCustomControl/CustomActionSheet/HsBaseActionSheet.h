//
//  HsBaseActionSheet.h
//  
//
//  Created by hsadmin on 2018/5/7.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HsBaseActionSheet;

@protocol HsBaseActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(HsBaseActionSheet *)actionSheet didSelectRowAtIndex:(NSInteger)row;

@end

/// 底部单选actionsheet
@interface HsBaseActionSheet : UIControl<UITableViewDelegate,UITableViewDataSource>
/// 内容视图
@property (nonatomic, strong) UIView *contentView;
/// 头部视图
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, copy) NSString *title;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题背景颜色
@property (nonatomic, strong) UIColor *titleBackGoundColor;
/// title horizen alignment default is center
@property (nonatomic, assign) NSTextAlignment titleAlignment;
/// 标签数组
@property (nonatomic, strong) NSMutableArray *contents;
/// 列表视图
@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, weak) id<HsBaseActionSheetDelegate> delegate;
@property (nonatomic, copy) void(^completion)(NSInteger index);

+ (instancetype)actionSheet;
+ (instancetype)ActionSheetWithTitle:(NSString *)title contents:(NSMutableArray *)contents;

/**
 选中某一行

 @param index 选中索引
 */
- (void)selectRow:(NSInteger)index;

/**
 自定义显示内容

 @return 自定义内容视图
 */
- (UIView *)customView;

/**
 控件初始化
 */
- (void)prepare;

/**
 子类布局使用
 */
- (void)placeSubViews;

- (void)show;
- (void)showWithCompletion:(void(^)(NSInteger index))completion;
- (void)dismiss;


/**
 点击背景
 */
- (void)backGroundClick;
@end


@class HsEditActionSheet;

@protocol HsEditActionSheetDelegate <NSObject,HsBaseActionSheetDelegate>

@optional

- (void)actionSheet:(HsEditActionSheet *)actionSheet willDeleteTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)actionSheet:(HsEditActionSheet *)actionSheet didDeleteTitle:(NSString *)title atIndex:(NSInteger)index;

@end


/// 可编辑

@interface HsEditActionSheet : HsBaseActionSheet

/// 编辑状态 0：未编辑 1：编辑状态
@property (nonatomic,assign,getter=isEdited) BOOL edited;

@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIColor *editButtonColor;

@property (nonatomic, weak) id<HsEditActionSheetDelegate> delegate;

@end

