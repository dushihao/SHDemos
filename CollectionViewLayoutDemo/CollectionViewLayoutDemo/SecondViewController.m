//
//  SecondViewController.m
//  CollectionViewTest
//
//  Created by shihao on 2017/8/29.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "SecondViewController.h"
#import "SHCollectionViewFlowlayout.h"
#import "DSHCollectionViewCell.h"

@interface SecondViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 处理 item 下移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SHCollectionViewFlowlayout *layout = [[SHCollectionViewFlowlayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 30;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    layout.itemSize = CGSizeMake(160, 160);
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.dataSource = self;

}

#pragma mark - <UICollectionViewDatasource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DSHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSHCollectionViewCell" forIndexPath:indexPath];
    return cell;
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
