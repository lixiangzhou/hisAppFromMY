//
//  HxbWithdrawViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbWithdrawViewController.h"
#import "HxbSecurityCertificationViewController.h"
#import "HxbWithdrawCardViewController.h"
#import "HxbWithdrawResultViewController.h"
#import "HXBVerificationCodeAlertVC.h"
#import "HXBCallPhone_BottomView.h"
#import "HXBMy_Withdraw_notifitionView.h"
#import "HXBWithdrawRecordViewController.h"
#import "HXBWithdrawModel.h"
#import "HXBBankCardModel.h"

#import "HXBAccountWithdrawViewModel.h"
#import "HXBRootVCManager.h"
@interface HxbWithdrawViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *amountTextField;
@property (nonatomic, strong) UIImageView *tipImage;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *availableBalanceLabel;
@property (nonatomic, strong) UILabel *freeTipLabel;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) WithdrawBankView *mybankView;

@property (nonatomic, strong) HXBCallPhone_BottomView *callPhoneView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *tiedCardLabel;
@property (nonatomic, strong) UILabel *reminderLabel;
@property (nonatomic, strong) HXBMy_Withdraw_notifitionView *notifitionView;

@property (nonatomic, strong) UIView *bottomView;
/**
 数据模型
 */
@property (nonatomic, strong) HXBWithdrawModel *withdrawModel;


@property (nonatomic, strong) HXBVerificationCodeAlertVC *alertVC;

@property (nonatomic, assign) BOOL isLoadBankCardSuccess;

@property (nonatomic, strong) HXBAccountWithdrawViewModel *viewModel;
@end

@implementation HxbWithdrawViewController


#pragma mark – Life Cycle(生命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    kWeakSelf
    _viewModel = [[HXBAccountWithdrawViewModel alloc] init];
    _viewModel.hugViewBlock = ^UIView *{
        if (weakSelf.presentedViewController) {
            return weakSelf.presentedViewController.view;
        }
        else {
            return weakSelf.view;
        }
    };
    
    self.view.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:self.notifitionView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.mybankView];
    [self.view addSubview:self.amountTextField];
    [self.view addSubview:self.tipImage];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.availableBalanceLabel];
    [self.view addSubview:self.freeTipLabel];
    [self.view addSubview:self.callPhoneView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.tiedCardLabel];
    [self.view addSubview:self.reminderLabel];
    [self.view addSubview:self.bottomView];
    [self setCardViewFrame];
    //增加提现记录的按钮
    [self setupRightBarBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 禁用全屏滑动手势
    NSInteger index = self.navigationController.viewControllers.count;
    UIViewController *VC = self.navigationController.viewControllers[index - 2];
    if ([VC isKindOfClass:NSClassFromString(@"HXBOpenDepositAccountViewController")] || [VC isKindOfClass:NSClassFromString(@"HxbWithdrawCardViewController")]) {
        ((HXBBaseNavigationController *)self.navigationController).enableFullScreenGesture = NO;
    }
    
    [self loadBankCard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 恢复全屏滑动手势
    ((HXBBaseNavigationController *)self.navigationController).enableFullScreenGesture = YES;
}


#pragma mark - Events

/**
 增加提现记录的按钮
 */
- (void)setupRightBarBtn {
    UIButton *cashRegisterBtn = [[UIButton alloc] init];
    [cashRegisterBtn setTitle:@"提现进度" forState:(UIControlStateNormal)];
    [cashRegisterBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cashRegisterBtn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
    [cashRegisterBtn addTarget:self action:@selector(pushCashRegisterVC) forControlEvents:(UIControlEventTouchUpInside)];
    [cashRegisterBtn sizeToFit];
    UIBarButtonItem *cashRegisterItem = [[UIBarButtonItem alloc] initWithCustomView:cashRegisterBtn];
    self.navigationItem.rightBarButtonItem = cashRegisterItem;
}

/**
 进入提现记录
 */
- (void)pushCashRegisterVC {
    [HXBUmengManagar HXB_clickEventWithEnevtId: kHSJUmeng_MyWithdrawCashRecordClick];
    HXBWithdrawRecordViewController *cashRegisterVC = [[HXBWithdrawRecordViewController alloc] init];
    [self.navigationController pushViewController:cashRegisterVC animated:YES];
}

- (void)setCardViewFrame{

    kWeakSelf
    [self.notifitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(HXBStatusBarAndNavigationBarHeight);
        make.height.offset(kScrAdaptationH750(0));
    }];
    
    [self.mybankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(20));
        make.right.equalTo(weakSelf.view).offset(kScrAdaptationW750(-20));
        make.top.equalTo(weakSelf.notifitionView.mas_bottom).offset(kScrAdaptationH750(30));
        make.height.offset(kScrAdaptationH750(160));
    }];
    
    [self.freeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScrAdaptationH750(30));
        make.top.equalTo(weakSelf.mybankView.mas_bottom).offset(kScrAdaptationH750(60));
        make.height.offset(kScrAdaptationH750(30));
        make.width.equalTo(@kScrAdaptationW750(220));
    }];
    
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.freeTipLabel.mas_bottom).offset(kScrAdaptationH750(37));
        make.left.equalTo(weakSelf.tipImage.mas_right).offset(kScrAdaptationW750(30));
        make.right.equalTo(weakSelf.view).offset(kScrAdaptationW750(-30));
        make.height.offset(kScrAdaptationH750(130));
    }];
    [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScrAdaptationH750(30));
        make.width.offset(kScrAdaptationW750(27));
        make.height.offset(kScrAdaptationH750(37));
        make.centerY.equalTo(weakSelf.amountTextField);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.amountTextField.mas_bottom).offset(kScrAdaptationH750(20));
        make.left.right.equalTo(weakSelf.mybankView);
        make.height.offset(kScrAdaptationH750(1));
    }];
    
    //可提金额
    [self.availableBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScrAdaptationW750(30));
        make.top.equalTo(weakSelf.backView.mas_bottom).offset(kScrAdaptationH750(20));
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.availableBalanceLabel.mas_bottom).offset(kScrAdaptationH750(116));
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
        make.right.equalTo(weakSelf.view).offset(kScrAdaptationW750(-40));
        make.height.offset(kScrAdaptationH750(82));
    }];
    
    [self.callPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(kScrAdaptationH750(-100));
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.callPhoneView.mas_top).offset(kScrAdaptationH750(-10));
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
        make.right.equalTo(weakSelf.view).offset(-kScrAdaptationW750(40));
    }];
    
    [self.tiedCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.promptLabel.mas_top).offset(kScrAdaptationH750(-10));
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
        make.right.equalTo(weakSelf.view).offset(-kScrAdaptationW750(40));
    }];
    
    [self.reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.tiedCardLabel.mas_top).offset(kScrAdaptationH750(-20));
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW750(40));
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@kScrAdaptationH750(202));
    }];
    
    self.callPhoneView.hidden = YES;
    self.promptLabel.hidden = YES;
    self.tiedCardLabel.hidden = YES;
    self.reminderLabel.hidden = YES;
}

- (void)withdrawals
{
    if (self.presentedViewController != self.alertVC) {
        self.alertVC = nil;
        [self presentViewController:self.alertVC animated:NO completion:nil];
    }
}

/**
 发送验证码
 */
- (void)withdrawSmscode
{
    kWeakSelf
    [self.viewModel getVerifyCodeRequesWithRechargeAmount:self.amountTextField.text andWithType:@"sms" andWithAction:@"withdraw" andCallbackBlock:^(BOOL isSuccess,NSError *error) {
        if (isSuccess) {
            [weakSelf withdrawals];
            [HXBUmengManagar HXB_clickEventWithEnevtId: kHSJUmeng_MyWithdrawCashCodeButtonClick];
            [weakSelf.alertVC.verificationCodeAlertView disEnabledBtns];
        }
        else {
            [weakSelf.alertVC.verificationCodeAlertView enabledBtns];
        }
    }];
}

#pragma mark --- 提现请求
- (void)checkWithdrawals:(NSString *)smscode
{
//    self.view.userInteractionEnabled = NO;
    kWeakSelf
    NSMutableDictionary *requestArgument  = [NSMutableDictionary dictionary];
    requestArgument[@"bankno"] = self.withdrawModel.bankCard.bankCode;
    requestArgument[@"city"] = self.withdrawModel.bankCard.city;
    requestArgument[@"bank"] = self.withdrawModel.bankCard.cardId;
    requestArgument[@"smscode"] = smscode;
    requestArgument[@"amount"] = self.amountTextField.text;
    [_viewModel accountWithdrawaWithParameter:requestArgument andRequestMethod:NYRequestMethodPost resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.alertVC dismissViewControllerAnimated:NO completion:nil];
            HxbWithdrawResultViewController *withdrawResultVC = [[HxbWithdrawResultViewController alloc]init];
            withdrawResultVC.bankCardModel = weakSelf.withdrawModel.bankCard;
            [weakSelf.navigationController pushViewController:withdrawResultVC animated:YES];
        }
    }];
}

- (void)nextButtonClick:(UIButton *)sender{
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSJUmeng_MyWithdrawCashClick];
    self.withdrawModel.bankCard.amount = self.amountTextField.text;
    if ([_amountTextField.text doubleValue] > self.withdrawModel.balanceAmount) {
        [HxbHUDProgress showTextWithMessage:@"余额不足"];
        return;
    }
    if ([_amountTextField.text doubleValue] < self.withdrawModel.minWithdrawAmount) {
        [HxbHUDProgress showTextWithMessage:[NSString stringWithFormat:@"最小提现金额为%d元",self.withdrawModel.minWithdrawAmount]];
        return;
    }
    [self withdrawSmscode];
    
}

//参数一：range,要被替换的字符串的range，如果是新键入的那么就没有字符串被替换，range.lenth=0,第二个参数：替换的字符串，即键盘即将键入或者即将粘贴到textfield的string
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (range.location == 0 && [string isEqualToString:@"0"]) return NO;
    if (range.location == 0 && [string isEqualToString:@"."]) return NO;
    NSString *str = nil;
    if (string.length) {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    } else if(!string.length) {
        NSInteger length = textField.text.length;
        NSRange range = NSMakeRange(length - 1, 1);
        NSMutableString *strM = textField.text.mutableCopy;
        if (range.location > 0 && range.location + range.length <= length) {
            [strM deleteCharactersInRange:range];
        }
        str = strM.copy;
    }
    if (str.length > 0 && self.isLoadBankCardSuccess) {
        _nextButton.backgroundColor = COR29;
        _nextButton.userInteractionEnabled = YES;
    } else {
        _nextButton.backgroundColor = COR12;
        _nextButton.userInteractionEnabled = NO;
    }
    if (range.location == 0 && [string isEqualToString:@""]) return YES;
    if (range.location == 11) return NO;
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [NSString checkBothDecimalPlaces:checkStr];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.amountTextField) {
        self.nextButton.backgroundColor = COR12;
        self.nextButton.userInteractionEnabled = NO;
    }
    return YES;
}

- (void)loadBankCard
{
    kWeakSelf
    [_viewModel accountWithdrawaWithParameter:nil andRequestMethod:NYRequestMethodGet resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.withdrawModel = weakSelf.viewModel.withdrawModel;
            weakSelf.isLoadBankCardSuccess = YES;
        }
        else {
            weakSelf.isLoadBankCardSuccess = NO;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)leftBackBtnClick
{
    NSInteger index = self.navigationController.viewControllers.count;
    UIViewController *VC = self.navigationController.viewControllers[index - 2];
    if ([VC isKindOfClass:NSClassFromString(@"HXBOpenDepositAccountViewController")] || [VC isKindOfClass:NSClassFromString(@"HxbWithdrawCardViewController")]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[index - 3] animated:YES];
    }else
    {
        [super leftBackBtnClick];
    }
}

#pragma mark - Setter
- (void)setWithdrawModel:(HXBWithdrawModel *)withdrawModel {
    _withdrawModel = withdrawModel;
    
    NSString *str = @"可提金额：";
    NSMutableAttributedString *info = [NSAttributedString setupAttributeStringWithString:str WithRange:NSMakeRange(0, str.length) andAttributeColor:RGB(146, 149, 162) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(24)];
    
    NSString *yuanStr = @"元";
    NSString *amount = [NSString hsj_simpleMoneyValue:withdrawModel.balanceAmount];
    NSAttributedString *info2 = [NSAttributedString setupAttributeStringWithBeforeString:amount  WithBeforeRange:NSMakeRange(0, amount.length) andAttributeColor:HXBC_Red_Light andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(24) afterString:yuanStr WithAfterRange:NSMakeRange(0, yuanStr.length) andAttributeColor:RGB(146, 149, 162) andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(24)];
    [info appendAttributedString:info2];
    self.availableBalanceLabel.attributedText = info;
    
    self.amountTextField.placeholder = [NSString stringWithFormat:@"最小提现金额为%d.00元",self.withdrawModel.minWithdrawAmount];
    self.mybankView.bankCardModel = withdrawModel.bankCard;
    if (withdrawModel.inprocessCount > 0) {
        self.notifitionView.hidden = NO;
        NSString *messageStr = [NSString stringWithFormat:@"您有%d条提现申请正在处理，点击查看",withdrawModel.inprocessCount];
        NSRange range = [messageStr rangeOfString:[NSString stringWithFormat:@"%d",withdrawModel.inprocessCount]];
        self.notifitionView.attributedMessageCount = [NSMutableAttributedString setupAttributeStringWithString:messageStr WithRange:(NSRange)range andAttributeColor:COR29 andAttributeFont:kHXBFont_PINGFANGSC_REGULAR_750(24)];
        [self.notifitionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScrAdaptationH750(70));
        }];
    } else {
        self.notifitionView.hidden = YES;
        [self.notifitionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kScrAdaptationH750(0));
        }];
    }
    
}

- (void)didClickHelp:(UIButton *)sender {
    [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"红小宝客服电话" Message:kServiceMobile];
}

#pragma mark - Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomView.userInteractionEnabled = YES;
        UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_bottomView addSubview:helpBtn];
        [helpBtn setImage:[UIImage imageNamed:@"my_help"] forState:UIControlStateNormal];
        [helpBtn setTitle:@"红小宝客服" forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(didClickHelp:) forControlEvents:UIControlEventTouchUpInside];
        helpBtn.layer.cornerRadius = kScrAdaptationH750(35);
        helpBtn.layer.masksToBounds = YES;
        helpBtn.layer.borderWidth = 1.0f;
        helpBtn.layer.borderColor = kHXBColor_7F85A1_60.CGColor;
        [helpBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [helpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0)];
        [helpBtn setTitleColor:RGB(127, 133, 161) forState:UIControlStateNormal];
        helpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [helpBtn.titleLabel setFont:kHXBFont_PINGFANGSC_REGULAR_750(24)];
        helpBtn.backgroundColor = kHXBColor_FFFFFF_100;
        
        [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_bottomView);
            make.width.equalTo(@kScrAdaptationW750(230));
            make.height.equalTo(@kScrAdaptationH750(70));
            make.bottom.offset(kScrAdaptationH750(-92));
        }];
        
        UILabel * lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setFont:kHXBFont_PINGFANGSC_REGULAR_750(20)];
        lab.textColor = RGB(127, 133, 161);
        lab.text = @"客服电话时间：工作日9:00-18:00";
        [_bottomView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_bottomView);
            make.width.equalTo(@kScrAdaptationW750(320));
            make.height.equalTo(@kScrAdaptationH750(28));
            make.bottom.offset(kScrAdaptationH750(-40));
        }];
    }
    return _bottomView;
}

- (WithdrawBankView *)mybankView{
    if (!_mybankView) {
        _mybankView = [[WithdrawBankView alloc]initWithFrame:CGRectZero];
        _mybankView.image = [UIImage imageNamed:@"AccountWithdraw_bg"];
    }
    return _mybankView;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COR12;
    }
    return _backView;
}

- (UITextField *)amountTextField{
    if (!_amountTextField) {
        _amountTextField = [[UITextField alloc] init];
//        _amountTextField.placeholder = [NSString stringWithFormat:@"提现金额不能小于%d",self.withdrawModel.minWithdrawAmount];
        _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _amountTextField.delegate = self;
        _amountTextField.font = kHXBFont_PINGFANGSC_REGULAR_750(40);
        _amountTextField.backgroundColor = [UIColor whiteColor];
        //        _amountTextField.font = kHXBFont_PINGFANGSC_REGULAR_750(30);
        _amountTextField.textColor = RGB(51, 51, 51);
    }
    return _amountTextField;
}

- (UIImageView *)tipImage{
    if(!_tipImage){
        _tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScrAdaptationW750(24), kScrAdaptationH750(37))];
        _tipImage.image = [UIImage imageNamed:@"hxb_my_message人民币"];
    }
    return _tipImage;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton btnwithTitle:@"提现" andTarget:self andAction:@selector(nextButtonClick:) andFrameByCategory:  CGRectMake(20,self.view.height - 100, kScreenWidth - 40,44)];
    }
    _nextButton.backgroundColor = COR12;
    _nextButton.userInteractionEnabled = NO;
    return _nextButton;
}

- (UILabel *)availableBalanceLabel
{
    if (!_availableBalanceLabel) {
        _availableBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.amountTextField.bottom + 20, 0, 0)];
        _availableBalanceLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _availableBalanceLabel.textColor = RGB(146, 149, 162);
        _availableBalanceLabel.text = @"可提金额：--";
    }
    return _availableBalanceLabel;
}

- (UILabel *)freeTipLabel
{
    if (!_freeTipLabel) {
        _freeTipLabel = [[UILabel alloc] init];
        _freeTipLabel.text = @"提现金额(元)";
        _freeTipLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(28);
        _freeTipLabel.textColor = kHXBColor_333333_100;
    }
    return _freeTipLabel;
}


- (HXBCallPhone_BottomView *)callPhoneView
{
    if (!_callPhoneView) {
        _callPhoneView = [[HXBCallPhone_BottomView alloc] init];
        _callPhoneView.leftTitle = @"3、如提现过程中有疑问，请联系客服：";
        _callPhoneView.phoneNumber = [NSString stringWithFormat:@"%@",kServiceMobile];
        //        _callPhoneView.supplementText = @"(周一至周五 9:00-19:00)";
    }
    return _callPhoneView;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"2、禁止洗钱、信用卡套现、虚假交易等行为，一经发现并确认，将终止该账户的使用；";
        _promptLabel.textColor = COR8;
        _promptLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UILabel *)tiedCardLabel
{
    if (!_tiedCardLabel) {
        _tiedCardLabel = [[UILabel alloc] init];
        _tiedCardLabel.text = @"1、预计到账时间为两个工作日，双休日和法定节假日顺延处理；";
        _tiedCardLabel.textColor = COR8;
        _tiedCardLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _tiedCardLabel.numberOfLines = 0;
    }
    return _tiedCardLabel;
}

- (UILabel *)reminderLabel
{
    if (!_reminderLabel) {
        _reminderLabel = [[UILabel alloc] init];
        _reminderLabel.text = @"温馨提示：";
        _reminderLabel.textColor = RGB(115, 173, 255);
        _reminderLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
    }
    return _reminderLabel;
}

- (HXBVerificationCodeAlertVC *)alertVC
{
    if (!_alertVC) {
        kWeakSelf
        _alertVC = [[HXBVerificationCodeAlertVC alloc] init];
        _alertVC.messageTitle = @"请输入短信验证码";
        _alertVC.subTitle = [NSString stringWithFormat:@"已发送到%@上，请查收",[self.withdrawModel.mobileNumber replaceStringWithStartLocation:3 lenght:self.withdrawModel.mobileNumber.length - 7]];
        _alertVC.sureBtnClick = ^(NSString *pwd){
            if (pwd.length == 0) {
                [HxbHUDProgress showTextWithMessage:@"密码不能为空"];
                return;
            }
            [weakSelf checkWithdrawals:pwd];
        };
        
        _alertVC.getVerificationCodeBlock = ^{
            [weakSelf.alertVC.verificationCodeAlertView enabledBtns];
            [weakSelf withdrawSmscode];
        };
    }
    return _alertVC;
}
- (HXBMy_Withdraw_notifitionView *)notifitionView {
    kWeakSelf
    if (!_notifitionView) {
        _notifitionView = [[HXBMy_Withdraw_notifitionView alloc] initWithFrame:CGRectZero];//CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScrAdaptationH750(70))
        _notifitionView.hidden = YES;
    }
    _notifitionView.block = ^{
        [weakSelf pushCashRegisterVC];
    };
//    _notifitionView.messageCount = @"qkkjsdhajkdhakjsdhk";
    return _notifitionView;
}

@end

@interface WithdrawBankView ()
@property (nonatomic, strong) UIImageView *bankLogoImageView;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *bankCardNumLabel;
@property (nonatomic, strong) UILabel *arrivalDateLabel;
@end

@implementation WithdrawBankView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bankLogoImageView];
        [self addSubview:self.bankNameLabel];
        [self addSubview:self.bankCardNumLabel];
        [self addSubview:self.arrivalDateLabel];
//        [self getpaymentDate];
        [self setContentViewFrame];
    }
    return self;
}

- (void)setBankCardModel:(HXBBankCardModel *)bankCardModel
{
    _bankCardModel = bankCardModel;
    self.bankNameLabel.text = self.bankCardModel.bankType;
    self.bankCardNumLabel.text = [NSString stringWithFormat:@"（尾号%@）",[self.bankCardModel.cardId substringFromIndex:self.bankCardModel.cardId.length - 4]];
    self.bankLogoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_white",self.bankCardModel.bankCode]];
    
    self.arrivalDateLabel.text = bankCardModel.bankArriveTimeText;
}


- (void)setContentViewFrame{
    [self.bankLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScrAdaptationW750(30));
        make.top.equalTo(self.mas_top).offset(kScrAdaptationH750(40));
        make.size.mas_equalTo(CGSizeMake(kScrAdaptationW750(80), kScrAdaptationH750(80)));
    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLogoImageView.mas_right).offset(kScrAdaptationW750(36));
        make.top.equalTo(self).offset(kScrAdaptationH750(44));
        make.height.offset(kScrAdaptationH750(28));
    }];
    [self.bankCardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNameLabel.mas_right);
        make.centerY.equalTo(self.bankNameLabel);
    }];
    [self.arrivalDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNameLabel.mas_left);
        make.top.equalTo(self.bankNameLabel.mas_bottom).offset(kScrAdaptationH750(20));
    }];
}
- (UILabel *)arrivalDateLabel
{
    if (!_arrivalDateLabel) {
        _arrivalDateLabel = [[UILabel alloc] init];
//        _arrivalDateLabel.text = [NSString stringWithFormat:@"预计%@(T+2工作日)到账",[[HXBBaseHandDate sharedHandleDate] stringFromDate:[NSDate date] andDateFormat:@"yyyy-MM-dd"]];
        _arrivalDateLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
        _arrivalDateLabel.textColor = kHXBColor_FFFFFF_100;
        _arrivalDateLabel.text = @"--";
    }
    return _arrivalDateLabel;
}
- (UIImageView *)bankLogoImageView{
    if (!_bankLogoImageView) {
        _bankLogoImageView = [[UIImageView alloc]init];
        _bankLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bankLogoImageView.image = [UIImage imageNamed:@"bank_default"];
    }
    return _bankLogoImageView;
}

- (UILabel *)bankNameLabel{
    if (!_bankNameLabel) {
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(30);
        _bankNameLabel.textColor = kHXBColor_FFFFFF_100;
        _bankNameLabel.text = @"--";
    }
    return _bankNameLabel;
}

- (UILabel *)bankCardNumLabel{
    if (!_bankCardNumLabel) {
        _bankCardNumLabel = [[UILabel alloc] init];
        _bankCardNumLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(30);
        _bankCardNumLabel.textColor = kHXBColor_FFFFFF_100;
    }
    return _bankCardNumLabel;
}



@end
