//
//  HSJFinAddRecortdCell.m
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJFinAddRecortdCell.h"

NSString * const HSJFinAddRecortdCellIdentifier = @"HSJFinAddRecortdCellIdentifier";

@interface HSJFinAddRecortdCell ()

@property (nonatomic, strong) UILabel *leftAccountLabel;
@property (nonatomic, strong) UILabel *leftAccountTitleLabel;
@property (nonatomic, strong) UILabel *loanIdLabel;
@property (nonatomic, strong) UIButton *contractButton;
@property (nonatomic, strong) UILabel *lendTimeLabel;
@property (nonatomic, strong) UIImageView *stateImgV;
@end

@implementation HSJFinAddRecortdCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kHXBColor_FFFFFF_100;
    [self.contentView addSubview:bgView];
    [self.contentView addSubview:self.leftAccountLabel];
    [self.contentView addSubview:self.leftAccountTitleLabel];
    [self.contentView addSubview:self.loanIdLabel];
    [self.contentView addSubview:self.contractButton];
    [self.contentView addSubview:self.lendTimeLabel];
    [self.contentView addSubview:self.stateImgV];
    
    kWeakSelf
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(kScrAdaptationW750(20));
        make.right.equalTo(weakSelf.contentView).offset(kScrAdaptationW750(-20));
    }];
    [self.leftAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationH750(44));
        make.left.equalTo(@kScrAdaptationW750(30));
        make.height.equalTo(@kScrAdaptationH750(30));
    }];
    [self.leftAccountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftAccountLabel.mas_bottom).offset(kScrAdaptationH750(14));
        make.left.equalTo(weakSelf.leftAccountLabel);
        make.height.equalTo(@kScrAdaptationH750(24));
    }];
    [self.loanIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationH750(46));
        make.left.equalTo(weakSelf.leftAccountLabel.mas_right).offset(kScrAdaptationW750(10));
        make.height.equalTo(@kScrAdaptationH750(24));
    }];
    [self.contractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kScrAdaptationH750(44));
        make.height.equalTo(@kScrAdaptationH750(28));
        make.left.equalTo(weakSelf.loanIdLabel.mas_right).offset(kScrAdaptationW750(20));
        make.right.equalTo(bgView.mas_right).offset(kScrAdaptationW750(-180));
        make.width.equalTo(@kScrAdaptationW750(60));//@45
    }];
    [self.lendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.leftAccountTitleLabel);
        make.left.equalTo(weakSelf.loanIdLabel);
        make.right.equalTo(@kScrAdaptationW750(-187));//@45
    }];
    [self.stateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(bgView);
        make.width.equalTo(@kScrAdaptationW750(106));
        make.height.equalTo(@kScrAdaptationH750(88));
    }];
}

- (void)statusAction {
    if (self.statusActionBlock) {
        self.statusActionBlock(self.model);
    }
}

- (void)setModel:(HSJFinAddRecortdModel *)model {
    _model = model;
    self.leftAccountLabel.text = [NSString GetPerMilWithDouble:self.model.amount.floatValue];
    
    NSString *loanIdLabelTitle = @"标的ID：";
    self.loanIdLabel.attributedText = [NSAttributedString setupAttributeStringWithBeforeString:loanIdLabelTitle  WithBeforeRange:NSMakeRange(0, loanIdLabelTitle.length) andAttributeColor:RGB(146, 149, 162) andAttributeFont:kHXBFont_24 afterString:model.loanId WithAfterRange:NSMakeRange(0, model.loanId.length) andAttributeColor:RGB(21, 21, 21) andAttributeFont:kHXBFont_24];
    
    NSString *lendTimeLabelTitle = @"出借时间：";
    NSString *time = [[HXBBaseHandDate sharedHandleDate] millisecond_StringFromDate:self.model.lendTime andDateFormat:@"yyyy-MM-dd"];;
    self.lendTimeLabel.attributedText = [NSAttributedString setupAttributeStringWithBeforeString:lendTimeLabelTitle  WithBeforeRange:NSMakeRange(0, lendTimeLabelTitle.length) andAttributeColor:RGB(146, 149, 162) andAttributeFont:kHXBFont_24 afterString:time WithAfterRange:NSMakeRange(0, time.length) andAttributeColor:RGB(21, 21, 21) andAttributeFont:kHXBFont_24];
    
    self.stateImgV.image = [UIImage imageNamed:self.model.status];
}


- (UILabel *)leftAccountLabel {
    if (!_leftAccountLabel) {
        _leftAccountLabel = [UILabel new];
        _leftAccountLabel.textColor = kHXBColor_FF7055_100;
        _leftAccountLabel.font = kHXBFont_30;
        _leftAccountLabel.text = @"0.00元";
    }
    return _leftAccountLabel;
}
- (UILabel *)leftAccountTitleLabel {
    if (!_leftAccountTitleLabel) {
        _leftAccountTitleLabel = [UILabel new];
        _leftAccountTitleLabel.textColor = RGB(146, 149, 162);
        _leftAccountTitleLabel.font = kHXBFont_24;
        _leftAccountTitleLabel.text = @"出借金额";
    }
    return _leftAccountTitleLabel;
}
- (UILabel *)loanIdLabel {
    if (!_loanIdLabel) {
        _loanIdLabel = [UILabel new];
        _loanIdLabel.textColor = RGB(146, 149, 162);
        _loanIdLabel.font = kHXBFont_24;
    }
    return _loanIdLabel;
}
- (UIButton *)contractButton {
    if (!_contractButton) {
        _contractButton = [[UIButton alloc] init];
        _contractButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contractButton addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
        [_contractButton setTitle:@"合同" forState:UIControlStateNormal];
        [_contractButton setTitleColor:RGB(106, 125, 254) forState:UIControlStateNormal];
        [_contractButton.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR_750(20)];
        _contractButton.layer.borderWidth = 1.0f;
        _contractButton.layer.borderColor = RGB(106, 125, 254).CGColor;
        _contractButton.layer.cornerRadius = 3.0f;
        _contractButton.layer.masksToBounds = YES;
    }
    return _contractButton;
}
- (UILabel *)lendTimeLabel {
    if (!_lendTimeLabel) {
        _lendTimeLabel = [UILabel new];
        _lendTimeLabel.textColor = RGB(146, 149, 162);;
        _lendTimeLabel.font = kHXBFont_24;
    }
    return _lendTimeLabel;
}
- (UIImageView *)stateImgV {
    if (!_stateImgV) {
        _stateImgV = [UIImageView new];
    }
    return _stateImgV;
}






@end
