//
//  HSJHomeFooterView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//
#define kLogoHeight kScrAdaptationW(51)
#import "HSJHomeFooterView.h"
#import "HSJUserAmountView.h"
#import "HXBUpAndDownLayoutView.h"
#import "HSJBottomPromptView.h"
@interface HSJHomeFooterView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *segmentLineView;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) HSJUserAmountView *platformAmountView;

@property (nonatomic, strong) HSJUserAmountView *userAmountView;

@property (nonatomic, strong) HXBUpAndDownLayoutView *bankView;

@property (nonatomic, strong) HXBUpAndDownLayoutView *creditView;

@property (nonatomic, strong) HXBUpAndDownLayoutView *registeredCapitalView;

@property (nonatomic, strong) HSJBottomPromptView *bottomPromptView;

@end


@implementation HSJHomeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FFFFFF_100;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.segmentLineView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.platformAmountView];
    [self addSubview:self.userAmountView];
    [self addSubview:self.bankView];
    [self addSubview:self.creditView];
    [self addSubview:self.registeredCapitalView];
    [self addSubview:self.bottomPromptView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.top.equalTo(self).offset(kScrAdaptationH750(40));
        make.height.offset(kScrAdaptationH750(48));
    }];
    [self.segmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(kScrAdaptationW750(16));
        make.centerY.equalTo(self.titleLabel);
        make.height.offset(kScrAdaptationH750(21));
        make.width.offset(kHXBDivisionLineHeight);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLineView).offset(kScrAdaptationW750(16));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.platformAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self.mas_centerX).offset(-kScrAdaptationW750(10));
        make.height.offset(kScrAdaptationW750(178));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationW750(38));
    }];
    [self.userAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.left.equalTo(self.mas_centerX).offset(kScrAdaptationW750(10));
        make.height.offset(kScrAdaptationH750(178));
        make.centerY.equalTo(self.platformAmountView);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.height.offset(kLogoHeight);
        make.top.equalTo(self.platformAmountView.mas_bottom).offset(kScrAdaptationH750(50));
    }];
    
    [self.creditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.offset(kLogoHeight);
        make.centerY.equalTo(self.bankView);
    }];
    
    [self.registeredCapitalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
        make.height.offset(kLogoHeight);
        make.centerY.equalTo(self.bankView);
    }];
    [self.bottomPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.registeredCapitalView.mas_bottom).offset(kScrAdaptationH750(40));
    }];
}

- (void)setInfoModel:(HSJGlobalInfoModel *)infoModel {
    _infoModel = infoModel;
    [self.platformAmountView setAmountText:infoModel.financePlanSumAmountText andWithAmountTextUnit:infoModel.financePlanSumAmountTextUnit];
    [self.userAmountView setAmountText:infoModel.financePlanEarnInterestText andWithAmountTextUnit:infoModel.financePlanEarnInterestTextUnit];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(34);
        _titleLabel.textColor = kHXBFontColor_333333_100;
        _titleLabel.text = @"安全保障";
    }
    return _titleLabel;
}

- (UIView *)segmentLineView {
    if (!_segmentLineView) {
        _segmentLineView = [[UIView alloc] init];
        _segmentLineView.backgroundColor = kHXBColor_CBCBCB_100;
    }
    return _segmentLineView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _messageLabel.textColor = kHXBColor_7F85A1_100;
        _messageLabel.text = @"10万妈妈的智慧选择";
    }
    return _messageLabel;
}

- (HSJUserAmountView *)platformAmountView {
    if (!_platformAmountView) {
        _platformAmountView = [[HSJUserAmountView alloc] init];
        _platformAmountView.backgroundColor = kHXBColor_FCF7F6_100;
        _platformAmountView.describeStr = @"累计成交金额";
        kWeakSelf
        _platformAmountView.viewClickBlock = ^{
            if (weakSelf.platformAmountClickBlock) {
                weakSelf.platformAmountClickBlock();
            }
        };
    }
    return _platformAmountView;
}

- (HSJUserAmountView *)userAmountView {
    if (!_userAmountView) {
        _userAmountView = [[HSJUserAmountView alloc] init];
        _userAmountView.backgroundColor = kHXBColor_F5F7FF_100;
        _userAmountView.describeStr = @"累计为用户赚取";
        kWeakSelf
        _userAmountView.viewClickBlock = ^{
            if (weakSelf.userAmountClickBlock) {
                weakSelf.userAmountClickBlock();
            }
        };
    }
    return _userAmountView;
}
- (HXBUpAndDownLayoutView *)registeredCapitalView {
    if (!_registeredCapitalView) {
        _registeredCapitalView = [[HXBUpAndDownLayoutView alloc] initWithFrame:CGRectZero];
        _registeredCapitalView.title = @"多重安全保障";
        _registeredCapitalView.imageName = @"home_money";
        kWeakSelf
        _registeredCapitalView.clickActionBlock = ^{
            if (weakSelf.registeredCapitalClickBlock) {
                weakSelf.registeredCapitalClickBlock();
            }
        };
    }
    return _registeredCapitalView;
}

- (HXBUpAndDownLayoutView *)creditView {
    if (!_creditView) {
        _creditView = [[HXBUpAndDownLayoutView alloc] initWithFrame:CGRectZero];
        _creditView.title = @"AAA信用评级";
        _creditView.imageName = @"home_AAA";
        kWeakSelf
        _creditView.clickActionBlock = ^{
            if (weakSelf.creditClickBlock) {
                weakSelf.creditClickBlock();
            }
        };
    }
    return _creditView;
}

- (HXBUpAndDownLayoutView *)bankView {
    if (!_bankView) {
        _bankView = [[HXBUpAndDownLayoutView alloc] initWithFrame:CGRectZero];
        _bankView.title = @"恒丰银行存管";
        _bankView.imageName = @"home_bank";
        kWeakSelf
        _bankView.clickActionBlock = ^{
            if (weakSelf.bankClickBlock) {
                weakSelf.bankClickBlock();
            }
        };
    }
    return _bankView;
}

- (HSJBottomPromptView *)bottomPromptView {
    if (!_bottomPromptView) {
        _bottomPromptView = [[HSJBottomPromptView alloc] init];
    }
    return _bottomPromptView;
}

@end
