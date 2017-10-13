//
//  SHTestCardView.m
//  SHCardView
//
//  Created by shihao on 2017/9/19.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "SHTestCardView.h"

@implementation SHTestCardView


+ (instancetype)testCardView{
    
    return [[UINib nibWithNibName:@"SHTestCardView" bundle:nil] instantiateWithOwner:nil options:nil][0];
}

- (void)prepareForReuse{
    
//    self.addLabel.alpha = 0;
//    self.removeLabel.alpha = 0;
}

- (IBAction)dislikeButtonClick:(id)sender {
    !self.disLikeAction ?:self.disLikeAction();
}

- (IBAction)likeButtonClick:(id)sender {
    !self.likeAction ?:self.likeAction();
}

@end
