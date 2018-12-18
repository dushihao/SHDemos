//
//  HsAlertViewController.h
//  仿系统alertController
//
//  Created by dush on 2018/11/2.
//  Copyright © 2018 dush. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, HsAlertActionStyle){
    HsAlertActionStyleDefault = 0,
    HsAlertActionStyleCancel,
    HsAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, HsAlertControllerStyle) {
    HsAlertControllerStyleActionSheet = 0,
    HsAlertControllerStyleAlert
} ;

@interface HsAlertAction : NSObject

typedef void(^alertAction)(HsAlertAction *action);

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler;

@property (nullable, nonatomic) NSString *title;
@property (nonatomic, assign) HsAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@property (nonatomic, strong) UIButton *button;

@end


@interface HsAlertViewController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message tips:(NSString *)tips preferredStyle:(HsAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(HsAlertControllerStyle)preferredStyle;

- (void)addAction:(HsAlertAction *)action;
@property (nonatomic, strong) NSMutableArray<HsAlertAction *> *actions;

@property (nonatomic, strong, nullable) HsAlertAction *preferredAction NS_AVAILABLE_IOS(9_0);

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *alertTitle;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *tips;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic) HsAlertControllerStyle preferredStyle;

@end

NS_ASSUME_NONNULL_END
