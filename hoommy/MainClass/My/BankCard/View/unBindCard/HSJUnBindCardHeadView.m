//
//  HSJUnBindCardHeadView.m
//  hoommy
//
//  Created by caihongji on 2018/7/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJUnBindCardHeadView.h"

@interface HSJUnBindCardHeadView()

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *bankName;
@property (nonatomic, strong) UILabel *bankTipLb;

@property (nonatomic, strong) UILabel *topTipLb;

@property (nonatomic, strong) CAGradientLayer *backLayer;
@end

@implementation HSJUnBindCardHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.topTipLb];
    [self addSubview:self.backgroundView];
}

- (void)setupConstraints {
    //self
    [self.topTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScrAdaptationW(10));
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
    }];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTipLb.mas_bottom).offset(kScrAdaptationW(10));
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(kScrAdaptationH(80));
    }];
    
    //backgroundView
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView).offset(kScrAdaptationW(20));
        make.width.height.mas_offset(40);
        make.centerY.equalTo(self.backgroundView);
    }];
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(kScrAdaptationW(20));
    }];
    [self.bankTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(kScrAdaptationW(20));
    }];
}

- (UILabel *)topTipLb {
    if(!_topTipLb) {
        _topTipLb = [[UILabel alloc] init];
        
        _topTipLb.textColor = kHXBFontColor_9295A2_100;
        _topTipLb.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _topTipLb.numberOfLines = 0;
        _topTipLb.text = @"您正在解绑尾号1234的银行卡，解绑后需重新绑定方可进行充值提现操作。";
        _topTipLb.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    return _topTipLb;
}

- (UIView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        
        self.iconView = [[UIImageView alloc] init];
        [_backgroundView addSubview:self.iconView];
        
        self.bankName = [[UILabel alloc] init];
        self.bankName.textColor = [UIColor whiteColor];
        self.bankName.font = kHXBFont_PINGFANGSC_REGULAR(15);
        [_backgroundView addSubview:self.bankName];
        
        self.bankTipLb = [[UILabel alloc] init];
        self.bankTipLb.textColor = [UIColor whiteColor];
        self.bankTipLb.font = kHXBFont_PINGFANGSC_REGULAR(12);
        [_backgroundView addSubview:self.bankTipLb];
    }
    return _backgroundView;
}

- (void)setBankCardModel:(HXBBankCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    
    //
    self.iconView.image = [UIImage imageNamed:self.bankCardModel.bankCode];
    
    NSString* lastNo = [self.bankCardModel.cardId substringFromIndex:self.bankCardModel.cardId.length-4];
    self.bankName.text = [NSString stringWithFormat:@"%@(%@)",self.bankCardModel.bankType, lastNo];
    
    self.bankTipLb.text = self.bankCardModel.quota;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!_backLayer) {
        _backLayer = [HSJCALayerTool gradualChangeColor:kHXBColor_FE7E5E_100 toColor:kHXBColor_FFE6A4_100 cornerRadius:4 layerSize:self.backgroundView.size];
        [self.backgroundView.layer insertSublayer:_backLayer atIndex:0];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
