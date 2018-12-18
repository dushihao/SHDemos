//
//  RotationButtonViewController.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/9/4.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import "RotationButtonViewController.h"

@interface RotationButtonViewController () <CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet  UIButton *rotationButton;
@end

@implementation RotationButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self startRotation];
}

- (void)startRotation {
    /*
     * UIView animation
    [UIView animateWithDuration:0.5 animations:^{
        self.rotationButton.transform = CGAffineTransformRotate(self.rotationButton.transform, M_PI);
    } completion:^(BOOL finished) {
        [self startRotation];
    }];
     */
    
    /*
     * CALayer animation
     */
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:0];
    basicAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    basicAnimation.duration = 1;
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.delegate = self;
    basicAnimation.removedOnCompletion = NO;
    [self.rotationButton.layer addAnimation:basicAnimation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rotationButton.layer removeAllAnimations];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
