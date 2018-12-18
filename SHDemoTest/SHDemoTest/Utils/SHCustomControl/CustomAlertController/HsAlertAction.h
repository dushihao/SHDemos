//
//  HsAction.h
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/2.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef  NS_ENUM(NSInteger, HsAlertActionStyle){
    HsAlertActionStyleDefault = 0,
    HsAlertActionStyleCancel,
    HsAlertActionStyleDestructive
};

@interface HsAlertAction : NSObject

typedef void(^alertAction)(HsAlertAction *action);

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler;

@property (nullable, nonatomic) NSString *title;
@property (nonatomic, assign) HsAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
