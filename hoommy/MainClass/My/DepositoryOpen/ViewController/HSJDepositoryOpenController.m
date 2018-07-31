//
//  HSJDepositoryOpenController.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJDepositoryOpenController.h"
#import "UIImageView+HxbSDWebImage.h"
#import "HXBCustomTextField.h"
#import "SVGKit/SVGKImage.h"
#import "UITextField+HLNumberFormatTextField.h"
#import "HXBAgreementView.h"
#import "HxbHUDProgress.h"
#import "HXBBankCardListViewController.h"
#import "HSJDepositoryOpenViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <IQKeyboardManager.h>

#define kInputHeight 50

@interface HSJDepositoryOpenController () <UITextFieldDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
/// 姓名
@property (nonatomic, weak) HXBCustomTextField *nameView;
/// 身份证号
@property (nonatomic, weak) HXBCustomTextField *idView;
/// 交易密码
@property (nonatomic, weak) HXBCustomTextField *transactionPwdView;
/// 银行卡号
@property (nonatomic, weak) HXBCustomTextField *bankNoView;
/// 银行卡名称
@property (nonatomic, weak) HXBCustomTextField *bankNameView;
/// 预留手机号
@property (nonatomic, weak) HXBCustomTextField *mobileView;

@property (nonatomic, weak) UIButton *bottomBtn;

@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong) HSJDepositoryOpenViewModel *viewModel;

@property (nonatomic, weak) UITextField *currentField;
@end

@implementation HSJDepositoryOpenController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通存管账户";

    self.viewModel = [HSJDepositoryOpenViewModel new];
    self.isAgree = YES;
    [self setUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setUI {
    self.isWhiteColourGradientNavigationBar = YES;
    [self setScrollView];
    [self setTopViews];
    [self setBankView];
    [self setBottomView];
    
    kWeakSelf
    [self.nameView.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        [weakSelf setBottomBtnState];
    }];
    
    [self.idView.idTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        [weakSelf setBottomBtnState];
    }];
    
    [self.transactionPwdView.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        [weakSelf setBottomBtnState];
    }];
    
    [self.bankNoView.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        [weakSelf setBottomBtnState];
    }];
    
    [self.mobileView.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        [weakSelf setBottomBtnState];
    }];
}

- (void)setTopViews {
    UIView *sectionView1 = [self viewTitle:@"安全认证" description:nil];
    [self.scrollView addSubview:sectionView1];

    HXBCustomTextField *nameView = [[HXBCustomTextField alloc] init];
    nameView.leftImage = [UIImage imageNamed:@"depository_name"];
    nameView.placeholder = @"真实姓名";
    [self commonTextViewProp:nameView];
    [self.scrollView addSubview:nameView];
    self.nameView = nameView;

    HXBCustomTextField *idView = [[HXBCustomTextField alloc] init];
    idView.leftImage = [UIImage imageNamed:@"depository_id"];
    idView.placeholder = @"身份证号";
    idView.isIDCardTextField = YES;
    idView.limitStringLength = 18;
    [self commonTextViewProp:idView];
    [self.scrollView addSubview:idView];
    self.idView = idView;
    
    HXBCustomTextField *transactionPwdView = [[HXBCustomTextField alloc] init];
    transactionPwdView.leftImage = [UIImage imageNamed:@"depository_transaction_pwd"];
    transactionPwdView.placeholder = @"交易密码";
    transactionPwdView.limitStringLength = 6;
    transactionPwdView.hideEye = NO;
    transactionPwdView.textFieldRightOffset = 40;
    transactionPwdView.secureTextEntry = YES;
    transactionPwdView.keyboardType = UIKeyboardTypeNumberPad;
    [self commonTextViewProp:transactionPwdView];
    [self.scrollView addSubview:transactionPwdView];
    self.transactionPwdView = transactionPwdView;

    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
    }];

    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView1.mas_bottom);
        make.left.equalTo(sectionView1).offset(-5);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];

    [idView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom);
        make.left.equalTo(nameView);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];
    
    [transactionPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idView.mas_bottom);
        make.left.equalTo(nameView);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];
}

- (void)setBankView {
    UIView *sectionView2 = [self viewTitle:@"银行卡" description:@"实名认证与银行卡需为同一人"];
    [self.scrollView addSubview:sectionView2];

    HXBCustomTextField *bankNoView = [[HXBCustomTextField alloc] init];
    bankNoView.leftImage = [UIImage imageNamed:@"depository_bank"];
    bankNoView.placeholder = @"银行卡号";
    bankNoView.limitStringLength = 31;
    bankNoView.textFieldRightOffset = 70;
    bankNoView.keyboardType = UIKeyboardTypeNumberPad;
    [self commonTextViewProp:bankNoView];

    kWeakSelf
    bankNoView.block = ^(NSString *text) {
        NSString *bankNumber = [text stringByReplacingOccurrencesOfString:@" "  withString:@""];
        if (bankNumber.length>=12) {
            [weakSelf.viewModel checkCardBinResultRequestWithBankNumber:bankNumber andisToastTip:NO andCallBack:^(BOOL isSuccess) {
                if (isSuccess) {
                    if (weakSelf.viewModel.cardBinModel.creditCard) {
                        weakSelf.bankNameView.svgImageName = weakSelf.viewModel.cardBinModel.bankCode;
                        weakSelf.bankNameView.text = @"此卡为信用卡，暂不支持";
                    } else {
                        weakSelf.bankNameView.svgImageName = weakSelf.viewModel.cardBinModel.bankCode;
                        weakSelf.bankNameView.text = [NSString stringWithFormat:@"%@：%@",weakSelf.viewModel.cardBinModel.bankName, weakSelf.viewModel.cardBinModel.quota];
                    }
                    [weakSelf showBankNameView];
                } else {
                    [weakSelf hideBankNameView];
                }
            }];
        }
    };
    [self.scrollView addSubview:bankNoView];
    self.bankNoView = bankNoView;

    UIButton *checkLimitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkLimitBtn setTitle:@"银行限额" forState:(UIControlStateNormal)];
    checkLimitBtn.backgroundColor = [UIColor whiteColor];
    [checkLimitBtn setTitleColor:kHXBFOntColor_4C66E7_100 forState:(UIControlStateNormal)];
    [checkLimitBtn addTarget:self action:@selector(checkBankLimit) forControlEvents:(UIControlEventTouchUpInside)];
    checkLimitBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    [checkLimitBtn sizeToFit];
    [bankNoView addSubview:checkLimitBtn];

    HXBCustomTextField *bankNameView = [[HXBCustomTextField alloc] init];
    bankNameView.alpha = 0;
    bankNameView.placeholder = @"银行名称";
    bankNameView.userInteractionEnabled = NO;
    bankNameView.textColor = kHXBColor_999999_100;
    bankNameView.bottomLineNormalColor = kHXBColor_ECECEC_100;
    [self.scrollView insertSubview:bankNameView belowSubview:bankNoView];
    self.bankNameView = bankNameView;
    
    HXBCustomTextField *mobileView = [[HXBCustomTextField alloc] init];
    mobileView.leftImage = [UIImage imageNamed:@"depository_mobile"];
    mobileView.placeholder = @"预留手机号";
    mobileView.limitStringLength = 11;
    mobileView.keyboardType = UIKeyboardTypeNumberPad;
    [self commonTextViewProp:mobileView];
    [self.scrollView addSubview:mobileView];
    self.mobileView = mobileView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transactionPwdView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];

    [bankNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView2.mas_bottom);
        make.left.equalTo(sectionView2).offset(-5);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];

    [checkLimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bankNoView).offset(-15);
        make.centerY.equalTo(bankNoView);
    }];

    [bankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNoView).offset(0);
        make.left.equalTo(bankNoView);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];
    
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNameView.mas_bottom);
        make.left.equalTo(bankNoView);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];
}

- (void)setScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    scrollView.alwaysBounceVertical = YES;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.offset(HXBStatusBarAndNavigationBarHeight);
    }];
}

- (void)setBottomView {
    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.backgroundColor = kHXBColor_D5B775_50;
    [bottomBtn setTitle:@"开通恒丰银行存管账户" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(16);
    bottomBtn.layer.cornerRadius = 2;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:bottomBtn];
    self.bottomBtn = bottomBtn;
    
    
//    我已查看并同意《红小宝认证服务协议》与《存管服务协议》
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"我已查看并同意《红小宝认证服务协议》与《存管服务协议》"];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:kHXBFOntColor_4C66E7_100, NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)};
    NSMutableAttributedString *attributedString = [HXBAgreementView configureLinkAttributedString:attString withString:@"《红小宝认证服务协议》" sameStringEnable:NO linkAttributes:linkAttributes activeLinkAttributes:linkAttributes parameter:nil clickLinkBlock:^{
        NSLog(@"《红小宝认证服务协议》");
    }];
    attributedString = [HXBAgreementView configureLinkAttributedString:attributedString withString:@"《存管服务协议》" sameStringEnable:NO linkAttributes:linkAttributes activeLinkAttributes:linkAttributes parameter:nil clickLinkBlock:^{
        NSLog(@"《存管服务协议》");
    }];
    
    kWeakSelf
    HXBAgreementView *agreementView = [[HXBAgreementView alloc] initWithFrame:CGRectZero];
    agreementView.text = attributedString;
    agreementView.agreeBtnBlock = ^(BOOL isSelected){
        weakSelf.isAgree = isSelected;
        [weakSelf setBottomBtnState];
    };
    
    [self.scrollView addSubview:agreementView];
    
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomBtn);
        make.bottom.equalTo(bottomBtn.mas_top).offset(-15);
    }];

    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileView.mas_bottom).offset(80);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@41);
    }];
    
    [self.view layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(bottomBtn.frame) + 30);
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentField = textField;
    if (self.nameView.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryNameTextFieldClick];
    } else if (self.idView.idTextField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryIDTextFieldClick];
    } else if (self.transactionPwdView.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryTransactionPwdTextFieldClick];
    } else if (self.bankNoView.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryBankNoTextFieldClick];
    } else if (self.mobileView.textField == textField) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryMobileTextFieldClick];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.bankNoView == textField.superview) {
        [self hideBankNameView];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.superview == self.bankNoView) {
        return [UITextField numberFormatTextField:textField shouldChangeCharactersInRange:range replacementString:string textFieldType:kBankCardNumberTextFieldType];
    }
    if ([string isEqualToString:@""]) {
        return YES;
    } else {
        if (self.nameView == textField.superview && [string isEqualToString:@" "]) {
            return NO;
        }
        return [self limitNumberCount:textField.superview];
    }
}

- (void)willChangeFrame:(NSNotification *)notification {
    if ([self.currentField isEqual:self.mobileView.textField]) {
        CGFloat endY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        if (endY == kScreenHeight) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            CGRect rect = [self.mobileView convertRect:self.currentField.frame toView:[UIApplication sharedApplication].keyWindow];
            CGFloat maxY = CGRectGetMaxY(rect);
            
            self.scrollView.contentInset = UIEdgeInsetsMake(-MAX(10, maxY - endY + 10 + self.scrollView.contentOffset.y), 0, 0, 0);
        }
    } else if ([self.currentField isEqual:self.bankNoView.textField]) {
        CGFloat endY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        if (endY == kScreenHeight) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            CGRect rect = [self.bankNoView convertRect:self.currentField.frame toView:[UIApplication sharedApplication].keyWindow];
            CGFloat maxY = CGRectGetMaxY(rect);
            
            self.scrollView.contentInset = UIEdgeInsetsMake(-MAX(10, maxY - endY + 10 + self.scrollView.contentOffset.y), 0, 0, 0);
        }
    } else {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - Helper
- (UIView *)viewTitle:(NSString *)title description:(NSString *)description {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [NSString stringWithFormat:@"%@", title];
    titleLabel.font = kHXBFont_30;
    titleLabel.textColor = kHXBFontColor_333333_100;
    [view addSubview:titleLabel];

    UILabel *descLabel = [UILabel new];
    descLabel.text = description;
    descLabel.font = kHXBFont_24;
    descLabel.textColor = kHXBColor_999999_100;
    [view addSubview:descLabel];
    
    if (description == nil) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"按国家规定投资用户必须"];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"18岁以上" attributes:@{NSForegroundColorAttributeName: RGB(236, 92, 32)}]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"，实名认证一天最多"]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"3" attributes:@{NSForegroundColorAttributeName: RGB(236, 92, 32)}]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"次"]];
        descLabel.attributedText = attr;
    }

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@kScrAdaptationW(15));
    }];

    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(@kScrAdaptationW(-15));
    }];

    return view;
}

- (void)showBankNameView {
    self.bankNameView.alpha = 0;
    [self.bankNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNoView).offset(kInputHeight);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bankNameView.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bottomBtn.frame) + 30);
    }];
}

- (void)hideBankNameView {
    self.bankNameView.alpha = 1;
    [self.bankNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNoView).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bankNameView.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bottomBtn.frame) + 30);
    }];
}

- (BOOL)limitNumberCount:(UIView *)textField
{
    if (self.idView.text.length >= self.idView.limitStringLength && self.idView == textField) {
        return NO;
    }
    
    if (self.transactionPwdView.text.length >= self.transactionPwdView.limitStringLength && self.transactionPwdView == textField) {
        return NO;
    }

    if (self.bankNoView.text.length >= self.bankNoView.limitStringLength && self.bankNoView == textField) {
        return NO;
    }
    
    if (self.mobileView.text.length >= self.mobileView.limitStringLength && self.mobileView == textField) {
        return NO;
    }

    return YES;
}

- (BOOL)judgeIsTure
{
    BOOL isNull = NO;
    if (!(self.nameView.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"请输入您的真实姓名"];
        isNull = YES;
        return isNull;
    }
    
    if (!(self.idView.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"请输入身份证号"];
        isNull = YES;
        return isNull;
    }
    
    if(self.idView.text.length != 18)
    {
        [HxbHUDProgress showTextInView:self.view text:@"请输入正确身份号"];
        isNull = YES;
        return isNull;
    }
    
    if (!(self.transactionPwdView.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"请设置6位交易密码"];
        isNull = YES;
        return isNull;
    }
    
    if (self.transactionPwdView.text.length != 6) {
        [HxbHUDProgress showTextInView:self.view text:@"请设置正确的交易密码"];
        isNull = YES;
        return isNull;
    }

    if (!(self.bankNoView.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"请输入银行卡号"];
        
        isNull = YES;
        return isNull;
    }
    
    if (!(self.bankNoView.text.length >= 10 && self.bankNoView.text.length <= 31)) {
        [HxbHUDProgress showTextInView:self.view text:@"请输入正确银行卡号"];
        isNull = YES;
        return isNull;
    }
    
    if (!(self.mobileView.text.length > 0)) {
        [HxbHUDProgress showTextInView:self.view text:@"预留手机号不能为空"];
        isNull = YES;
        return isNull;
    }
    
    if (self.mobileView.text.length != 11) {
        [HxbHUDProgress showTextInView:self.view text:@"预留手机号有误"];
        isNull = YES;
        return isNull;
    }
    
    return isNull;
}

- (void)commonTextViewProp:(HXBCustomTextField *)textView {
    textView.bottomLineLeftOffset = 44;
    textView.bottomLineRightOffset = 0;
    textView.font = kHXBFont_28;
    textView.textColor = kHXBFontColor_333333_100;
    textView.bottomLineNormalColor = kHXBColor_ECECEC_100;
    textView.delegate = self;
}

- (void)setBottomBtnState {
    NSString *username = [self.nameView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *idNo = [self.idView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *transactionPwd = [self.transactionPwdView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bankNo = [self.bankNoView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *mobile = [self.mobileView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    BOOL nameEnable = username.length >= 2;
//    BOOL idNoEnable = idNo.length >= self.idView.limitStringLength;
//    BOOL pwdEnable = transactionPwd.length >= self.transactionPwdView.limitStringLength;
//    BOOL bankNoEnable = bankNo.length >= 12;
//    BOOL mobileEnable = mobile.length >= self.mobileView.limitStringLength;
    
    BOOL nameEnable = username.length > 0;
    BOOL idNoEnable = idNo.length > 0;
    BOOL pwdEnable = transactionPwd.length > 0;
    BOOL bankNoEnable = bankNo.length > 0;
    BOOL mobileEnable = mobile.length > 0;
    
    if ((nameEnable || idNoEnable || pwdEnable || bankNoEnable || mobileEnable) && self.isAgree) {
        self.bottomBtn.backgroundColor = kHXBColor_D5B775;
        self.bottomBtn.enabled = YES;
    } else {
        self.bottomBtn.backgroundColor = kHXBColor_D5B775_50;
        self.bottomBtn.enabled = NO;
    }
}

#pragma mark - Action
/// 开通恒丰银行存管账户
- (void)bottomBtnClick {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryOpenClick];
    
    if ([self judgeIsTure]) return;

    [self.view endEditing:YES];

    NSString *username = [self.nameView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *idNo = [self.idView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *transactionPwd = [self.transactionPwdView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bankNo = [self.bankNoView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *mobile = [self.mobileView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *param = @{ @"realName": username,
                            @"identityCard": idNo,
                            @"password": transactionPwd,
                            @"bankCard": bankNo,
                            @"bankReservedMobile": mobile,
                            };
    
    kWeakSelf
    [self.viewModel openDepositoryWithParam:param resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/// 查看银行限额
- (void)checkBankLimit {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryBankListClick];
    
    HXBBankCardListViewController *VC = [[HXBBankCardListViewController alloc] init];
    HXBBaseNavigationController *nav = [[HXBBaseNavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)leftBackBtnClick {
    [super leftBackBtnClick];
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DepositoryBackClick];
}

@end
