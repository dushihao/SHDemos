//
//  ViewController.m
//  SHDemoTest
//
//  Created by hsadmin on 2018/7/12.
//  Copyright © 2018年 hundsun. All rights reserved.
//

#import "ViewController.h"
#import "SHChildViewController.h"
#import "SHChildTwoViewController.h"
#import "HsBaseActionSheet.h"
#import "HSLinkAlertView.h"
#import "HsNoticeTooltipView.h"
#import "HsAlertViewController.h"
#import "ZFTipAlertView.h"
#import "ZFSelectionView.h"

@interface ViewController () <HSLinkAlertViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollview;
@property (weak, nonatomic) NSObject *testObject;
@property (nonatomic,strong) NSMutableArray *ViewControllers;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

typedef void (^MyBlock)(void);

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    /*
     *
    self.testObject = [NSObject new];
    */
    
    /*
     * 设置webview 禁止滚动
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.zhihu.com/question/286602258/answer/466492749"]]];
    self.webView.scrollView.scrollEnabled = NO;
    */
    
    /*
     * 通知 test
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"sh_notification" object:@"1"];
     */
    
    /*
     * block 截获自动变量
    NSArray *blockArray = [self getBlockArray];
    MyBlock blk0 = (MyBlock)[blockArray objectAtIndex:0];
    blk0();
     */
    
    /*
     * 多线程测试
     test1();
     */
    
    /*
     *
    [self addChildViewController];
    [self configText];
     */
    
    /*
    testFloat();
     */
    
    ZFSelectionView *selectionView = [[ZFSelectionView alloc] initWithImageStringArray:@[@"1",@"2"]];
    selectionView.frame = CGRectMake(100, 200, 200, 100);
    [self.view addSubview:selectionView];
}

- (void)viewDidLayoutSubviews {
    
    
}

- (void)configText {
    NSMutableParagraphStyle *style = [_textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];//段落样式
    style.minimumLineHeight = _textField.font.lineHeight - (_textField.font.lineHeight - [UIFont systemFontOfSize:16.0].lineHeight) / 2.0;//计算出高度差，使placeholder能够居然
    
    _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入消费金额" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"c7c7cd"],
                                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:16.0],
                                                                                                         NSParagraphStyleAttributeName : style}];
}

- (NSArray *)getBlockArray {
    
    CGFloat val = 10;
    return [NSArray arrayWithObjects:[^{NSLog(@"lalala%f",val);} copy],[^{NSLog(@"lueluelue %f",val);} copy], nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sh_notification" object:@"1" userInfo:@{@"key" : @"value"}];
}

- (void)notification:(NSNotification *)noti {}

void test1() {
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dsh.test", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{NSLog(@"...1");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...2");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...3");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...4");});
    dispatch_barrier_sync(concurrentQueue, ^{
        
        NSLog(@"blockForWriting");
    });
    NSLog(@"当前线程");
    dispatch_async(concurrentQueue, ^{NSLog(@"...5");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...6");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...7");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...8");});
    dispatch_async(concurrentQueue, ^{NSLog(@"...9");});
    
}

void testFloat() {
    float f = 1234567.1234;
    CGFloat cgf = 1234567.1234;
    
    NSLog(@"%.3f == %.3f", f, cgf);
}

- (IBAction)showAlertView:(id)sender {
    
    HsNoticeTooltipView *tipView = [HsNoticeTooltipView tipWithTitle:@"总资产说明" Alert:nil Content:@"总资产包含您的证券财产什么什么什么什么及现金财产" TitleImage:nil Style:HsNoticeTooltipViewTypeSingle MarginWidth:50 TextAlignment:NSTextAlignmentCenter];
    tipView.contentTextColor = [UIColor blackColor];
    [tipView show];
    
    
//    ZFTipAlertView *alertView = [ZFTipAlertView alertView];
//    [alertView show];
    
//    NSString *message = @"单行提示自定义弹窗提示";
//    HsAlertViewController *alertViewController = [HsAlertViewController alertControllerWithTitle:@"系统提示" message:message preferredStyle:HsAlertControllerStyleAlert];
//    [alertViewController addAction:[HsAlertAction actionWithTitle:@"确定" style:HsAlertActionStyleDestructive handler:nil]];
//    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (IBAction)showalertViewStyle2:(id)sender {
    
    /**
    NSString *message = @"名称：山西证券\n代码：050025\n价格：1.00\n数量：100000";
    HsAlertViewController *alertViewController = [HsAlertViewController alertControllerWithTitle:@"撤单确认" message:message preferredStyle:HsAlertControllerStyleAlert];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"撤单" style:HsAlertActionStyleDestructive handler:nil]];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"撤单后继续买入" style:HsAlertActionStyleDestructive handler:nil]];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"取消" style:HsAlertActionStyleCancel handler:^(HsAlertAction * _Nonnull action) {
     
    }]];

    [self presentViewController:alertViewController animated:YES completion:nil];
     */
    
    NSString *message = [NSString stringWithFormat:@"撤单已提交，委托编号:%@",@"41"];
    //            NSString *message = @"该委托已成功申请撤单";
    HsAlertViewController *alertViewController = [HsAlertViewController alertControllerWithTitle:@"系统提示" message:message preferredStyle:HsAlertControllerStyleAlert];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"确定" style:HsAlertActionStyleDestructive handler:^(HsAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (IBAction)showAlertViewStyle3:(id)sender {
    NSString *message = @"账户：1234567890\n名称：山西证券\n代码：050025\n价格：1.00\n数量：100000";
    HsAlertViewController *alertViewController = [HsAlertViewController alertControllerWithTitle:@"买入确认" message:message tips:@"请问倒垃圾爱空间发福利卡的" preferredStyle:HsAlertControllerStyleAlert];

//    [alertViewController addAction:[HsAlertAction actionWithTitle:@"撤单后继续买入" style:HsAlertActionStyleDestructive handler:nil]];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"关闭" style:HsAlertActionStyleDefault handler:^(HsAlertAction * _Nonnull action) {
        
    }]];
    [alertViewController addAction:[HsAlertAction actionWithTitle:@"确定" style:HsAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (IBAction)showSystemAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil
    , nil];
    [alert show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    return;
}

- (IBAction)buttonClick:(UISegmentedControl *)sender {
    NSInteger selectIndex = sender.selectedSegmentIndex;
    [self.contentScrollview addSubview:_ViewControllers[selectIndex]];
    [self.contentScrollview setContentOffset:CGPointMake(CGRectGetWidth(self.view.bounds) * selectIndex, 0) animated:YES];
}

- (IBAction)sortButtonClick:(id)sender {
    NSMutableArray *contents = [NSMutableArray arrayWithObjects:@"樱木花道",@"流川枫",@"仙道", nil];
    HsBaseActionSheet *actionSheet = [HsBaseActionSheet ActionSheetWithTitle:nil contents:contents];
    [actionSheet selectRow:[contents indexOfObject:@""]];
    [actionSheet showWithCompletion:^(NSInteger index) {
       
    }];
}

- (IBAction)linkButtonClick:(id)sender {
    HSLinkAlertView *linkAlertView = [HSLinkAlertView alertWithTitle:@"电子合同相关介绍" message:@"就离开" links:@[@"《电子合同文本》",@"《电子合同文本文本文本文本哇擦擦擦擦》",@"《电子合同文本合同合同合同合同》"]];
    linkAlertView.delegate = self;
    [linkAlertView show];
}

- (void)addChildViewController {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.contentScrollview.contentSize = CGSizeMake(2 * width, 0);
    
    SHChildViewController *childVC_1 = [SHChildViewController new];
    [self addChildViewController:childVC_1];
    childVC_1.view.frame = CGRectMake(0, 0, width, height - 64);
    [self.contentScrollview addSubview:childVC_1.view];
    [childVC_1 didMoveToParentViewController:self];
    
    SHChildTwoViewController *childVC_2 = [SHChildTwoViewController new];
    childVC_2.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:childVC_2];
    childVC_2.view.frame = CGRectMake(width, 0, width, height);
    [self.contentScrollview addSubview:childVC_2.view];
    [childVC_2 didMoveToParentViewController:self];
    
    [_ViewControllers addObject:childVC_1.view];
    [_ViewControllers addObject:childVC_2.view];
}

#pragma mark - HSLinkAlertViewDelegate
- (void)linkAlertView:(HSLinkAlertView *)linkAlertView didSelectLinkAtIndex:(NSInteger)index {
    NSLog(@"...点击链接索引：%ld",(long)index);
}

- (void)linkAlertView:(HSLinkAlertView *)linkAlertView dismissWithClickedButtonIndex:(NSInteger)index checkCount:(NSInteger)count{
    NSLog(@"...点击按钮索引：%ld，已打钩合同个数%ld", (long)index, (long)count);
}

@end
