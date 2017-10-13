//
//  ViewController.m
//  SHCardView
//
//  Created by shihao on 2017/9/19.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "ViewController.h"
#import "SHCardView.h"
#import "SHTestCardView.h"

@interface ViewController ()<SHCardViewDelegate,SHCardViewDataSource>
@property (strong, nonatomic) IBOutlet SHCardView *cardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.cardView];
    self.cardView.datasource = self;
    self.cardView.delegate = self;
    
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView.leadingAnchor constraintEqualToAnchor:window.leadingAnchor].active = YES;
    [self.cardView.trailingAnchor constraintEqualToAnchor:window.trailingAnchor].active = YES;
    [self.cardView.bottomAnchor constraintEqualToAnchor:window.bottomAnchor].active = YES;
    [self.cardView.topAnchor constraintEqualToAnchor:window.topAnchor constant:64].active = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cardView reloadData];
}

- (IBAction)reloadBarItemClick:(id)sender {
    [self.cardView reloadData];
}

#pragma mark - <SHCardViewDataSource>

- (NSUInteger)numberOfCardsInCardView:(SHCardView *)cardView
{
    return 10;
}

- (UIView *)cardView:(SHCardView *)cardView viewForCardAtIndex:(NSUInteger)index
{
    NSLog(@"%@ - %@", @(__FUNCTION__), @(index));
    
    SHTestCardView *card = [cardView dequeueReusrIdentifier:@"SHTestCardView"];
    if (!card) {
        card = [SHTestCardView testCardView];
        card.frame = ({
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGRect frame = card.frame;
            frame.size = CGSizeMake(screenSize.width - 40, screenSize.height - 64 - 80);
            frame;
        });
        __weak SHCardView *weakCardView = cardView;
        card.likeAction = ^{
            [weakCardView throwTopCardOnDirection:SHCardViewDirectionTop angle:M_PI_2 / 2];
        };
        card.disLikeAction = ^{
            [weakCardView throwTopCardOnDirection:SHCardViewDirectionBottom angle:M_PI_2 * 3 / 2];
        };
    }
    
    card.indexLabel.text = [NSString stringWithFormat:@"%lu", index];
    
    return card;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
