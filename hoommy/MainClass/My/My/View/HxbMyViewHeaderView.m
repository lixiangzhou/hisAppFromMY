//
//  HxbMyViewHeaderView.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/4.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbMyViewHeaderView.h"
#import "HXBRootVCManager.h"
@interface HxbMyViewHeaderView ()

@property (nonatomic, strong) UIButton *personalCenterButton;//个人中心
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *transactionBtn; ///交易记录
@property (nonatomic, strong) UIImageView *headTopView;

@property (nonatomic, strong) UIImageView *accountOpeningBackgroundImage;  ///背景图片 已开户
@property (nonatomic, strong) UIImageView *noAccountOpeningBackgroundImage;  ///背景图片 未开户
@property (nonatomic, strong) UILabel *yesterdayInterestLabel;   /// 昨日收益
@property (nonatomic, strong) UIButton *securyButton;//加密
@property (nonatomic, strong) UILabel *yesterdayInterestTitleLabel; ///昨日收益
@property (nonatomic, strong) UILabel *accumulatedProfitTitleLabel;
@property (nonatomic, strong) UILabel *accumulatedProfitLabel;//累计收益
@property (nonatomic, strong) UILabel *assetsTotalTitleLabel;  /// 资产总额
@property (nonatomic, strong) UILabel *assetsTotalLabel;       /// 资产总额
@property (nonatomic, strong) UILabel *balanceTitleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;//可用余额

@property (nonatomic, strong) UIButton *topupButton;
@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic,copy) void(^clickAllFinanceButtonBlock)(UILabel *button);

@end


@implementation HxbMyViewHeaderView

- (void)clickAllFinanceButtonWithBlock: (void(^)(UILabel *button))clickAllFinanceButtonBlock {
    self.clickAllFinanceButtonBlock = clickAllFinanceButtonBlock;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COR15;
        [self addSubview:self.headTopView];
        
        [self addSubview:self.accountOpeningBackgroundImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAllFinanceButton:)];
        [self.noAccountOpeningBackgroundImage addGestureRecognizer:tap];
        [self.accountOpeningBackgroundImage addGestureRecognizer:tap];

        [self.accountOpeningBackgroundImage addSubview:self.yesterdayInterestTitleLabel];//昨日收益
        [self.accountOpeningBackgroundImage addSubview:self.yesterdayInterestLabel];
        [self.accountOpeningBackgroundImage addSubview:self.securyButton];
        [self.accountOpeningBackgroundImage addSubview:self.accumulatedProfitTitleLabel];///累计收益
        [self.accountOpeningBackgroundImage addSubview:self.accumulatedProfitLabel];
        [self.accountOpeningBackgroundImage addSubview:self.assetsTotalTitleLabel];///资产总额
        [self.accountOpeningBackgroundImage addSubview:self.assetsTotalLabel];
        [self.accountOpeningBackgroundImage addSubview:self.noAccountOpeningBackgroundImage];
        [self setupSubViewFrame];
        
        self.noAccountOpeningBackgroundImage.hidden = YES;
        self.accountOpeningBackgroundImage.hidden = NO;
    }
    return self;
}

/**
 设置frame
 */
- (void)setupSubViewFrame
{
    kWeakSelf
    [self.headTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.offset(kScrAdaptationH750(491) + HXBStatusBarAdditionHeight);
    }];
    [self.personalCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headTopView).offset(kScrAdaptationW(15));
        make.top.equalTo(weakSelf.headTopView).offset(kScrAdaptationH750(70)+HXBTabbarSafeBottomMargin);
        make.width.height.equalTo(@kScrAdaptationW750(68));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.personalCenterButton.mas_right).offset(kScrAdaptationW(10));
        make.height.offset(kScrAdaptationH(20));
        make.centerY.equalTo(weakSelf.personalCenterButton);
        make.right.equalTo(weakSelf.headTopView.mas_right).offset(kScrAdaptationW(-15));
    }];
    [self.transactionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kScrAdaptationW750(116));
        make.height.offset(kScrAdaptationH(20));
        make.centerY.equalTo(weakSelf.personalCenterButton);
        make.right.equalTo(weakSelf.headTopView.mas_right).offset(kScrAdaptationW(-15));
    }];
    [self.accountOpeningBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headTopView).offset(kScrAdaptationH750(167)+HXBTabbarSafeBottomMargin);
        make.left.equalTo(weakSelf).offset(kScrAdaptationW750(5));
        make.right.right.equalTo(weakSelf).offset(kScrAdaptationW750(-5));
        make.height.offset(kScrAdaptationH750(440));
    }];
    [self.noAccountOpeningBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW(-4));
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(-5));
        make.bottom.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(15));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(4));
    }];
    [self.assetsTotalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW750(90));
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH750(87));
        make.height.equalTo(@kScrAdaptationH(17));
        make.width.equalTo(@kScrAdaptationW750(160));
    }];
    [self.assetsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) { //zong
        make.left.equalTo(weakSelf.assetsTotalTitleLabel);
        make.top.equalTo(weakSelf.assetsTotalTitleLabel.mas_bottom).offset(kScrAdaptationH750(13));
        make.height.equalTo(@kScrAdaptationH750(82));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW(-15));
    }];
    [self.securyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(27+15));
        make.width.equalTo(@kScrAdaptationW(20));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW750(-50));
        make.height.offset(kScrAdaptationH(12));
    }];
    [self.yesterdayInterestTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.assetsTotalTitleLabel);
        make.width.equalTo(@kScrAdaptationW750(150));
        make.top.equalTo(weakSelf.assetsTotalLabel.mas_bottom).offset(kScrAdaptationH750(44));
        make.height.equalTo(@kScrAdaptationH750(32));
    }];
    [self.yesterdayInterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.yesterdayInterestTitleLabel);
        make.top.equalTo(weakSelf.yesterdayInterestTitleLabel.mas_bottom).offset(kScrAdaptationH750(9));
        make.height.equalTo(@kScrAdaptationH750(47));
    }];
    
    [self.accumulatedProfitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScrAdaptationW750(386));
        make.top.equalTo(weakSelf.yesterdayInterestTitleLabel);
        make.height.equalTo(weakSelf.yesterdayInterestTitleLabel);
        make.width.equalTo(@kScrAdaptationW750(150));
    }];
    [self.accumulatedProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) { //leiji
        make.left.equalTo(weakSelf.accumulatedProfitTitleLabel);
        make.top.equalTo(weakSelf.yesterdayInterestLabel);
        make.height.equalTo(weakSelf.yesterdayInterestLabel);
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage.mas_right).offset(kScrAdaptationW(-15));
    }];
}

- (void)clickAllFinanceButton: (UITapGestureRecognizer *)tap {
    if (self.clickAllFinanceButtonBlock) {
        self.clickAllFinanceButtonBlock((UILabel *)tap.view);
    }
}

- (void)setUserInfoModel:(HXBUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    //    self.accountOpeningBackgroundImage.hidden = NO;
    if (!self.userInfoModel.userInfo.isCreateEscrowAcc) {
        self.noAccountOpeningBackgroundImage.hidden = NO;
    } else {
        self.noAccountOpeningBackgroundImage.hidden = YES;
    }
    
    self.phoneLabel.text = [_userInfoModel.userInfo.mobile hxb_hiddenPhonNumberWithMid];
    NSString *accumulatedProfitStr = userInfoModel.userAssets.earnTotal? [NSString hsj_simpleMoneyValue:[userInfoModel.userAssets.earnTotal doubleValue]]: @"0.00";
    NSString *balance = userInfoModel.userAssets.availablePoint ? [NSString hsj_simpleMoneyValue:[userInfoModel.userAssets.availablePoint doubleValue]] : @"0.00";
    NSString *yesterdayInterest = [NSString hsj_simpleMoneyValue:userInfoModel.userAssets.yesterdayInterest];
    NSString *assetsTotal = [NSString hsj_simpleMoneyValue:[userInfoModel.userAssets.assetsTotal doubleValue]];
    if ([KeyChain.ciphertext isEqualToString:@"0"]) {
        self.securyButton.selected = NO;
        self.yesterdayInterestLabel.text = [yesterdayInterest isEqualToString:@"0"]?@"0.00":yesterdayInterest;
        self.accumulatedProfitLabel.text = [accumulatedProfitStr isEqualToString:@"0"]?@"0.00":accumulatedProfitStr;
        self.balanceLabel.text = [balance isEqualToString:@"0"]?@"0.00":balance;
        self.assetsTotalLabel.text = [assetsTotal isEqualToString:@"0"]?@"0.00":assetsTotal;
    } else {
        self.securyButton.selected = YES;
        self.accumulatedProfitLabel.text = kSecuryText;
        self.yesterdayInterestLabel.text = kSecuryText;
        self.balanceLabel.text = kSecuryText;
        self.assetsTotalLabel.text = kSecuryText;
    }
}

- (void)leftHeaderButtonClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(didClickLeftHeadBtn:)]) {
        [self.delegate didClickLeftHeadBtn:sender];
    }
}

- (void)capitalRecordClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCapitalRecordBtn:)]) {
        [self.delegate didClickCapitalRecordBtn:sender];
    }
}

- (void)securyButtonClick:(UIButton *)rightHeadBtn
{
    NSString *accumulatedProfitStr = _userInfoModel.userAssets.earnTotal? [NSString hsj_simpleMoneyValue:[_userInfoModel.userAssets.earnTotal doubleValue]]: @"0.00";
    NSString *balance = _userInfoModel.userAssets.availablePoint ? [NSString hsj_simpleMoneyValue:[_userInfoModel.userAssets.availablePoint doubleValue]] : @"0.00";
    NSString *yesterdayInterest = [NSString hsj_simpleMoneyValue:_userInfoModel.userAssets.yesterdayInterest];
    NSString *assetsTotal = [NSString hsj_simpleMoneyValue:[_userInfoModel.userAssets.assetsTotal doubleValue]];
    
    if ([KeyChain.ciphertext isEqualToString:@"0"]){
        KeyChain.ciphertext = @"1";
        self.securyButton.selected = YES;
        self.accumulatedProfitLabel.text = kSecuryText;
        self.balanceLabel.text = kSecuryText;
        self.yesterdayInterestLabel.text = kSecuryText;
        self.assetsTotalLabel.text = kSecuryText;
    }else
    {
        KeyChain.ciphertext = @"0";
        self.securyButton.selected = NO;
        self.accumulatedProfitLabel.text = [accumulatedProfitStr isEqualToString:@"0"]?@"0.00":accumulatedProfitStr;
        self.balanceLabel.text = [balance isEqualToString:@"0"]?@"0.00":balance;
        self.yesterdayInterestLabel.text = [yesterdayInterest isEqualToString:@"0"]?@"0.00":yesterdayInterest;
        self.assetsTotalLabel.text = [assetsTotal isEqualToString:@"0"]?@"0.00":assetsTotal;
    }
}


- (void)topupButtonClick:(id)sender{
    kWeakSelf
    UIButton *tmpBtn = nil;
    if (!sender||sender!=_topupButton) {
        tmpBtn = weakSelf.topupButton;
    }else{
        tmpBtn = (UIButton *)sender;
    }
    if ([self.delegate respondsToSelector:@selector(didClickTopUpBtn:)]) {
        [self.delegate didClickTopUpBtn:tmpBtn];
    }
}

- (void)withdrawButtonClick:(id)sender{
    kWeakSelf
    UIButton *tmpBtn = nil;
    if (!sender||sender!=_withdrawButton) {
        tmpBtn = weakSelf.withdrawButton;
    }else{
        tmpBtn = (UIButton *)sender;
    }
    if ([self.delegate respondsToSelector:@selector(didClickWithdrawBtn:)]) {
        [self.delegate didClickWithdrawBtn:tmpBtn];
    }
}

#pragma mark - 懒加载

- (UIImageView *)headTopView {
    if (!_headTopView) {
        _headTopView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headTopView.userInteractionEnabled = YES;
        if (HXBIPhoneX) {
            _headTopView.image = [UIImage imageNamed:@"my_top_bg_iphonex"];
        } else {
            _headTopView.image = [UIImage imageNamed:@"my_top_bg"];
        }
        [_headTopView addSubview:self.personalCenterButton];
        [_headTopView addSubview:self.phoneLabel];
        [_headTopView addSubview:self.transactionBtn];
    }
    return _headTopView;
}

- (UIButton *)transactionBtn {
    if (!_transactionBtn) {
        _transactionBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_transactionBtn addTarget:self action:@selector(capitalRecordClick:) forControlEvents:UIControlEventTouchUpInside];
        _transactionBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_transactionBtn setTitle:@"交易记录" forState:UIControlStateNormal];
        _transactionBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _transactionBtn.titleLabel.textColor = kHXBColor_FFFFFF_100;
    }
    return _transactionBtn;
}

- (UIButton *)personalCenterButton{
    if (!_personalCenterButton) {
        _personalCenterButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_personalCenterButton addTarget:self action:@selector(leftHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_center"]];
        btnImage.contentMode = UIViewContentModeScaleAspectFit;
        [_personalCenterButton addSubview:btnImage];
    }
    return _personalCenterButton;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _phoneLabel.textColor = kHXBColor_FFFFFF_100;
    }
    return _phoneLabel;
}
- (UIImageView *)accountOpeningBackgroundImage
{
    if (!_accountOpeningBackgroundImage) {
        _accountOpeningBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top"]];
        _accountOpeningBackgroundImage.userInteractionEnabled = YES;
    }
    return _accountOpeningBackgroundImage;
}
- (UIImageView *)noAccountOpeningBackgroundImage {
    if (!_noAccountOpeningBackgroundImage) {
        _noAccountOpeningBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_notEscrowAcc"]];
        _noAccountOpeningBackgroundImage.userInteractionEnabled = YES;
//        _noAccountOpeningBackgroundImage.layer.cornerRadius = 3;
//        _noAccountOpeningBackgroundImage.layer.masksToBounds = YES;
    }
    return _noAccountOpeningBackgroundImage;
}
- (UILabel *)yesterdayInterestTitleLabel {
    if (!_yesterdayInterestTitleLabel) {
        _yesterdayInterestTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yesterdayInterestTitleLabel.textAlignment = NSTextAlignmentLeft;
        _yesterdayInterestTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _yesterdayInterestTitleLabel.text = @"昨日收益(元)";
        _yesterdayInterestTitleLabel.textColor = RGB(127, 133, 161);
    }
    return _yesterdayInterestTitleLabel;
}
- (UIButton *)securyButton{
    if (!_securyButton) {
        _securyButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_securyButton setImage:[UIImage imageNamed:@"my_eyes"] forState:UIControlStateNormal];
        [_securyButton setImage:[UIImage imageNamed:@"my_closedEyes"] forState:UIControlStateSelected];
        [_securyButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        _securyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_securyButton addTarget:self action:@selector(securyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _securyButton;
}
-(UILabel *)yesterdayInterestLabel {
    if (!_yesterdayInterestLabel) {
        _yesterdayInterestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yesterdayInterestLabel.textAlignment = NSTextAlignmentLeft;
        _yesterdayInterestLabel.font = kHXBFont_DINAlternate_BOLD_750(40);
        _yesterdayInterestLabel.textColor = kHXBColor_333333_100;
        _yesterdayInterestLabel.text = @"0.00";
    }
    return _yesterdayInterestLabel;
}
-(UILabel *)accumulatedProfitTitleLabel {
    if (!_accumulatedProfitTitleLabel) {
        _accumulatedProfitTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _accumulatedProfitTitleLabel.text = @"累计收益(元)";
        _accumulatedProfitTitleLabel.textAlignment = NSTextAlignmentLeft;
        _accumulatedProfitTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(13);
        _accumulatedProfitTitleLabel.textColor = RGB(127, 133, 161);
    }
    return _accumulatedProfitTitleLabel;
}
- (UILabel *)accumulatedProfitLabel{
    if (!_accumulatedProfitLabel) {
        _accumulatedProfitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _accumulatedProfitLabel.text = @"0.00";
        _accumulatedProfitLabel.textAlignment = NSTextAlignmentLeft;
        _accumulatedProfitLabel.font = kHXBFont_DINAlternate_BOLD_750(40);
        _accumulatedProfitLabel.textColor = kHXBColor_333333_100;
    }
    return _accumulatedProfitLabel;
}
- (UILabel *)assetsTotalTitleLabel {
    if (!_assetsTotalTitleLabel) {
        _assetsTotalTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _assetsTotalTitleLabel.text = @"资产总额(元)";
        _assetsTotalTitleLabel.textAlignment = NSTextAlignmentLeft;
        _assetsTotalTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(13);
        _assetsTotalTitleLabel.textColor = RGB(127, 133, 161);
    }
    return _assetsTotalTitleLabel;
}
-(UILabel *)assetsTotalLabel{
    if (!_assetsTotalLabel) {
        _assetsTotalLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _assetsTotalLabel.text = @"0.00";
        _assetsTotalLabel.textAlignment = NSTextAlignmentLeft;
        _assetsTotalLabel.font = kHXBFont_DINAlternate_BOLD_750(70);
        _assetsTotalLabel.textColor = kHXBColor_333333_100;
    }
    return _assetsTotalLabel;
}
- (UILabel *)balanceTitleLabel{
    if (!_balanceTitleLabel) {
        _balanceTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _balanceTitleLabel.text = @"可用金额(元)";
        _balanceTitleLabel.textAlignment = NSTextAlignmentLeft;
        _balanceTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _balanceTitleLabel.textColor = COR10;
    }
    return _balanceTitleLabel;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _balanceLabel.text = @"0.00";
    _balanceLabel.textAlignment = NSTextAlignmentLeft;
    _balanceLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    _balanceLabel.textColor = COR6;
 }
    return _balanceLabel;

}

- (UIButton *)topupButton{
    if (!_topupButton) {
        _topupButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_topupButton setTitle:@"充值" forState:UIControlStateNormal];
        [_topupButton setTitleColor:RGB(255, 64, 79) forState:UIControlStateNormal];
        [_topupButton addTarget:self action:@selector(topupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _topupButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        [_topupButton.layer setCornerRadius:1.0];
        [_topupButton.layer setBorderWidth:1.0];
        _topupButton.layer.borderColor = RGB(255, 64, 79).CGColor;
    }
    return _topupButton;
}

- (UIButton *)withdrawButton{
    if (!_withdrawButton) {
        _withdrawButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_withdrawButton setTitleColor:RGB(255, 64, 79) forState:UIControlStateNormal];
        [_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        [_withdrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_withdrawButton.layer setCornerRadius:1.0];
        [_withdrawButton.layer setBorderWidth:1.0];
        _withdrawButton.layer.borderColor = RGB(255, 64, 79).CGColor;
    }
    return _withdrawButton;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightGrayImage"]];
    }
    return _lineView;
}


@end
