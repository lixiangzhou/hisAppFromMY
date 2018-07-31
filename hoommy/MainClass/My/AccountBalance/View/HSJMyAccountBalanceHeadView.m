//
//  HSJMyAccountBalanceHeadView.m
//  hoommy
//
//  Created by hxb on 2018/7/20.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyAccountBalanceHeadView.h"
#import "NSAttributedString+HxbAttributedString.h"

@interface HSJMyAccountBalanceHeadView ()
@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *hfLab;
@property (nonatomic,strong) UILabel *balanceLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *userIdLab;
@end

@implementation HSJMyAccountBalanceHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
        kWeakSelf
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)setUserInfoModel:(HXBUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    NSString *yuanStr = @"元";
    NSString *amount = [NSString GetPerMilWithDouble:[self.userInfoModel.userAssets.availablePoint doubleValue]];
    self.balanceLab.attributedText = [NSAttributedString setupAttributeStringWithBeforeString:amount  WithBeforeRange:NSMakeRange(0, amount.length) andAttributeColor:RGB(96, 103, 122) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(76) afterString:yuanStr WithAfterRange:NSMakeRange(0, yuanStr.length) andAttributeColor:RGB(96, 103, 122) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(36)];
    
    self.nameLab.text = [NSString stringWithFormat:@"真实姓名：%@",[self.userInfoModel.userInfo.realName replaceStringWithStartLocation:0 lenght:self.userInfoModel.userInfo.realName.length - 1]];
    
    self.userIdLab.text = [NSString stringWithFormat:@"身份证号：%@",[NSString hiddenStr:self.userInfoModel.userInfo.idNo MidWithFistLenth:1 andLastLenth:1]];;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"AccountBalance_bg"];
        
        kWeakSelf
        [_bgImgView addSubview:self.iconImgView];
        [_bgImgView addSubview:self.hfLab];
        [_bgImgView addSubview:self.balanceLab];
        [_bgImgView addSubview:self.nameLab];
        [_bgImgView addSubview:self.userIdLab];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_bgImgView).offset(kScrAdaptationW750(60));
            make.top.equalTo(self->_bgImgView).offset(kScrAdaptationH750(50));
            make.width.equalTo(@kScrAdaptationW750(50));
            make.height.equalTo(@kScrAdaptationH750(39));
        }];
        
        [self.hfLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImgView.mas_right).offset(kScrAdaptationW750(20));
            make.top.equalTo(self->_bgImgView).offset(kScrAdaptationH750(56));
            make.right.equalTo(self->_bgImgView).offset(kScrAdaptationW750(-15));
            make.height.equalTo(@kScrAdaptationH750(28));
        }];
        
        [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_bgImgView).offset(kScrAdaptationW750(68));
            make.right.equalTo(self->_bgImgView).offset(kScrAdaptationW750(-68));
            make.top.equalTo(weakSelf.hfLab.mas_bottom).offset(kScrAdaptationH750(50));
            make.height.equalTo(@kScrAdaptationH750(88));
        }];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.balanceLab);
            make.top.equalTo(weakSelf.balanceLab.mas_bottom).offset(kScrAdaptationH750(50));
            make.height.equalTo(@kScrAdaptationH750(33));
        }];
        
        [self.userIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab.mas_right).offset(kScrAdaptationW750(60));
            make.top.height.equalTo(weakSelf.nameLab);
            make.right.equalTo(self->_bgImgView).offset(kScrAdaptationW750(-70));
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
        _hfLab.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _hfLab.textColor = RGB(109, 114, 141);
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
        _nameLab.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _nameLab.textColor = RGB(96, 103, 122);
    }
    return _nameLab;
}
- (UILabel *)userIdLab {
    if (!_userIdLab) {
        _userIdLab = [UILabel new];
        _userIdLab.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _userIdLab.textColor = RGB(96, 103, 122);
    }
    return _userIdLab;
}
@end
