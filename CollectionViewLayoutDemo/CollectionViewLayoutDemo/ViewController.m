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
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusedheader"];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusedfooter"];
}

#pragma mark - <UICollectionViewDatasource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DSHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSHCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    return cell;
}

- (UIColor *)randomColor {
    CGFloat red = (arc4random() % 256) / 255.0;
    CGFloat green = (arc4random() % 256) / 255.0;
    CGFloat blue = (arc4random() % 256) / 255.0;
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return randomColor;
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = arc4random()%100 + 50 ;
    return CGSizeMake(160, height);
}

// this will be called if our layout is MKMasonryViewLayout
- (CGFloat) collectionView:(UICollectionView*) collectionView layout:(MKMasonryViewLayout*) layout heightForItemAtIndexPath:(NSIndexPath*) indexPath {
    // we will use a random height from 100 - 400
    CGFloat randomHeight = 100 + (arc4random() % 140);
    return randomHeight;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusedheader" forIndexPath:indexPath];
        view.backgroundColor = UIColor.redColor;
        return view;
    } else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusedfooter" forIndexPath:indexPath];
        view.backgroundColor = UIColor.yellowColor;
        return view;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50);
}
@end
