//
//  HSJHomePlanView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomePlanView.h"

@interface HSJHomePlanView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *segmentLineView;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *planBackgroundImageView;

@property (nonatomic, strong) UILabel *expectedRateLabel;

@property (nonatomic, strong) UILabel *annualizedTextLabel;

@property (nonatomic, strong) UILabel *depositoryLabel;

@property (nonatomic, strong) UILabel *refundableLabel;

@property (nonatomic, strong) UILabel *intoLabel;

@end

@implementation HSJHomePlanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FFFFFF_100;
        [self setupUI];
        [self updateUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.segmentLineView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.planBackgroundImageView];
    [self addSubview:self.expectedRateLabel];
    [self addSubview:self.annualizedTextLabel];
    [self addSubview:self.depositoryLabel];
    [self addSubview:self.refundableLabel];
    [self addSubview:self.intoLabel];
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
    [self.planBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH750(40));
        make.bottom.equalTo(self).offset(-kScrAdaptationH750(50));
    }];
    [self.expectedRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.planBackgroundImageView);
        make.top.equalTo(self.planBackgroundImageView).offset(kScrAdaptationH750(50));
        
    }];
    [self.annualizedTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.expectedRateLabel);
        make.top.equalTo(self.expectedRateLabel.mas_bottom);
    }];
    [self.depositoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.expectedRateLabel.mas_centerX).offset(-kScrAdaptationW750(6));
        make.top.equalTo(self.annualizedTextLabel.mas_bottom).offset(kScrAdaptationH750(30));
        make.height.offset(kScrAdaptationH750(39));
        make.width.offset(kScrAdaptationH750(172));
    }];
    [self.refundableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expectedRateLabel.mas_centerX).offset(kScrAdaptationW750(6));
        make.centerY.equalTo(self.depositoryLabel);
        make.height.offset(kScrAdaptationH750(39));
        make.width.offset(kScrAdaptationH750(172));
    }];
    [self.intoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.expectedRateLabel);
        make.height.offset(kScrAdaptationH750(80));
        make.width.offset(kScrAdaptationW750(280));
        make.bottom.equalTo(self.planBackgroundImageView.mas_bottom).offset(-kScrAdaptationH750(50));
    }];
}

- (void)updateUI {
    if (KeyChain.isLogin) {
        self.planBackgroundImageView.image = [UIImage imageNamed:@"Home_Invest_Plan_Bg"];
        self.intoLabel.hidden = NO;
    } else {
        self.planBackgroundImageView.image = [UIImage imageNamed:@"Home_Signup_Plan_Bg"];
        self.intoLabel.hidden = YES;
    }
}

- (void)setPlanModel:(HSJPlanModel *)planModel {
    _planModel = planModel;
    self.expectedRateLabel.text = [NSString stringWithFormat:@"%@%%",planModel.baseInterestRate];
    self.titleLabel.text = planModel.name;
    self.messageLabel.text = planModel.tag;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(34);
        _titleLabel.textColor = kHXBFontColor_333333_100;
        _titleLabel.text = @"__";
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
        _messageLabel.textColor = kHXBColor_CBCBCB_100;
        _messageLabel.text = @"存取灵活";
    }
    return _messageLabel;
}

- (UIImageView *)planBackgroundImageView {
    if (!_planBackgroundImageView) {
        _planBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Invest_Plan_Bg"]];
    }
    return _planBackgroundImageView;
}

- (UILabel *)expectedRateLabel {
    if (!_expectedRateLabel) {
        _expectedRateLabel = [[UILabel alloc] init];
        _expectedRateLabel.text = @"__";
        _expectedRateLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(100);
        _expectedRateLabel.textColor = kHXBColor_FF7055_100;
    }
    return _expectedRateLabel;
}

- (UILabel *)annualizedTextLabel {
    if (!_annualizedTextLabel) {
        _annualizedTextLabel = [[UILabel alloc] init];
        _annualizedTextLabel.text = @"今日预期年化";
        _annualizedTextLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _annualizedTextLabel.textColor = kHXBColor_7F85A1_100;
    }
    return _annualizedTextLabel;
}

- (UILabel *)depositoryLabel {
    if (!_depositoryLabel) {
        _depositoryLabel = [[UILabel alloc] init];
        _depositoryLabel.text = @"恒丰银行存管";
        _depositoryLabel.textAlignment = NSTextAlignmentCenter;
        _depositoryLabel.textColor = kHXBColor_FB7F67_100;
        _depositoryLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _depositoryLabel.backgroundColor = kHXBColor_FB7F67_10;
    }
    return _depositoryLabel;
}

- (UILabel *)refundableLabel {
    if (!_refundableLabel) {
        _refundableLabel = [[UILabel alloc] init];
        _refundableLabel.text = @"7日后随时可退";
        _refundableLabel.textAlignment = NSTextAlignmentCenter;
        _refundableLabel.textColor = kHXBColor_FB7F67_100;
        _refundableLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _refundableLabel.backgroundColor = kHXBColor_FB7F67_10;
    }
    return _refundableLabel;
}

- (UILabel *)intoLabel {
    if (!_intoLabel) {
        _intoLabel = [[UILabel alloc] init];
        _intoLabel.text = @"转入";
        _intoLabel.textAlignment = NSTextAlignmentCenter;
        _intoLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(32);
        _intoLabel.textColor = kHXBColor_FFFFFF_100;
        _intoLabel.backgroundColor = kHXBColor_FF7055_100;
        _intoLabel.layer.cornerRadius = kScrAdaptationW750(40);
        _intoLabel.layer.masksToBounds = YES;
    }
    return _intoLabel;
}

@end
