//
//  HSJBabyHeadlineViewController.m
//  hoommy
//
//  Created by caihongji on 2018/8/3.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBabyHeadlineViewController.h"
#import "HXBUMengShareManager.h"
#import "HXBUMShareViewModel.h"

@interface HSJBabyHeadlineViewController ()
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation HSJBabyHeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.title = @"";
    self.isShowCloseButton = NO;
    self.webView.scrollView.delegate = self;
    
    //右侧按钮
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.backgroundColor = [UIColor greenColor];
    [self.rightBtn sizeToFit];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.rightBtn]];
}

#pragma  mark 重写基类方法
- (void)setupLeftBackBtn
{
    if(self.navigationController.viewControllers.count <= 1) {
        return;
    }
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    self.leftBackBtn = leftBackBtn;
    [leftBackBtn setTitle:[NSString stringWithFormat:@"     %@", self.pageTitle] forState:UIControlStateNormal];
    leftBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBackBtn.titleLabel.font = kHXBFont_34;
    [leftBackBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    if(self.isFullScreenShow) {
        [leftBackBtn setImage:nil forState:UIControlStateNormal];
        [leftBackBtn setImage:nil forState:UIControlStateHighlighted];
    }
    else {
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateHighlighted];
    }
    [leftBackBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:leftBackBtn]];
}

- (void)leftBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    HXBUMShareViewModel *shareViewModel = [[HXBUMShareViewModel alloc] init];
    shareViewModel.shareModel = nil;
    shareViewModel.shareViewTitle = @"文章分享到";
    [HXBUMengShareManager showShareMenuViewInWindowWith:shareViewModel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y > kScrAdaptationH(20)) {
        [self.leftBackBtn setTitleColor:kHXBColor_333333_100 forState:UIControlStateNormal];
    }
    else {
        [self.leftBackBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
