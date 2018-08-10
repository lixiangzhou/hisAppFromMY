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
#import "HSJMyAccountBalanceViewModel.h"
#import "HSJPlanDetailViewModel.h"
#import "HxbWithdrawCardViewController.h"
#import "HXBMy_Withdraw_notifitionView.h"
#import "HXBWithdrawRecordViewController.h"

@interface HSJMyAccountBalanceController ()
@property (nonatomic,strong) HSJMyAccountBalanceHeadView *headView;
@property (nonatomic, strong) HXBMy_Withdraw_notifitionView *notifitionView;
@property (nonatomic,strong) UIButton *intoBtn;
@property (nonatomic,strong) UIButton *withdrawalBtn;
@property (nonatomic,strong) HSJMyAccountBalanceViewModel *viewModel;
@property (nonatomic,strong) InprocessCountModel *inprocessCountModel;
@end

@implementation HSJMyAccountBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    self.viewModel = [[HSJMyAccountBalanceViewModel alloc] init];
    
    [self addSubView];
    [self makeConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData_userInfo];
}

- (void)loadData_userInfo {
    kWeakSelf
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.viewModel downLoadUserInfo:NO resultBlock:^(id responseData, NSError *erro) {
            if (!erro) {
                weakSelf.viewModel.userInfoModel = responseData;
                weakSelf.headView.userInfoModel = responseData;
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.viewModel accountWithdrawaProcessRequestMethod:NYRequestMethodGet resultBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                weakSelf.inprocessCountModel = weakSelf.viewModel.inprocessCountModel;
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        weakSelf.userInfoModel = weakSelf.viewModel.userInfoModel;
        //界面刷新
        [weakSelf.safeAreaView setNeedsLayout];
    });
}

- (void)addSubView {
    [self.safeAreaView addSubview:self.notifitionView];
    [self.safeAreaView addSubview:self.headView];
    [self.safeAreaView addSubview:self.intoBtn];
    [self.safeAreaView addSubview:self.withdrawalBtn];
}

- (void)makeConstraints {
    
    kWeakSelf
    [self.notifitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.safeAreaView);
        make.top.equalTo(weakSelf.safeAreaView).offset(kScrAdaptationW(5));
        make.height.offset(kScrAdaptationH(36));
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.notifitionView.mas_bottom).offset(kScrAdaptationW(15));
        make.left.equalTo(weakSelf.safeAreaView).offset(kScrAdaptationW750(18));
        make.right.equalTo(weakSelf.safeAreaView).offset(-kScrAdaptationW750(18));
        make.height.equalTo(@kScrAdaptationH750(415));
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

- (void)setInprocessCountModel:(InprocessCountModel *)inprocessCountModel {
    _inprocessCountModel = inprocessCountModel;
    if (inprocessCountModel.inprocessCount > 0) {
        self.notifitionView.hidden = NO;
        
        NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)inprocessCountModel.inprocessCount];
        NSString *str1 = @"您有";
        NSString *str2 = @"条提现申请正在处理，";
        NSString *str3 = @"点击查看";
        NSMutableAttributedString *att = [NSMutableAttributedString new];
        
        NSMutableAttributedString *attr1 = [NSMutableAttributedString setupAttributeStringWithBeforeString:str1 WithBeforeRange:NSMakeRange(0, str1.length) andAttributeColor:RGB(209, 169, 127) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(14) afterString:num WithAfterRange:NSMakeRange(0, num.length) andAttributeColor:COR29 andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(14)];
        [att appendAttributedString:attr1];
        
        NSMutableAttributedString *attr2 = [NSMutableAttributedString setupAttributeStringWithString:str2 WithRange:NSMakeRange(0, str2.length) andAttributeColor:RGB(209, 169, 127) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(14)];
        [att appendAttributedString:attr2];
        
        NSMutableAttributedString *attr3 = [NSMutableAttributedString setupAttributeStringWithString:str3 WithRange:NSMakeRange(0, str3.length) andAttributeColor:RGB(102, 121, 253) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR(14)];
        [att appendAttributedString:attr3];
        
        self.notifitionView.attributedMessageCount = att;
        [self.notifitionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScrAdaptationH750(70));
        }];
    } else {
        self.notifitionView.hidden = YES;
        [self.notifitionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScrAdaptationH750(0));
        }];
    }
}

- (void)intoBtnClick:(UIButton *)sender {
    NSLog(@"转入存钱罐");
    [HXBUmengManagar HXB_clickEventWithEnevtId: kHSJUmeng_MyIntoPlanClick];
    
    kWeakSelf
    [self.viewModel checkDepositoryAndRiskFromController:self checkBank:YES finishBlock:^{
        HSJBuyViewController *vc = [HSJBuyViewController new];
        vc.planId = [KeyChain firstPlanIdInPlanList];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

//进入提现记录
- (void)pushCashRegisterVC {
    [HXBUmengManagar HXB_clickEventWithEnevtId: kHSJUmeng_MyWithdrawCashRecordClick];
    HXBWithdrawRecordViewController *cashRegisterVC = [[HXBWithdrawRecordViewController alloc] init];
    [self.navigationController pushViewController:cashRegisterVC animated:YES];
}

- (void)withdrawalBtnClick:(UIButton *)sender {
    NSLog(@"提现至银行卡");
    
    [self.viewModel checkDepositoryAndRiskFromController:self checkBank:YES finishBlock:^{
        [HXBUmengManagar HXB_clickEventWithEnevtId: kHSJUmeng_MyWithdrawCashToBankCardClick];
        HxbWithdrawViewController *withdrawViewController = [[HxbWithdrawViewController alloc]init];
        [self.navigationController pushViewController:withdrawViewController animated:YES];
        
    }];
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
- (HXBMy_Withdraw_notifitionView *)notifitionView {
    kWeakSelf
    if (!_notifitionView) {
        _notifitionView = [[HXBMy_Withdraw_notifitionView alloc] initWithFrame:CGRectZero];//CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScrAdaptationH750(70))
        _notifitionView.hidden = YES;
    }
    _notifitionView.block = ^{
        [weakSelf pushCashRegisterVC];
    };
    return _notifitionView;
}
@end
