//
//  HSLinkAlertView.h
//  SHDemoTest
//
//  Created by hsadmin on 2018/9/10.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSLinkAlertView;
typedef void(^callBackBlock) (NSInteger agreeCount);

@protocol HSLinkAlertViewDelegate <NSObject>

@optional

/**
 press link

 @param linkAlertView instance
 @param index link index
 */
- (void)linkAlertView:(HSLinkAlertView *)linkAlertView didSelectLinkAtIndex:(NSInteger)index;

/**
 dismiss linkAlertView

 @param linkAlertView instance
 @param index 0:cancel 1:confirm
 @param count 已同意并打钩的合同个数
 */
- (void)linkAlertView:(HSLinkAlertView *)linkAlertView dismissWithClickedButtonIndex:(NSInteger)index checkCount:(NSInteger)count;

@end

@interface HSLinkAlertView : UIView

/// default is ""
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *links;

@property (nonatomic, strong) callBackBlock confirmBlock;

@property (nonatomic, weak) id<HSLinkAlertViewDelegate> delegate;

+ (instancetype)alertWithTitle:(NSString *)title  message:(NSString *)message links:(NSArray *)links;

- (void)show;
- (void)dismiss;
@end
