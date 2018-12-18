//
//  ZFSelectionView.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/11/29.
//  Copyright © 2018 hundsun. All rights reserved.
//  

#import "ZFSelectionView.h"

NSInteger const kBaseButtonTag = 100;

@interface ZFSelectionView ()

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@end

@implementation ZFSelectionView

- (instancetype)initWithImageStringArray:(NSArray *)imageStrArray {
    self = [super init];
    if (self) {
        _imageStrArray = imageStrArray;
        
        _selectImageView = [[UIImageView alloc] init];
        _imagesScrollView = [[UIScrollView alloc] init];
        [self addSubview:_selectImageView];
        [self addSubview:_imagesScrollView];
        
        __block UIButton *tagButton;
        [_imageStrArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [imageButton setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
            imageButton.tag = kBaseButtonTag + idx;
            [imageButton sizeToFit];
            imageButton.frame = CGRectMake(tagButton.right, 0, imageButton.width, imageButton.height);
            [imageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.imagesScrollView addSubview:imageButton];
            self.imagesScrollView.contentSize = CGSizeMake(tagButton.right, 0);
            tagButton = imageButton;
        }];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)commonInit {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_selectImageView sizeToFit];
    _selectImageView.frame = CGRectMake((self.width - _selectImageView.width)/2, 0, _selectImageView.width, _selectImageView.height);
    _imagesScrollView.frame = CGRectMake(0, _selectImageView.bottom, self.width, _selectImageView.height);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        return;
    }
}

- (void)buttonClick:(UIButton *)sender {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
