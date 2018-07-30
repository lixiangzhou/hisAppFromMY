//
//  HSJRollOutConfirmController.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutConfirmController.h"
#import "HSJRollOutConfirmViewModel.h"
#import "NSString+HxbPerMilMoney.h"
#import "HXBVerificationCodeAlertVC.h"
#import "HXBCommonResultController.h"

@interface HSJRollOutConfirmController ()
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, strong) HSJRollOutConfirmViewModel *viewModel;
@end

@implementation HSJRollOutConfirmController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转出到账户余额";
    self.viewModel = [HSJRollOutConfirmViewModel new];
    [self setUI];
    [self getData];
}

#pragma mark - UI

- (void)setUI {
    [self setupTopView];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = @"预计转出金额：0.00元";
    moneyLabel.font = kHXBFont_30;
    moneyLabel.textColor = kHXBColor_333333_100;
    [self.safeAreaView addSubview:moneyLabel];
    
    UILabel *moneyDescLabel = [UILabel new];
    moneyDescLabel.text = @"资金将转出到您的恒丰银行存管账户中，预计需要1-2天";
    moneyDescLabel.font = kHXBFont_24;
    moneyDescLabel.textColor = kHXBColor_999999_100;
    [self.safeAreaView addSubview:moneyDescLabel];
    
    UIButton *rollOutBtn = [UIButton new];
    [rollOutBtn setTitle:@"确认转出" forState:UIControlStateNormal];
    [rollOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rollOutBtn.backgroundColor = kHXBColor_FF7055_100;
    rollOutBtn.titleLabel.font = kHXBFont_32;
    rollOutBtn.layer.cornerRadius = 2;
    rollOutBtn.layer.masksToBounds = YES;
    [rollOutBtn addTarget:self action:@selector(rollOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.safeAreaView addSubview:rollOutBtn];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:@"暂不转出" forState:UIControlStateNormal];
    [backBtn setTitleColor:kHXBColor_FF7055_100 forState:UIControlStateNormal];
    backBtn.titleLabel.font = kHXBFont_32;
    backBtn.layer.cornerRadius = 2;
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.borderColor = kHXBColor_FF7055_100.CGColor;
    backBtn.layer.borderWidth = 1;
    [backBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.safeAreaView addSubview:backBtn];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kScrAdaptationW(75));
        make.centerX.equalTo(self.safeAreaView);
    }];
    
    [moneyDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(10);
        make.centerX.equalTo(moneyLabel);
    }];
    
    [rollOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.right.equalTo(@kScrAdaptationW(-15));
        make.height.equalTo(@kScrAdaptationW(41));
        make.top.equalTo(moneyDescLabel.mas_bottom).offset(kScrAdaptationW(75));
    }];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(rollOutBtn);
        make.top.equalTo(rollOutBtn.mas_bottom).offset(kScrAdaptationW(30));
    }];
}

- (void)setupTopView {
    UIView *topView = [UIView new];
    [self.safeAreaView addSubview:topView];
    self.topView = topView;
    
    UIImageView *leftImageView = [UIImageView new];
    leftImageView.image = [UIImage imageNamed:@"account_plan_quit_confirm_money"];
    [topView addSubview:leftImageView];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = @"存钱罐";
    leftLabel.textColor = kHXBColor_666666_100;
    leftLabel.font = kHXBFont_24;
    [topView addSubview:leftLabel];
    
    UIImageView *centerImageView = [UIImageView new];
    centerImageView.image = [UIImage imageNamed:@"account_plan_quit_confirm_arrow"];
    [topView addSubview:centerImageView];
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = [UIImage imageNamed:@"account_plan_quit_confirm_bank"];
    [topView addSubview:rightImageView];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"恒丰银行存管";
    rightLabel.textColor = kHXBColor_666666_100;
    rightLabel.font = kHXBFont_24;
    [topView addSubview:rightLabel];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationW(55));
        make.left.right.equalTo(self.safeAreaView);
    }];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView);
    }];
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftImageView);
        make.left.equalTo(leftImageView.mas_right).offset(kScrAdaptationW(28));
        make.centerX.equalTo(topView);
    }];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(leftImageView);
        make.left.equalTo(centerImageView.mas_right).offset(kScrAdaptationW(28));
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageView.mas_bottom).offset(kScrAdaptationW(6));
        make.centerX.equalTo(leftImageView);
        make.bottom.equalTo(topView);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel);
        make.centerX.equalTo(rightImageView);
    }];
}

#pragma mark - Network
- (void)getData {
    kWeakSelf
    [self.viewModel quitConfrim:self.ids resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"预计转出金额：%@元", weakSelf.viewModel.amountAndTotalEarnInterest];
        }
    }];
}

#pragma mark - Action
- (void)rollOutAction {
    kWeakSelf
    [self.viewModel sendSms:^(BOOL isSuccess) {
        if (isSuccess) {
            HXBVerificationCodeAlertVC *alertVC = [[HXBVerificationCodeAlertVC alloc] init];
            alertVC.messageTitle = @"短信验证码";
            alertVC.subTitle = [NSString stringWithFormat:@"已发送到手机号%@，请注意查收", [KeyChain.mobile replaceStringWithStartLocation:3 lenght:4]];
            __weak HXBVerificationCodeAlertVC *weakVC = alertVC;
            alertVC.sureBtnClick = ^(NSString *pwd) {
                [weakSelf.viewModel quit:weakSelf.ids smsCode:pwd resultBlock:^(BOOL isSuccess) {
                    [weakSelf processResult:isSuccess];
                }];
                [weakVC dismissViewControllerAnimated:YES completion:nil];
            };
            [weakSelf presentViewController:alertVC animated:NO completion:nil];
        }
    }];
    
}

#pragma mark - Helper
- (void)processResult:(BOOL)isSuccess {
    HXBCommonResultController *VC = [[HXBCommonResultController alloc] init];
    kWeakSelf
    if (isSuccess) {
        HXBCommonResultContentModel *contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_success" titleString:@"转出成功" descString:[NSString stringWithFormat:@"预计转出金额：%@元", self.viewModel.amountAndTotalEarnInterest] firstBtnTitle:@"完成"];
        contentModel.btnDescString = @"资金转出到您的恒丰银行账户大致需要1-2天";
        contentModel.btnDescHasMark = YES;
        VC.contentModel = contentModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshAccountPlanList object:nil];
    } else {
        HXBCommonResultContentModel *contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_success" titleString:@"转出失败" descString:@"转出过程中出现异常，请重新发起转出" firstBtnTitle:@"重新转出"];
        VC.contentModel = contentModel;
    }
    VC.contentModel.firstBtnBlock = ^(HXBCommonResultController *resultController) {
        [weakSelf popToViewControllerWithClassName:@"HSJRollOutController"];
    };
    VC.contentModel.navBackBlock = ^(HXBCommonResultController *resultController) {
        [weakSelf popToViewControllerWithClassName:@"HSJRollOutController"];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}

@end
