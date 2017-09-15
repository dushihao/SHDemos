//
//  ViewController.m
//  CollectionViewTest
//
//  Created by shihao on 2017/8/22.
//  Copyright © 2017年 shihao. All rights reserved.
//

#import "ViewController.h"
#import "DSHCollectionViewCell.h"
#import "SHCollectionViewFlowlayout.h"
#import "MKMasonryViewLayout.h"

#import "SecondViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MKMasonryViewLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDidtance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightDistance;


@end

@implementation ViewController



- (IBAction)rightButtonClick:(id)sender {
   // 流式布局☺
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *pushVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    [self.navigationController pushViewController:pushVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    SHCollectionViewFlowlayout *layout = [[SHCollectionViewFlowlayout alloc]init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 30;
//    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    layout.itemSize = CGSizeMake(160, 160);
//    self.collectionView.collectionViewLayout = layout;
    
    MKMasonryViewLayout *layout1 = [[MKMasonryViewLayout alloc]init];
    layout1.delegate = self;
    self.topDidtance.constant = 0;
    self.heightDistance.constant= CGRectGetHeight(self.view.bounds);
    self.collectionView.collectionViewLayout = layout1;
    self.collectionView.delegate = self;
    [self.collectionView reloadData];
    
    
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


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = arc4random()%100 + 50 ;
    return CGSizeMake(160, height);
}

// this will be called if our layout is MKMasonryViewLayout
- (CGFloat) collectionView:(UICollectionView*) collectionView
                    layout:(MKMasonryViewLayout*) layout
  heightForItemAtIndexPath:(NSIndexPath*) indexPath {
    
    // we will use a random height from 100 - 400
    
    CGFloat randomHeight = 100 + (arc4random() % 140);
    return randomHeight;
}
@end
