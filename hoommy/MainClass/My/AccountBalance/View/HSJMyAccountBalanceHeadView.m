//
//  HSJMyAccountBalanceHeadView.m
//  hoommy
//
//  Created by hxb on 2018/7/20.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyAccountBalanceHeadView.h"

@interface HSJMyAccountBalanceHeadView ()
@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *hfLab;
@property (nonatomic,strong) UILabel *balanceLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *userId;
@end

@implementation HSJMyAccountBalanceHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
    }
    return self;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"AccountBalance_bg"];
        
        kWeakSelf
        [_bgImgView addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(kScrAdaptationW750(60));
            make.top.equalTo(weakSelf).offset(kScrAdaptationH750(50));
            make.width.equalTo(@kScrAdaptationW750(50));
            make.height.equalTo(@kScrAdaptationH750(39));
        }];
        
        [_bgImgView addSubview:self.hfLab];
        [self.hfLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImgView.mas_right).offset(kScrAdaptationW750(20));
            make.top.equalTo(weakSelf).offset(kScrAdaptationH750(56));
            make.right.equalTo(weakSelf).offset(kScrAdaptationW750(-15));
            make.height.equalTo(@kScrAdaptationH750(28));
        }];
        
        [_bgImgView addSubview:self.balanceLab];
        [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf).offset(kScrAdaptationW750(68));
            make.top.equalTo(weakSelf.hfLab.mas_bottom).offset(kScrAdaptationH750(50));
            make.height.equalTo(@kScrAdaptationH750(88));
        }];
        
        [_bgImgView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.balanceLab);
            make.top.equalTo(weakSelf.balanceLab.mas_bottom).offset(kScrAdaptationH750(50));
            make.height.equalTo(@kScrAdaptationH750(33));
        }];
        
        [_bgImgView addSubview:self.userId];
        [self.userId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab.mas_right).offset(kScrAdaptationW750(60));
            make.top.height.equalTo(weakSelf.nameLab);
            make.right.equalTo(weakSelf).offset(kScrAdaptationW750(70));
        }];
    }
    return _bgImgView;
}
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"AccountBalance_hf"];
    }
    return _iconImgView;
}
- (UILabel *)hfLab {
    if (!_hfLab) {
        _hfLab = [UILabel new];
        _hfLab.text = @"恒丰银行存管账户";
    }
    return _hfLab;
}
- (UILabel *)balanceLab {
    if (!_balanceLab) {
        _balanceLab = [UILabel new];
        
    }
    return _balanceLab;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        
    }
    return _nameLab;
}
- (UILabel *)userId {
    if (!_userId) {
        _userId = [UILabel new];
        
    }
    return _userId;
}
@end
