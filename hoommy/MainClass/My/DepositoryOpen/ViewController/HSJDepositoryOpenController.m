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

@property (nonatomic, assign) BOOL isAgree;
@end

@implementation HSJDepositoryOpenController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通存管账户";

    [self setUI];
}

#pragma mark - UI

- (void)setUI {
    [self setScrollView];

    [self setTopViews];

    [self setBankView];

    [self setBottomView];
}

- (void)setTopViews {
    UIView *sectionView1 = [self viewTitle:@"安全认证" description:@"按国家规定投资用户需满18岁"];
    [self.scrollView addSubview:sectionView1];

    HXBCustomTextField *nameView = [[HXBCustomTextField alloc] init];
    nameView.svgImageName = @"name.svg";
    nameView.placeholder = @"真实姓名";
    nameView.delegate = self;
    [self.scrollView addSubview:nameView];
    self.nameView = nameView;

    HXBCustomTextField *idView = [[HXBCustomTextField alloc] init];
    idView.leftImage = [SVGKImage imageNamed:@"id_number.svg"].UIImage;
    idView.placeholder = @"身份证号";
    idView.delegate = self;
    idView.isIDCardTextField = YES;
    [self.scrollView addSubview:idView];
    self.idView = idView;
    
    HXBCustomTextField *transactionPwdView = [[HXBCustomTextField alloc] init];
    transactionPwdView.leftImage = [SVGKImage imageNamed:@"id_number.svg"].UIImage;
    transactionPwdView.placeholder = @"交易密码";
    transactionPwdView.delegate = self;
    transactionPwdView.limitStringLength = 6;
    [self.scrollView addSubview:transactionPwdView];
    self.transactionPwdView = transactionPwdView;

    [sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.right.equalTo(self.view);
    }];

    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView1.mas_bottom).offset(30);
        make.left.equalTo(sectionView1);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];

    [idView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom);
        make.left.equalTo(sectionView1);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];
    
    [transactionPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idView.mas_bottom);
        make.left.equalTo(sectionView1);
        make.right.equalTo(sectionView1);
        make.height.equalTo(@kInputHeight);
    }];
}

- (void)setBankView {
    UIView *sectionView2 = [self viewTitle:@"银行卡" description:@"实名认证与银行卡需为同一人"];
    [self.scrollView addSubview:sectionView2];

    HXBCustomTextField *bankNoView = [[HXBCustomTextField alloc] init];
    bankNoView.leftImage = [SVGKImage imageNamed:@"card.svg"].UIImage;
    bankNoView.placeholder = @"银行卡号";
    bankNoView.delegate = self;
    bankNoView.limitStringLength = 31;
    bankNoView.keyboardType = UIKeyboardTypeNumberPad;

    kWeakSelf
    bankNoView.block = ^(NSString *text) {
        NSString *bankNumber = [text stringByReplacingOccurrencesOfString:@" "  withString:@""];
        if (bankNumber.length>=12) {
//            [weakSelf.viewModel checkCardBinResultRequestWithBankNumber:bankNumber andisToastTip:NO andCallBack:^(BOOL isSuccess) {
//                if (isSuccess) {
//                    if (weakSelf.viewModel.cardBinModel.creditCard) {
//                        weakSelf.bankNameView.svgImageName = weakSelf.viewModel.cardBinModel.bankCode;
//                        weakSelf.bankNameView.text = @"此卡为信用卡，暂不支持";
//                    } else {
//                        weakSelf.bankNameView.svgImageName = weakSelf.viewModel.cardBinModel.bankCode;
//                        weakSelf.bankNameView.text = [NSString stringWithFormat:@"%@：%@",weakSelf.viewModel.cardBinModel.bankName, weakSelf.viewModel.cardBinModel.quota];
//                    }
//                    [weakSelf showBankNameView];
//                } else {
//                    [weakSelf hideBankNameView];
//                }
//            }];
        }
    };
    [self.scrollView addSubview:bankNoView];
    self.bankNoView = bankNoView;

    UIButton *checkLimitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkLimitBtn setTitle:@"查看银行限额" forState:(UIControlStateNormal)];
    checkLimitBtn.backgroundColor = [UIColor whiteColor];
    [checkLimitBtn setTitleColor:kHXBColor_73ADFF_100 forState:(UIControlStateNormal)];
    [checkLimitBtn addTarget:self action:@selector(checkBankLimit) forControlEvents:(UIControlEventTouchUpInside)];
    checkLimitBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    [checkLimitBtn sizeToFit];
    [bankNoView addSubview:checkLimitBtn];

    HXBCustomTextField *bankNameView = [[HXBCustomTextField alloc] init];
//    bankNameView.leftImage = [SVGKImage imageNamed:@"默认.svg"].UIImage;
    bankNameView.alpha = 0;
    bankNameView.placeholder = @"银行名称";
    bankNameView.delegate = self;
    bankNameView.userInteractionEnabled = NO;
    bankNameView.textColor = kHXBColor_999999_100;
    //    [self.scrollView addSubview:bankNameView];
    [self.scrollView insertSubview:bankNameView belowSubview:bankNoView];
    self.bankNameView = bankNameView;
    
    HXBCustomTextField *mobileView = [[HXBCustomTextField alloc] init];
    mobileView.leftImage = [SVGKImage imageNamed:@"id_number.svg"].UIImage;
    mobileView.placeholder = @"交易密码";
    mobileView.delegate = self;
    mobileView.limitStringLength = 11;
    [self.scrollView addSubview:mobileView];
    self.mobileView = mobileView;

    [sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transactionPwdView.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
    }];

    [bankNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView2.mas_bottom).offset(30);
        make.left.equalTo(sectionView2);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];

    [checkLimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bankNoView).offset(-20);
        make.centerY.equalTo(bankNoView);
    }];

    [bankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNoView).offset(0);
        make.left.equalTo(sectionView2);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];
    
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNameView.mas_bottom);
        make.left.equalTo(sectionView2);
        make.right.equalTo(sectionView2);
        make.height.equalTo(@kInputHeight);
    }];
}

- (void)setScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
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
    bottomBtn.backgroundColor = kHXBColor_E3BF80;
    [bottomBtn setTitle:@"开通恒丰银行存管账户" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(16);
    bottomBtn.layer.cornerRadius = 4;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:bottomBtn];
    
    
//    我已查看并同意《红小宝认证服务协议》与《存管服务协议》
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"我已查看并同意《红小宝认证服务协议》与《存管服务协议》"];
    
    NSDictionary *linkAttributes = @{
                                     NSForegroundColorAttributeName:kHXBColor_73ADFF_100,
                                     NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(12)
                                     };
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
        if (isSelected) {
            bottomBtn.backgroundColor = kHXBColor_E3BF80;
            bottomBtn.enabled = YES;
        }else
        {
            bottomBtn.backgroundColor = kHXBColor_D8D8D8_100;
            bottomBtn.enabled = NO;
        }
    };
    
    [self.scrollView addSubview:agreementView];
    
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomBtn);
        make.bottom.equalTo(bottomBtn.mas_top).offset(-10);
    }];

    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileView.mas_bottom).offset(80);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.equalTo(@41);
    }];
}


#pragma mark - UITextFieldDelegate
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

#pragma mark - Helper
- (UIView *)viewTitle:(NSString *)title description:(NSString *)description {
    UIView *view = [UIView new];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [NSString stringWithFormat:@"●  %@  ●", title];
    titleLabel.font = kHXBFont_30;
    titleLabel.textColor = UIColorFromRGB(0x003D7E);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];

    UILabel *descLabel = [UILabel new];
    descLabel.text = description;
    descLabel.font = kHXBFont_24;
    descLabel.textColor = kHXBColor_999999_100;
    descLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:descLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
    }];

    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(view);
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
    }];
}

- (BOOL)limitNumberCount:(UIView *)textField
{
    if (self.idView.text.length > 17 && self.idView == textField) {
        return NO;
    }

    if (self.bankNoView.text.length > 31 && self.bankNoView == textField) {
        return NO;
    }

    return YES;
}

- (BOOL)judgeIsTure
{
    BOOL isNull = NO;
//    if (!(self.nameView.text.length > 0)) {
//        [HxbHUDProgress showMessageCenter:@"真实姓名不能为空" inView:self.view];
//        isNull = YES;
//        return isNull;
//    }
//    if (!(self.idView.text.length > 0)) {
//        [HxbHUDProgress showMessageCenter:@"身份证号不能为空" inView:self.view];
//        isNull = YES;
//        return isNull;
//    }
//    if(self.idView.text.length != 18)
//    {
//        [HxbHUDProgress showMessageCenter:@"身份证号输入有误" inView:self.view];
//        isNull = YES;
//        return isNull;
//    }
//
//    if (!(self.bankNoView.text.length > 0)) {
//        [HxbHUDProgress showMessageCenter:@"银行卡号不能为空" inView:self.view];
//        isNull = YES;
//        return isNull;
//    }
//    if (!(self.bankNoView.text.length >= 10 && self.bankNoView.text.length <= 31)) {
//        [HxbHUDProgress showMessageCenter:@"银行卡号输入有误" inView:self.view];
//        isNull = YES;
//        return isNull;
//    }
    return isNull;
}

#pragma mark - Action
/// 开通恒丰银行存管账户
- (void)bottomBtnClick {
    if ([self judgeIsTure]) return;

    [self.view endEditing:YES];

    NSString *username = [self.nameView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *idNo = [self.idView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *bankNo = [self.bankNoView.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    kWeakSelf
//    [self.viewModel openDepositoryWithUsrname:username idNo:idNo bankNo:bankNo resultBlock:^(BOOL isSuccess) {
//        if (isSuccess) {
//            HXBLazyCatAccountWebViewController *webVC = [HXBLazyCatAccountWebViewController new];
//            webVC.requestModel = weakSelf.viewModel.lazyCatReqModel;
//            [weakSelf.navigationController pushViewController:webVC animated:YES];
//        }
//    }];
}

/// 查看银行限额
- (void)checkBankLimit {
    kWeakSelf
//    HXBBankCardListViewController *bankCardListVC = [[HXBBankCardListViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bankCardListVC];
//    [weakSelf presentViewController:nav animated:YES completion:nil];
}

@end
