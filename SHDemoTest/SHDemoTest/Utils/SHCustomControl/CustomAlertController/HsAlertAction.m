//
//  HsAction.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/2.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "HsAlertAction.h"

@interface HsAlertAction ()
@property (nonatomic, copy) alertAction handler;
@end

@implementation HsAlertAction

- (instancetype)initWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler {
    self = [super init];
    if (self) {
        self.title = title;
        self.style = style;
        self.handler = handler;
    }
    return self;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(HsAlertActionStyle)style handler:(void (^ __nullable)(HsAlertAction *action))handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

@end
