//
//  HXBMyBankResultViewController.m
//  hoomxb
//
//  Created by HXB-xiaoYang on 2017/11/29.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMyBankResultViewController.h"
#import "HxbWithdrawCardViewController.h"
#import "HxbMyBankCardViewController.h"
#import "HXBCommonResultController.h"

@interface HXBMyBankResultViewController ()

@property (nonatomic, strong) HXBCommonResultController *resultController;

@end

@implementation HXBMyBankResultViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"解绑银行卡";
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

#pragma mark - UI

- (void)setupData {
    HXBCommonResultController *VC = [[HXBCommonResultController alloc] init];
    VC.isFullScreenShow = YES;
    self.resultController = VC;
    kWeakSelf
    HXBCommonResultContentModel *contentModel = nil;
    if (self.isSuccess) {
        NSString *tempStr = [NSString stringWithFormat:@"尾号%@的银行卡解绑成功", _mobileText];
        contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_success" titleString:@"解绑成功" descString:tempStr firstBtnTitle:@"绑定新卡"];
    } else {
        contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_failure" titleString:@"解绑失败" descString:self.describeText firstBtnTitle:@"重新解绑"];
    }
    contentModel.secondBtnTitle = @"我的账户";
    
    contentModel.firstBtnBlock = ^(HXBCommonResultController *resultController) {
        [weakSelf actionButtonClick];
    };
    contentModel.secondBtnBlock = ^(HXBCommonResultController *resultController) {
        [weakSelf myAccountButtonClick];
    };
    VC.contentModel = contentModel;
}

- (void)setupUI {
    [self.safeAreaView addSubview:self.resultController.view];
}

- (void)setupConstraints {
    [self.resultController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.safeAreaView);
    }];
}


#pragma mark - Action
// 点击返回
- (void)leftBackBtnClick {
    HXBBaseNavigationController *navVC = (HXBBaseNavigationController*)self.navigationController;
    UIViewController *vc = [navVC getViewControllerByClassName:@"HSJBuyViewController"];
    if(vc) {
        [navVC popToViewController:vc animated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

// 点击重新绑卡按钮
- (void)actionButtonClick {
    if (_isSuccess) {
        //进入绑卡界面
        HxbWithdrawCardViewController *withdrawCardViewController = [[HxbWithdrawCardViewController alloc] init];
        withdrawCardViewController.title = @"绑卡";
        withdrawCardViewController.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
        [self.navigationController pushViewController:withdrawCardViewController animated:YES];
    } else {
        [self leftBackBtnClick];
    }

}

// 点击我的账户按钮
- (void)myAccountButtonClick {
    [self.navigationController popToRootViewControllerAnimated:NO];
    HXBBaseNavigationController *navVC = (HXBBaseNavigationController*)[HXBRootVCManager manager].mainTabbarVC.viewControllers.lastObject;
    if(self.navigationController != navVC){
        [HXBRootVCManager manager].mainTabbarVC.selectedIndex = [HXBRootVCManager manager].mainTabbarVC.viewControllers.count-1;
    }
}

@end
