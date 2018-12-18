//
//  SHPopViewController.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/6.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "SHPopViewController.h"
#import "HsPopLabel.h"

@interface SHPopViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) HsPopLabel *popLabel;
@end

@implementation SHPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.popLabel = [[HsPopLabel alloc] initWithFrame:CGRectMake(0, -10, 0, 25)];
    self.popLabel.backgroundColor = [HsConfigration uiColorFromString:@"#108EE9"];
    [self.popLabel setCornerRadius:2.0];
    self.popLabel.textColor = [UIColor whiteColor];
    self.popLabel.font = [UIFont systemFontOfSize:14];
    self.popLabel.hidden = NO;
    [self.textField addSubview:self.popLabel];
    
    
    self.textField.delegate =  self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSArray *testStrings = @[@"999",@"666.666",@"888",@"88.0000000000"];
    [self updatePopLabelText:testStrings[arc4random()%4]];
    [self.popLabel showDelay:3];
    return YES;
}

- (void)updatePopLabelText:(NSString *)text {
    self.popLabel.text = text;
    [self.popLabel sizeToFit];
    CGRect rect = self.popLabel.frame;
    rect.size.height = 20;
    if (text.length > 0) { rect.size.width += 16; }
    rect.origin.x = (CGRectGetWidth(self.textField.bounds) - rect.size.width) / 2;
    self.popLabel.frame = rect;
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
