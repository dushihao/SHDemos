//
//  SHChildViewController.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/8/31.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import "SHChildViewController.h"

@interface SHChildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *suspendButton;
@end

@implementation SHChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (UIButton *)suspendButton {
    if (!_suspendButton) {
        _suspendButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.tableView.bounds) - 100, CGRectGetHeight(self.tableView.bounds) - 100, 50, 50)];
        [_suspendButton setImage:[UIImage imageNamed:@"排序"] forState:UIControlStateNormal];
    }
    return _suspendButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.suspendButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

@end
