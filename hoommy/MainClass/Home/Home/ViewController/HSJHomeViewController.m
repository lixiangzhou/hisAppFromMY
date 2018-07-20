//
//  HSJHomeViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeViewController.h"
#import "HSJTestViewController.h"
#import "HSJListViewController.h"
#import "HSJFragmentViewController.h"
#import "HSJTestWebviewControllerViewController.h"
#import "HSJDepositoryOpenTipController.h"
#import "HSJGestureSettingController.h"
#import "HSJGestureLoginController.h"
#import "HSJPlanDetailController.h"
#import "HSJSignInViewController.h"
#import "HSJHomeCustomNavbarView.h"
#import "HSJHomeHeaderView.h"
#import "HSJHomePlanView.h"

@interface HSJHomeViewController ()

@property (nonatomic, strong) HSJHomeCustomNavbarView *navView;

@property (nonatomic, strong) HSJHomeHeaderView *headerView;

@property (nonatomic, strong) HSJHomePlanView *planView;

@end

@implementation HSJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFullScreenShow = YES;
    
    [self setUI];
//    self.title = @"";
    UIButton* button =[[UIButton alloc] init];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"HSJTestViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* tableViewbutton =[[UIButton alloc] init];
    tableViewbutton.backgroundColor = [UIColor greenColor];
    [tableViewbutton setTitle:@"HSJListViewController" forState:UIControlStateNormal];
    [tableViewbutton addTarget:self action:@selector(tableViewButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tableViewbutton];
    
    UIButton* fragmentButton =[[UIButton alloc] init];
    fragmentButton.backgroundColor = [UIColor greenColor];
    [fragmentButton setTitle:@"HSJFragmentViewController" forState:UIControlStateNormal];
    [fragmentButton addTarget:self action:@selector(fragmentButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fragmentButton];
    
    UIButton* webviewButton =[[UIButton alloc] init];
    webviewButton.backgroundColor = [UIColor greenColor];
    [webviewButton setTitle:@"HSJTestWebviewControllerViewController" forState:UIControlStateNormal];
    [webviewButton addTarget:self action:@selector(webviewButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webviewButton];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentViewTop+HXBStatusBarAndNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [tableViewbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [fragmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableViewbutton.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [webviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fragmentButton.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    NYBaseRequest *req = [NYBaseRequest new];
    req.requestUrl = @"home/baby";
    [req loadData:^(NYBaseRequest *request, id responseObject) {
        
    } failure:^(NYBaseRequest *request, NSError *error) {
        
    }];
}

- (void)setUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.planView];
}

- (void)buttonClickAct:(UIButton*)button {
    HSJDepositoryOpenTipController* vc = [[HSJDepositoryOpenTipController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewButtonClickAct:(UIButton*)button {
    HSJGestureSettingController* vc = [[HSJGestureSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    HSJSignInViewController *vc = [HSJSignInViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fragmentButtonClickAct:(UIButton*)button {
    HSJGestureLoginController* vc = [[HSJGestureLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webviewButtonClickAct:(UIButton*)button {
    HSJPlanDetailController* vc = [[HSJPlanDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (KeyChain.isLogin) {
        self.planView.frame = CGRectMake(0, 300, kScreenWidth, kScrAdaptationH750(578));
    } else {
        self.planView.frame = CGRectMake(0, 300, kScreenWidth, kScrAdaptationH750(656));
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (HSJHomeCustomNavbarView *)navView {
    if (!_navView) {
        _navView = [[HSJHomeCustomNavbarView alloc] init];
        _navView.title = @"红小宝";
        _navView.titleColor = kHXBColor_333333_100;
        _navView.titleFount = kHXBFont_PINGFANGSC_REGULAR_750(40);
        _navView.noticeBlock = ^{
            IDPLogDebug(@"公告");
        };
    }
    return _navView;
}



- (HSJHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HSJHomeHeaderView alloc] initWithFrame:CGRectMake(0, 350, kScreenWidth, kScrAdaptationH750(558))];
        
    }
    return _headerView;
}

- (HSJHomePlanView *)planView {
    if (!_planView) {
        _planView = [[HSJHomePlanView alloc] initWithFrame:CGRectMake(0, 350, kScreenWidth, kScrAdaptationH750(578))];
    }
    return _planView;
}

@end
