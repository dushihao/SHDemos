//
//  SHScrollTaoTableViewController.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/21.
//  Copyright © 2018 hundsun. All rights reserved.
//

#import "SHScrollTaoTableViewController.h"
#import "ZXMutipleGestureTableView.h"

@interface SHScrollTaoTableViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    BOOL _canScroll;
}
@property (nonatomic, strong) UIScrollView *superScrollView;
@property (nonatomic, strong) ZXMutipleGestureTableView *contentTableView;

@end

@implementation SHScrollTaoTableViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _canScroll = YES;
    // Do any additional setup after loading the view.
    self.superScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64)];
    self.superScrollView.backgroundColor = [UIColor greenColor];
    self.superScrollView.bounces = NO;
    self.superScrollView.delegate = self;
    [self.view addSubview:self.superScrollView];
    
    self.contentTableView = [[ZXMutipleGestureTableView alloc] initWithFrame:CGRectMake(0, 250, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64)];
    self.contentTableView.rowHeight = 50;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.bounces = NO;
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.superScrollView addSubview:self.contentTableView];
    
    self.superScrollView.contentSize = CGSizeMake(0, MAIN_SCREEN_HEIGHT - 64 + 250);
//    [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    CGFloat r = (arc4random() % 256) / 255.0;
//    CGFloat g = (arc4random() % 256) / 255.0;
//    CGFloat b = (arc4random() % 256) / 255.0;
//    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES
     ];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 40)];
    lable.backgroundColor = [UIColor redColor];
    lable.text = @"表头";
    return lable;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    if (self.superScrollView == scrollView) {
        NSLog(@"superScrollView");
        if (!_canScroll) {
            [self.superScrollView setContentOffset:CGPointMake(0, 250)];
        }
    }
    
    if (self.contentTableView == scrollView) {
        CGRect tableViewRect = [self.contentTableView convertRect:self.contentTableView.bounds toView:self.view];
        CGFloat tableViewY = tableViewRect.origin.y;
        
        if (scrollView.contentOffset.y <= 0) {
            _canScroll = YES;
            scrollView.contentOffset = CGPointZero;
        } else {
            if (_canScroll && tableViewY > 0) {
                if (self.superScrollView.contentOffset.y < 250 ) {
                    scrollView.contentOffset = CGPointZero;
                }
                if (self.superScrollView.contentOffset.y >= 250) {
                    _canScroll = NO;
                }
            }
        }
    }
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
