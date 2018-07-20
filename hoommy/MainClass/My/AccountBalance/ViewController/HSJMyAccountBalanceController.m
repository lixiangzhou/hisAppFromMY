//
//  HSJMyAccountBalanceController.m
//  hoommy
//
//  Created by hxb on 2018/7/20.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyAccountBalanceController.h"
#import "HSJMyAccountBalanceHeadView.h"

@interface HSJMyAccountBalanceController ()
@property (nonatomic,strong) HSJMyAccountBalanceHeadView *headView;
//@property (nonatomic,strong) UIButton *headView;

@end

@implementation HSJMyAccountBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    
    [self addSubView];
    [self makeConstraints];
}

- (void)addSubView {
    [self.view addSubview:self.headView];
    
    
    
}

- (void)makeConstraints {
    
    kWeakSelf
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view).offset(kScrAdaptationW750(18));
        make.height.equalTo(@kScrAdaptationH750(355));
    }];
    
//    [self.assetsTotalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.accumulatedProfitTitleLabel.mas_right).offset(kScrAdaptationW(85));
//        make.top.equalTo(weakSelf.accumulatedProfitTitleLabel);
//        make.height.equalTo(weakSelf.accumulatedProfitTitleLabel);
//        make.width.equalTo(@kScrAdaptationW(80));
//    }];
    
}

- (HSJMyAccountBalanceHeadView *)headView {
    if (!_headView) {
        _headView = [HSJMyAccountBalanceHeadView new];
        _headView.userInfoModel = self.userInfoModel;
    }
    return _headView;
}

@end
