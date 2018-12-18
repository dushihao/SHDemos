//
//  HsBaseActionSheet.m
//  
//
//  Created by hsadmin on 2018/5/7.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import "HsBaseActionSheet.h"
#import "UIImage+HsImageColor.h"

CGFloat const kCellHeight = 55;

@interface UIView (SHExtension)

/// 设置样式之后，计算label适应的size
- (CGSize)sh_calculateSizeAfterSetAppearance;

@end

@implementation UIView (SHExtension)

- (CGSize)sh_calculateSizeAfterSetAppearance
{
    [self sizeToFit];
    return self.frame.size;
}

@end

@interface HsAccountTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

@property (nonatomic, strong) UIColor *itemTitleNormalColor;
@property (nonatomic, strong) UIColor *itemTitleSelectColor;
@property (nonatomic, strong) UIColor *itemTitleBackGroundSelectColor;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *checkImageView;

@end
@implementation HsAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    self.itemTitleNormalColor = [UIColor colorWithHexString:@"#414141"];
    self.itemTitleSelectColor = [UIColor colorWithHexString:@"f24957"];
    self.itemTitleBackGroundSelectColor = [UIColor lightTextColor];
    
    _label = [[UILabel alloc]init];
    [self.contentView addSubview:_label];
    
    _checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 27, 0, 12, kCellHeight)];
    _checkImageView.image = [UIImage imageNamed:@""];
    _checkImageView.contentMode = UIViewContentModeCenter;
    _checkImageView.hidden = YES;
    [self.contentView addSubview:_checkImageView];
}

- (void)layoutSubviews
{
    for (UIControl *control in self.subviews){ // 修改删除图片
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in [[control.subviews reverseObjectEnumerator] allObjects])
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    img.image = [UIImage imageNamed:@"login_icon_click_account_change_delete_minus"];
                    img.backgroundColor = [UIColor whiteColor];
                }
                break;
            }
        }
    }
    
    for (UIView *subview in self.subviews) {
        
        if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]
            && [subview.subviews count] >= 1){
           
            UIButton *deleteButton = subview.subviews[0];
            [deleteButton setBackgroundColor:HsColorWithHexStr(@"#f24957")];
            deleteButton.titleLabel.font = FONT(16);
        }
    }

    [super layoutSubviews];
}

#pragma mark - Setter & Getter
- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    _checkImageView.hidden = selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        // 0xcccccc
        self.contentView.backgroundColor = self.itemTitleBackGroundSelectColor;
    } else {
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        } completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _checkImageView.hidden = !selected;
//    _label.textColor = selected ? self.itemTitleSelectColor : self.itemTitleNormalColor;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleAlignment = titleAlignment;
    
    CGSize fitSize = [_label sh_calculateSizeAfterSetAppearance];
    if (_titleAlignment == NSTextAlignmentCenter) {
        _label.frame = CGRectMake((MAIN_SCREEN_WIDTH - fitSize.width)/2, 0, fitSize.width, kCellHeight);
    } else {
        _label.frame = CGRectMake(15, 0, fitSize.width, kCellHeight);
    }
}

@end

@interface HsBaseActionSheet()

@end

@implementation HsBaseActionSheet

#pragma mark - Initialization

- (void)dealloc{}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview: [self customView]];
        
        [self addTarget:self action:@selector(backGroundClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title contents:(NSMutableArray *)contents
{
    self.title = title;
    self.contents = [NSMutableArray arrayWithArray:contents];
    
    if (self = [super init]) {

        [self commonInit];
        [self prepare];
    }
    return self;
}

- (void)commonInit
{
    self.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    
    if (!self.titleAlignment) { self.titleAlignment = NSTextAlignmentCenter; }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleColor = [UIColor colorWithHexString:@"999999"];
    self.titleBackGoundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    [self addSubview:self.contentView];
    if (self.title) { [self.contentView addSubview:self.headerView]; }
    [self.contentView addSubview:self.contentTableView];
}

+ (instancetype)ActionSheetWithTitle:(NSString *)title contents:(NSMutableArray *)contents
{
    return [[self alloc]initWithTitle:title contents:contents];
}

+ (instancetype)actionSheet
{
    return [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

#pragma mark - TableViewDelegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HsAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HsAccountTableViewCell class])];
    cell.title = _contents[indexPath.row];
    cell.titleAlignment = self.titleAlignment;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.completion ? : self.completion(indexPath.row);
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:didSelectRowAtIndex:)]) {
        [self.delegate actionSheet:self didSelectRowAtIndex:indexPath.row];
    }
    
    [self dismiss];
}

#pragma mark - Setter
- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleAlignment = titleAlignment;
}

#pragma mark - Lazy load
- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        CGFloat height = (kCellHeight + 0.5) * rowCountFromArray(_contents.count);
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height)];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.rowHeight = kCellHeight + 0.5;
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.separatorInset = UIEdgeInsetsZero;
        _contentTableView.separatorColor = HsColorWithHexStr(@"#e5e5e5");
        [_contentTableView registerClass:[HsAccountTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HsAccountTableViewCell class])];
    }
    return _contentTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kCellHeight)];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        headerLabel.text = _title;
        headerLabel.textColor = self.titleColor;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:headerLabel];
        
        headerView.backgroundColor = self.titleBackGoundColor;
        headerView.contentMode = UIViewContentModeCenter;
        _headerView = headerView;
    }
    return _headerView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat height = 0.0;
        NSInteger rows = rowCountFromArray(_contents.count);
        if (_title) { // 列表sheet
            height = (kCellHeight + 0.5) * rows + kCellHeight;
        } else { // 自定义sheet
            height = [self customView].height;
            if (height == 0) {
                height = kCellHeight * rows;
            }
        }
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT - height, MAIN_SCREEN_WIDTH, height + g_safeAreaInsets.bottom)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

#pragma mark - Show & dismiss
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    // 预防多次添加actiosheet
//    if (window.subviews.count >1) {return;}
    
    [window addSubview:self];
}

- (void)showWithCompletion:(void(^)(NSInteger index))completion
{
    [self show];
    self.completion = completion;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.frameY = MAIN_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)backGroundClick
{
    [self dismiss];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {return;}
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    CGFloat height = self.contentView.height;
//    self.contentView.transform = CGAffineTransformMakeTranslation(0, MAIN_SCREEN_HEIGHT);
    self.contentView.frameY = MAIN_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.frameY = MAIN_SCREEN_HEIGHT - height;
    } completion:nil];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [self placeSubViews];
    [super layoutSubviews];
}

- (void)placeSubViews{}

#pragma mark - Convinence
static inline CGFloat rowCountFromArray (CGFloat count)
{
    return count <= 5 ? count : 5;
}

#pragma mark  Public
- (void)selectRow:(NSInteger)index
{
    NSInteger selectIndex = (index != NSNotFound ? index : 0);
    [self.contentTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)prepare{}

- (UIView *)customView
{
    return nil;
}

@end

#pragma mark -
@implementation HsEditActionSheet

@dynamic delegate;

- (void)prepare
{
    [super prepare];
    if (self.contents.count == 0) {
        [self showNoneDataView];
    }else {
        // 管理按钮
        self.editButtonColor = [UIColor colorWithHexString:@"007de6"];
        [self.headerView addSubview:self.editButton];
    }
}

- (void)placeSubViews
{
    [super placeSubViews];
    CGSize fitSize =  [self.editButton sh_calculateSizeAfterSetAppearance];
    [self.editButton setFrame:CGRectMake(MAIN_SCREEN_WIDTH - 15 - fitSize.width, 0, fitSize.width, kCellHeight)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self configDeleteButton];
}

#pragma mark TableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editButton.isSelected;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HsAccountTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self layoutIfNeeded];
    [cell setNeedsLayout];
    [self setNeedsLayout];
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // default is delete
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {return;}
    
    NSInteger index = indexPath.row;
    NSString *account = self.contents[index];
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDeleteTitle:atIndex:)]) {
        [self.delegate actionSheet:self willDeleteTitle:account atIndex:index];
    }
    
    [self.contents removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:didDeleteTitle:atIndex:)]) {
        [self.delegate actionSheet:self didDeleteTitle:account atIndex:index];
    }
    
    if (self.contents.count == 0) {
        [self.contentTableView reloadData];
        [self showNoneDataView];
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.contentView.frameY = MAIN_SCREEN_HEIGHT - 135;
        } completion:nil];
    }
}

// Lazy load
- (UIButton *)editButton
{
    if (!_editButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"管理" forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [button setTitleColor:self.editButtonColor forState:UIControlStateNormal];
        [button setTitleColor:self.editButtonColor forState:UIControlStateSelected];

        [button addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editButton = button;
    }
    return _editButton;
}

- (void)editButtonClick:(UIButton *)sender
{
    _editButton.selected = !_editButton.selected;
    [self.contentTableView setEditing:_editButton.selected animated:YES];
    
}

#pragma mark - Convenice
- (void)configDeleteButton
{
    if (@available(iOS 11.0, *)) {
        for (UIView *subview in self.contentTableView.subviews) {
           
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]
                && [subview.subviews count] >= 1) {

                UIButton *deleteButton = subview.subviews[0];
                [deleteButton setBackgroundColor:HsColorWithHexStr(@"#f24957")];
                deleteButton.titleLabel.font = FONT(16);
            }
        }
    }
}

- (void)showNoneDataView
{
    self.editButton.hidden = YES;
    
    UILabel *noneDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 90)];
    noneDataLabel.text = @"您还未保存任何账号";
    //        noneDataLabel.contentMode = UIViewContentModeCenter;
    noneDataLabel.textAlignment = NSTextAlignmentCenter;
    self.contentTableView.tableHeaderView = noneDataLabel;
    self.contentView.height += 90;
    self.contentTableView.height = 90;
}

@end
