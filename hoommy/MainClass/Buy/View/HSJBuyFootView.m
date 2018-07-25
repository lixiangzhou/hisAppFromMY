//
//  HSJBuyFootView.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyFootView.h"
#import "HXBAgreementView.h"

@interface HSJBuyFootView()
//风险接受协议视图
@property (nonatomic, strong) HXBAgreementView *riskApplyAgreementView;
//协议组视图
@property (nonatomic, strong) HXBAgreementView *agreementGroupView;
@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation HSJBuyFootView

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
    [self addSubview:self.riskApplyAgreementView];
    [self addSubview:self.agreementGroupView];
    [self addSubview:self.actionBtn];
}

-(void)setupConstraints {
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(kScrAdaptationH(41));
    }];
    
    [self.agreementGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.actionBtn.mas_top).mas_offset(-kScrAdaptationH(14.5));
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(kScrAdaptationH(17));
    }];
    
    [self.riskApplyAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreementGroupView.mas_top).mas_offset(-kScrAdaptationH(3.5));
        make.left.equalTo(self).offset(kScrAdaptationW(15));
        make.right.equalTo(self).offset(-kScrAdaptationW(15));
        make.height.mas_equalTo(kScrAdaptationH(17));
    }];
}

- (HXBAgreementView *)riskApplyAgreementView {
    if (!_riskApplyAgreementView) {
        _riskApplyAgreementView = [[HXBAgreementView alloc] initWithFrame:CGRectZero];
        
        NSString *tempStr = @"我同意超出个人风险承受能力的金额";
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:tempStr];
        
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:kHXBFontColor_9295A2_100, NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)};
        NSMutableAttributedString *attributedString = [HXBAgreementView configureLinkAttributedString:attString withString:tempStr sameStringEnable:NO linkAttributes:linkAttributes activeLinkAttributes:linkAttributes parameter:nil clickLinkBlock:^{
            
        }];
        kWeakSelf
        _riskApplyAgreementView.text = attributedString;
        _riskApplyAgreementView.agreeBtnBlock = ^(BOOL isSelected){
            weakSelf.isAgreeRiskApplyAgreement = isSelected;
        };
    }
    return _riskApplyAgreementView;
}

- (HXBAgreementView *)agreementGroupView {
    if (!_agreementGroupView) {
        _agreementGroupView = [[HXBAgreementView alloc] initWithFrame:CGRectZero];
        
        kWeakSelf
        NSString *tempStr = @"我已阅读并同意协议    ";
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:tempStr];
        NSDictionary *defaultAttributes = @{NSForegroundColorAttributeName:kHXBFontColor_9295A2_100, NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)};
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:kHXBColor_73ADFF_100, NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)};
        NSMutableAttributedString *attributedString = [HXBAgreementView configureLinkAttributedString:attString withDefaultAttributes:defaultAttributes withString:@"协议    " sameStringEnable:NO linkAttributes:linkAttributes activeLinkAttributes:linkAttributes  parameter:nil clickLinkBlock:^{
            if(weakSelf.lookUpAgreement) {
                weakSelf.lookUpAgreement();
            }
        }];
        _agreementGroupView.text = attributedString;
        _agreementGroupView.agreeBtnBlock = ^(BOOL isSelected){
            weakSelf.isAgreementGroup = isSelected;
        };
    }
    return _agreementGroupView;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.layer.cornerRadius = kScrAdaptationW(2);
        _actionBtn.titleLabel.font = kHXBFont_32;
        [_actionBtn addTarget:self action:@selector(buttonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

- (void)buttonClickAct:(UIButton*)button {
    if(self.addAction) {
        self.addAction();
    }
}

#pragma mark 属性设置

- (void)setIsAgreementGroup:(BOOL)isAgreementGroup {
    _isAgreementGroup = isAgreementGroup;
    
    self.agreementGroupView.selectState = isAgreementGroup;
}

- (void)setIsAgreeRiskApplyAgreement:(BOOL)isAgreeRiskApplyAgreement {
    _isAgreeRiskApplyAgreement = isAgreeRiskApplyAgreement;
    
    self.riskApplyAgreementView.selectState = isAgreeRiskApplyAgreement;
}

- (void)setIsTransparentBtnColor:(BOOL)isTransparentBtnColor {
    _isTransparentBtnColor = isTransparentBtnColor;
    
    if(isTransparentBtnColor) {
       _actionBtn.backgroundColor = kHXBColor_FF7055_40;
    }
    else {
        _actionBtn.backgroundColor = kHXBColor_FF7055_100;
    }
}

- (void)setBtnContent:(NSString *)btnContent {
    _btnContent = btnContent;
    
    [self.actionBtn setTitle:btnContent forState:UIControlStateNormal];
}

- (void)setIsShowAgreeRiskApplyAgreementView:(BOOL)isShowAgreeRiskApplyAgreementView {
    if(_isShowAgreeRiskApplyAgreementView != isShowAgreeRiskApplyAgreementView) {
        self.isAgreeRiskApplyAgreement = NO;
        _isShowAgreeRiskApplyAgreementView = isShowAgreeRiskApplyAgreementView;
    }
    
    self.riskApplyAgreementView.hidden = !isShowAgreeRiskApplyAgreementView;
}

- (void)setEnableAddButton:(BOOL)enableAddButton {
    _enableAddButton = enableAddButton;
    
    self.actionBtn.enabled = enableAddButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
