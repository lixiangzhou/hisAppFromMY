//
//  HSJMyAccountBalanceController.m
//  hoommy
//
//  Created by hxb on 2018/7/20.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyAccountBalanceController.h"
#import "HSJMyAccountBalanceHeadView.h"
#import "HxbWithdrawViewController.h"
#import "HSJBuyViewController.h"
#import "HSJRollOutPlanDetailController.h"

@interface HSJMyAccountBalanceController ()
@property (nonatomic,strong) HSJMyAccountBalanceHeadView *headView;
@property (nonatomic,strong) UIButton *intoBtn;
@property (nonatomic,strong) UIButton *withdrawalBtn;
@end

@implementation HSJMyAccountBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    
    [self addSubView];
    [self makeConstraints];
}

- (void)addSubView {
    [self.safeAreaView addSubview:self.headView];
    [self.safeAreaView addSubview:self.intoBtn];
    [self.safeAreaView addSubview:self.withdrawalBtn];
}

- (void)makeConstraints {
    
    kWeakSelf
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.safeAreaView).offset(kScrAdaptationW750(18));
        make.right.equalTo(weakSelf.safeAreaView).offset(-kScrAdaptationW750(18));
        make.height.equalTo(@kScrAdaptationH750(355));
    }];
    
    [self.intoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(kScrAdaptationH750(260));
        make.height.equalTo(@kScrAdaptationH750(82));
        make.width.equalTo(@kScrAdaptationW750(650));
        make.centerX.equalTo(weakSelf.safeAreaView);
    }];
    
    [self.withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.intoBtn.mas_bottom).offset(kScrAdaptationH750(50));
        make.height.centerX.width.equalTo(weakSelf.intoBtn);
    }];
}

- (void)intoBtnClick:(UIButton *)sender {
    NSLog(@"转入存钱罐");
    HSJBuyViewController *vc = [HSJBuyViewController new];
    vc.planId = @"1216";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)withdrawalBtnClick:(UIButton *)sender {
    NSLog(@"提现至银行卡");
    HxbWithdrawViewController *withdrawViewController = [[HxbWithdrawViewController alloc]init];
    [self.navigationController pushViewController:withdrawViewController animated:YES];
}

- (UIButton *)intoBtn {
    if (!_intoBtn) {
        _intoBtn = [UIButton new];
        [_intoBtn addTarget:self action:@selector(intoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_intoBtn setBackgroundColor:RGB(255, 112, 85)];
        [_intoBtn setTitle:@"转入存钱罐" forState:UIControlStateNormal];
        [_intoBtn setTitleColor:kHXBColor_FFFFFF_100 forState:UIControlStateNormal];
        [_intoBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR_750(32)];
        _intoBtn.layer.cornerRadius = 3.0f;
        _intoBtn.layer.masksToBounds = YES;
    }
    return _intoBtn;
}

- (UIButton *)withdrawalBtn {
    if (!_withdrawalBtn) {
        _withdrawalBtn = [UIButton new];
        [_withdrawalBtn addTarget:self action:@selector(withdrawalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_withdrawalBtn setBackgroundColor:kHXBColor_FFFFFF_100];
        [_withdrawalBtn setTitle:@"提现至银行卡" forState:UIControlStateNormal];
        [_withdrawalBtn setTitleColor:RGB(255, 112, 85) forState:UIControlStateNormal];
        [_withdrawalBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR_750(32)];
        _withdrawalBtn.layer.cornerRadius = 3.0f;
        _withdrawalBtn.layer.masksToBounds = YES;
        _withdrawalBtn.layer.borderWidth = 1.0f;
        _withdrawalBtn.layer.borderColor = RGB(255, 112, 85).CGColor;
    }
    return _withdrawalBtn;
}
- (HSJMyAccountBalanceHeadView *)headView {
    if (!_headView) {
        _headView = [HSJMyAccountBalanceHeadView new];
        _headView.userInfoModel = self.userInfoModel;
    }
    return _headView;
}

@end
