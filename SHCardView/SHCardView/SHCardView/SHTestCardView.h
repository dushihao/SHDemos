//
//  SHTestCardView.h
//  SHCardView
//
//  Created by shihao on 2017/9/19.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCardView.h"

@interface SHTestCardView : UIView <SHCardViewReuseableCard>
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (nonatomic, readonly) NSString *reuseIdentifier;


@property (nonatomic) void(^likeAction)(void);
@property (nonatomic) void (^disLikeAction)(void);

- (void)prepareForReuse;
+ (instancetype)testCardView;

@end
