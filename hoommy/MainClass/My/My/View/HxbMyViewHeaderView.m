//
//  HxbMyViewHeaderView.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/4.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbMyViewHeaderView.h"
#import "SVGKit/SVGKImage.h"
//#import "HXBMyRequestAccountModel.h"
//#import "HXBOpenDepositAccountViewController.h"
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
//        [self addSubview:self.balanceTitleLabel]; ///可用余额
//        [self addSubview:self.balanceLabel];
//        [self addSubview:self.topupButton];
//        [self addSubview:self.withdrawButton];
//        [self addSubview:self.lineView];
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
        make.top.equalTo(weakSelf.headTopView).offset(kScrAdaptationH750(59));
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
        make.top.equalTo(weakSelf.headTopView).offset(kScrAdaptationH750(197));
        make.left.equalTo(weakSelf).offset(kScrAdaptationW750(5));
        make.right.right.equalTo(weakSelf).offset(kScrAdaptationW750(-5));
        make.height.offset(kScrAdaptationH750(380));
    }];
    [self.noAccountOpeningBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW(-4));
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(-5));
        make.bottom.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(15));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(4));
    }];
    
    [self.yesterdayInterestTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW750(60));
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH750(60));
        make.height.equalTo(@kScrAdaptationH(17));
        make.width.equalTo(@kScrAdaptationW(68));
    }];
    [self.yesterdayInterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.yesterdayInterestTitleLabel);
        make.top.equalTo(weakSelf.yesterdayInterestTitleLabel.mas_bottom).offset(kScrAdaptationH(9.5));
        make.height.equalTo(@kScrAdaptationH(35));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW(-15));
    }];
    [self.securyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationH(27));
        make.width.equalTo(@kScrAdaptationW(20));
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage).offset(kScrAdaptationW750(-50));
        make.height.offset(kScrAdaptationH(12));
    }];
    [self.accumulatedProfitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.yesterdayInterestLabel);
        make.width.equalTo(@kScrAdaptationW(80));
        make.top.equalTo(weakSelf.yesterdayInterestLabel.mas_bottom).offset(kScrAdaptationH(25));
        make.height.equalTo(@kScrAdaptationH(17));
    }];
    [self.accumulatedProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accumulatedProfitTitleLabel.mas_left);
        make.top.equalTo(weakSelf.accumulatedProfitTitleLabel.mas_bottom).offset(kScrAdaptationH(2));
        make.height.equalTo(@kScrAdaptationH(19));
    }];
    [self.assetsTotalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accumulatedProfitTitleLabel.mas_right).offset(kScrAdaptationW(85));
        make.top.equalTo(weakSelf.accumulatedProfitTitleLabel);
        make.height.equalTo(weakSelf.accumulatedProfitTitleLabel);
        make.width.equalTo(@kScrAdaptationW(80));
    }];
    [self.assetsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.assetsTotalTitleLabel);
        make.top.equalTo(weakSelf.accumulatedProfitLabel);
        make.height.equalTo(weakSelf.accumulatedProfitLabel);
        make.right.equalTo(weakSelf.accountOpeningBackgroundImage.mas_right).offset(kScrAdaptationW(-15));
    }];
//    [self.balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf).offset(kScrAdaptationW(15));
//        make.width.equalTo(@kScrAdaptationW(70));
//        make.top.equalTo(weakSelf.accountOpeningBackgroundImage.mas_bottom).offset(kScrAdaptationH(39.5));
//        make.height.equalTo(@kScrAdaptationH(12));
//    }];
//    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.balanceTitleLabel.mas_right).offset(kScrAdaptationW(10));
//        make.top.equalTo(weakSelf.accountOpeningBackgroundImage.mas_bottom).offset(kScrAdaptationH(35));
////        make.width.equalTo(@kScrAdaptationW750(280));
//        make.height.equalTo(@kScrAdaptationH(21));
//    }];
//    [self.topupButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf).offset(kScrAdaptationW(230));
//        make.top.equalTo(weakSelf.accountOpeningBackgroundImage.mas_bottom).offset(kScrAdaptationH(33));
//        make.width.equalTo(@kScrAdaptationW(60));
//        make.height.equalTo(@kScrAdaptationH(25));
//    }];
//    [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.topupButton.mas_right).offset(kScrAdaptationW(10));
//        make.width.top.height.equalTo(weakSelf.topupButton);
//    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.left.equalTo(weakSelf);
//        make.top.equalTo(weakSelf.mas_bottom).offset(kScrAdaptationH(-1));
//        make.height.equalTo(@kScrAdaptationH(1));
//    }];
}

- (void)clickAllFinanceButton: (UITapGestureRecognizer *)tap {
    if (self.clickAllFinanceButtonBlock) {
        
        if (!self.userInfoModel.userInfo.isCreateEscrowAcc) { // 未开户
//            HXBOpenDepositAccountViewController *openDepositAccountVC = [[HXBOpenDepositAccountViewController alloc] init];
//            openDepositAccountVC.title = @"开通存管账户";
//            openDepositAccountVC.type = HXBRechargeAndWithdrawalsLogicalJudgment_Other;
//             [[HXBRootVCManager manager].topVC.navigationController pushViewController:openDepositAccountVC animated:YES];
        } else {
            self.clickAllFinanceButtonBlock((UILabel *)tap.view);
        }
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
    
    self.phoneLabel.text = _userInfoModel.userInfo.username?:[KeyChain.mobile hxb_hiddenPhonNumberWithMid];
    NSString *accumulatedProfitStr = userInfoModel.userAssets.earnTotal? [NSString GetPerMilWithDouble:[userInfoModel.userAssets.earnTotal doubleValue]]: @"0.00";
    NSString *balance = userInfoModel.userAssets.availablePoint ? [NSString GetPerMilWithDouble:[userInfoModel.userAssets.availablePoint doubleValue]] : @"0.00";
    NSString *yesterdayInterest = [NSString GetPerMilWithDouble:[userInfoModel.userAssets.earnTotal doubleValue]];
    if ([KeyChain.ciphertext isEqualToString:@"0"]) {
        self.securyButton.selected = NO;
        self.yesterdayInterestLabel.text = yesterdayInterest;
        self.accumulatedProfitLabel.text = accumulatedProfitStr;
        self.balanceLabel.text = balance;
        self.assetsTotalLabel.text = [NSString GetPerMilWithDouble:[userInfoModel.userAssets.assetsTotal doubleValue]];
    } else {
        self.securyButton.selected = YES;
        self.accumulatedProfitLabel.text = kSecuryText;
        self.yesterdayInterestLabel.text = kSecuryText;
        self.balanceLabel.text = kSecuryText;
        self.assetsTotalLabel.text = kSecuryText;
    }
}
/**
 设置数据

 @param accountInfoViewModel 数据模型
 */
//- (void)setAccountInfoViewModel:(HXBMyRequestAccountModel *)accountInfoViewModel{
//    _accountInfoViewModel = accountInfoViewModel;
//
////    self.accountOpeningBackgroundImage.hidden = NO;
//    if (!self.userInfoViewModel.userInfoModel.userInfo.isCreateEscrowAcc) {
//        self.noAccountOpeningBackgroundImage.hidden = NO;
//    } else {
//        self.noAccountOpeningBackgroundImage.hidden = YES;
//    }
//
//    self.phoneLabel.text = [KeyChain.mobile hxb_hiddenPhonNumberWithMid];
//    NSString *accumulatedProfitStr = accountInfoViewModel.earnTotal? [NSString GetPerMilWithDouble:accountInfoViewModel.earnTotal]: @"0.00";
//    NSString *balance = accountInfoViewModel.availablePoint ? [NSString GetPerMilWithDouble:accountInfoViewModel.availablePoint] : @"0.00";
//    NSString *yesterdayInterest = [NSString GetPerMilWithDouble:accountInfoViewModel.yesterdayInterest];
//    if ([KeyChain.ciphertext isEqualToString:@"0"]) {
//        self.securyButton.selected = NO;
//        self.yesterdayInterestLabel.text = yesterdayInterest;
//        self.accumulatedProfitLabel.text = accumulatedProfitStr;
//        self.balanceLabel.text = balance;
//        self.assetsTotalLabel.text = [NSString GetPerMilWithDouble:accountInfoViewModel.assetsTotal];
//    } else {
//        self.securyButton.selected = YES;
//        self.accumulatedProfitLabel.text = kSecuryText;
//        self.yesterdayInterestLabel.text = kSecuryText;
//        self.balanceLabel.text = kSecuryText;
//        self.assetsTotalLabel.text = kSecuryText;
//    }
//}

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
    NSString *accumulatedProfitStr = _userInfoModel.userAssets.earnTotal? [NSString GetPerMilWithDouble:[_userInfoModel.userAssets.earnTotal doubleValue]]: @"0.00";
    NSString *balance = _userInfoModel.userAssets.availablePoint ? [NSString GetPerMilWithDouble:[_userInfoModel.userAssets.availablePoint doubleValue]] : @"0.00";
    NSString *yesterdayInterest = [NSString GetPerMilWithDouble:[_userInfoModel.userAssets.earnTotal doubleValue]];
    
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
        self.accumulatedProfitLabel.text = accumulatedProfitStr;
        self.balanceLabel.text = balance;
        self.yesterdayInterestLabel.text = yesterdayInterest;
        self.assetsTotalLabel.text = [NSString GetPerMilWithDouble:[_userInfoModel.userAssets.assetsTotal doubleValue]];
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
        _headTopView.image = [UIImage imageNamed:@"my_top_bg"];
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
//        _accountOpeningBackgroundImage.layer.cornerRadius = 3;
//        _accountOpeningBackgroundImage.layer.masksToBounds = YES;
    }
    return _accountOpeningBackgroundImage;
}
- (UIImageView *)noAccountOpeningBackgroundImage {
    if (!_noAccountOpeningBackgroundImage) {
        _noAccountOpeningBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noAccountOpeningBackgroundImage"]];
        _noAccountOpeningBackgroundImage.userInteractionEnabled = YES;
        _noAccountOpeningBackgroundImage.layer.cornerRadius = 3;
        _noAccountOpeningBackgroundImage.layer.masksToBounds = YES;
    }
    return _noAccountOpeningBackgroundImage;
}
- (UILabel *)yesterdayInterestTitleLabel {
    if (!_yesterdayInterestTitleLabel) {
        _yesterdayInterestTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yesterdayInterestTitleLabel.textAlignment = NSTextAlignmentLeft;
        _yesterdayInterestTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _yesterdayInterestTitleLabel.text = @"昨日收益(元)";
        _yesterdayInterestTitleLabel.textColor = COR12;
    }
    return _yesterdayInterestTitleLabel;
}
- (UIButton *)securyButton{
    if (!_securyButton) {
        _securyButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_securyButton setImage:[UIImage imageNamed:@"my_eyes"] forState:UIControlStateNormal];
        [_securyButton setImage:[UIImage imageNamed:@"my_closedEyes"] forState:UIControlStateSelected];
        _securyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_securyButton addTarget:self action:@selector(securyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _securyButton;
}
-(UILabel *)yesterdayInterestLabel {
    if (!_yesterdayInterestLabel) {
        _yesterdayInterestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yesterdayInterestLabel.textAlignment = NSTextAlignmentLeft;
        _yesterdayInterestLabel.font = kHXBFont_PINGFANGSC_REGULAR(35);
        _yesterdayInterestLabel.textColor = kHXBColor_333333_100;
        _yesterdayInterestLabel.text = @"0.00元";
    }
    return _yesterdayInterestLabel;
}
-(UILabel *)accumulatedProfitTitleLabel {
    if (!_accumulatedProfitTitleLabel) {
        _accumulatedProfitTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _accumulatedProfitTitleLabel.text = @"累计收益(元)";
        _accumulatedProfitTitleLabel.textAlignment = NSTextAlignmentLeft;
        _accumulatedProfitTitleLabel.font = kHXBFont_PINGFANGSC_REGULAR(13);
        _accumulatedProfitTitleLabel.textColor = COR12;
    }
    return _accumulatedProfitTitleLabel;
}
- (UILabel *)accumulatedProfitLabel{
    if (!_accumulatedProfitLabel) {
        _accumulatedProfitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _accumulatedProfitLabel.text = @"0.00元";
        _accumulatedProfitLabel.textAlignment = NSTextAlignmentLeft;
        _accumulatedProfitLabel.font = kHXBFont_PINGFANGSC_REGULAR(20);
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
        _assetsTotalTitleLabel.textColor = COR12;
    }
    return _assetsTotalTitleLabel;
}
-(UILabel *)assetsTotalLabel{
    if (!_assetsTotalLabel) {
        _assetsTotalLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _assetsTotalLabel.text = @"0.00元";
        _assetsTotalLabel.textAlignment = NSTextAlignmentLeft;
        _assetsTotalLabel.font = kHXBFont_PINGFANGSC_REGULAR(20);
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
