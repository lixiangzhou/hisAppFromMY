//
//  HxbSecurityCertificationView.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/3.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbSecurityCertificationView.h"
#import "HXBSecurityCertificationViewModel.h"
@interface HxbSecurityCertificationView()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *identityCardNumTextField;
@property (nonatomic, strong) UITextField *payPasswordTextField;
//@property (nonatomic, strong) UITextField *payPasswordConfirmTextField;
@property (nonatomic, strong) UIButton *securityCertificationButton;
@property (nonatomic, strong) UIButton *hidePwdBtn;
/**安全认证 点击了下一步按钮*/
@property (nonatomic,copy) void(^clickNextButtonBlock)(NSString *name, NSString *idCard, NSString *transactionPassword,NSString *url);
@property (nonatomic, strong)HXBSecurityCertificationViewModel *viewModel;
/**
 url
 */
@property (nonatomic, copy) NSString *url;
@end

@implementation HxbSecurityCertificationView



//- (void)setUserInfoViewModel:(HXBRequestUserInfoViewModel *)userInfoViewModel
//{
//    _userInfoViewModel = userInfoViewModel;
//    if ([userInfoViewModel.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"]) {
//        self.nameTextField.text = [userInfoViewModel.userInfoModel.userInfo.realName replaceStringWithStartLocation:0 lenght:userInfoViewModel.userInfoModel.userInfo.realName.length - 1];
//        
//        self.identityCardNumTextField.text =  [userInfoViewModel.userInfoModel.userInfo.idNo replaceStringWithStartLocation:3 lenght:userInfoViewModel.userInfoModel.userInfo.idNo.length - 3];
//    }
//    if ([userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"]) {
//        self.payPasswordTextField.secureTextEntry = NO;
//        self.payPasswordTextField.text = @"已设置";
//        self.hidePwdBtn.hidden = YES;
//    }
//    if ([userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"] && [userInfoViewModel.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"]) {
//        self.securityCertificationButton.hidden = YES;
//    }
//}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameTextField];
        [self addSubview:self.identityCardNumTextField];
        [self addSubview:self.payPasswordTextField];
//        [self addSubview:self.payPasswordConfirmTextField];
        [self addSubview:self.securityCertificationButton];
        [self addSubview:self.hidePwdBtn];
        kWeakSelf
        self.viewModel = [[HXBSecurityCertificationViewModel alloc] init];
        [self setModel];
    }
    return self;
}

- (void)setModel{
    kWeakSelf
    [self.viewModel downLoadUserInfo:YES resultBlock:^(id responseData, NSError *erro) {
        if (!erro) {
            weakSelf.userInfoViewModel = responseData;
            if ([weakSelf.userInfoViewModel.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"]) {
                weakSelf.nameTextField.text = [weakSelf.userInfoViewModel.userInfoModel.userInfo.realName replaceStringWithStartLocation:0 lenght:weakSelf.userInfoViewModel.userInfoModel.userInfo.realName.length - 1];
                weakSelf.identityCardNumTextField.text =  [weakSelf.userInfoViewModel.userInfoModel.userInfo.idNo replaceStringWithStartLocation:1 lenght:weakSelf.userInfoViewModel.userInfoModel.userInfo.idNo.length - 2];
                weakSelf.nameTextField.enabled = NO;
                weakSelf.identityCardNumTextField.enabled = NO;
            }
            if ([weakSelf.userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"]) {
                weakSelf.payPasswordTextField.secureTextEntry = NO;
                weakSelf.payPasswordTextField.text = @"已设置";
                weakSelf.payPasswordTextField.enabled = NO;
                weakSelf.hidePwdBtn.hidden = YES;
            }
            if ([weakSelf.userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"] && [weakSelf.userInfoViewModel.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"]) {
                weakSelf.securityCertificationButton.hidden = YES;
            }
            [weakSelf judgeURL];
        }
    }];
}

- (void)judgeURL
{
    ///    是否实名
    BOOL isIdPassed = [self.userInfoViewModel.userInfoModel.userInfo.isIdPassed isEqualToString:@"1"];
    ///    是否有交易密码
    BOOL isCashPasswordPassed = [self.userInfoViewModel.userInfoModel.userInfo.isCashPasswordPassed isEqualToString:@"1"];
    if (isIdPassed && (!isCashPasswordPassed)) {
        self.url = @"/account/tradCashPwd";
    }else if ((!isIdPassed) && isCashPasswordPassed){
        self.url =  @"/account/authentication";
    }else if ((!isIdPassed) && (!isCashPasswordPassed)){
        self.url = @"/user/realname";
    }else
    {
        self.url = @"/user/realname";
    }
}

- (void)securityCertificationButtonClick:(UIButton *)sender{

        if (_identityCardNumTextField.text.length == 0|| _nameTextField.text.length == 0 || _payPasswordTextField.text.length == 0 ) {
            return [HxbHUDProgress showTextWithMessage:@"不能有空"];
        }
//        if (![NSString validateIDCardNumber:_identityCardNumTextField.text]) {
//            return [HxbHUDProgress showTextWithMessage:@"请输入正确的身份证号"];
//        }
    if (![_payPasswordTextField.text isEqualToString:@"已设置"]) {
        NSString * message = [NSString isOrNoPasswordStyle:_payPasswordTextField.text];
        if (message.length > 0) {
            [HxbHUDProgress showTextWithMessage:message];
            return;
        }
    }
    
//        if (![_payPasswordTextField.text isEqualToString:_payPasswordConfirmTextField.text]) {
//             return [HxbHUDProgress showTextWithMessage:@"两次输入的密码不一致"];
//        }
//        [KeyChain setRealName:_nameTextField.text];
//        [KeyChain setRealId:_identityCardNumTextField.text];
//        [KeyChain setTradePwd:_payPasswordConfirmTextField.text];
        ///点击了安全认证按钮
        if (self.clickNextButtonBlock) {
            self.clickNextButtonBlock(self.nameTextField.text, self.identityCardNumTextField.text, self.payPasswordTextField.text,self.url);
        }
}


- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [UITextField hxb_lineTextFieldWithFrame:CGRectMake(20, 64+44, kScreenWidth - 40, 44)];
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,70, 44)];
        leftLable.text = @"姓名";
        leftLable.textColor = COR1;
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.delegate = self;
        _nameTextField.leftView = leftLable;
        _nameTextField.returnKeyType = UIReturnKeyNext;
    }
    return _nameTextField;
}

- (UITextField *)identityCardNumTextField{
    if (!_identityCardNumTextField) {
        _identityCardNumTextField = [UITextField hxb_lineTextFieldWithFrame:CGRectMake(20, CGRectGetMaxY(_nameTextField.frame) + 60, kScreenWidth - 40, 44)];
        //        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,70, 44)];
        leftLable.text = @"身份证号";
        leftLable.textColor = COR1;
        _identityCardNumTextField.leftViewMode = UITextFieldViewModeAlways;
        _identityCardNumTextField.delegate = self;
        _identityCardNumTextField.leftView = leftLable;
        _identityCardNumTextField.returnKeyType = UIReturnKeyNext;
    }
    return _identityCardNumTextField;
}

- (UITextField *)payPasswordTextField{
    if (!_payPasswordTextField) {
        _payPasswordTextField = [UITextField hxb_lineTextFieldWithFrame:CGRectMake(20, CGRectGetMaxY(_identityCardNumTextField.frame) + 60, kScreenWidth - 40, 44)];
        //        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,70, 44)];
        leftLable.text = @"交易密码";
        leftLable.textColor = COR1;
        _payPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        _payPasswordTextField.delegate = self;
        _payPasswordTextField.leftView = leftLable;
        _payPasswordTextField.returnKeyType = UIReturnKeyNext;
        _payPasswordTextField.secureTextEntry = YES;
        
    }
    return _payPasswordTextField;
}

- (UIButton *)hidePwdBtn
{
    if (!_hidePwdBtn) {
        _hidePwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_identityCardNumTextField.frame) + 60, 40, 40)];
        _hidePwdBtn.backgroundColor = [UIColor redColor];
        [_hidePwdBtn addTarget:self action:@selector(hidePwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _hidePwdBtn.enabled = YES;
    }
    return _hidePwdBtn;
}

- (void)hidePwdBtnClick
{
    self.payPasswordTextField.secureTextEntry = self.hidePwdBtn.selected;
    self.hidePwdBtn.selected = !self.hidePwdBtn.selected;
}

//- (UITextField *)payPasswordConfirmTextField{
//    if (!_payPasswordConfirmTextField)
//    {
//        _payPasswordConfirmTextField = [UITextField hxb_lineTextFieldWithFrame:CGRectMake(20, CGRectGetMaxY(_payPasswordTextField.frame) + 60, SCREEN_WIDTH - 40, 44)];
//        //        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,120, 44)];
//        leftLable.text = @"确认交易密码";
//        leftLable.textColor = COR1;
//        _payPasswordConfirmTextField.leftViewMode = UITextFieldViewModeAlways;
//        _payPasswordConfirmTextField.delegate = self;
//        _payPasswordConfirmTextField.leftView = leftLable;
//        _payPasswordConfirmTextField.returnKeyType = UIReturnKeyDone;
//    }
//    return _payPasswordConfirmTextField;
//}

- (UIButton *)securityCertificationButton{
    if (!_securityCertificationButton) {
        _securityCertificationButton = [UIButton btnwithTitle:@"安全认证" andTarget:self andAction:@selector(securityCertificationButtonClick:) andFrameByCategory:CGRectMake(20, CGRectGetMaxY(_payPasswordTextField.frame) + 60, kScreenWidth - 40, 44)];
    }
    return _securityCertificationButton;
}

///点击了 下一步按钮
- (void)clickNextButtonFuncWithBlock: (void(^)(NSString *name, NSString *idCard, NSString *transactionPassword,NSString *url))clickNextButtonBlock {
    self.clickNextButtonBlock = clickNextButtonBlock;
}


#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string.length) {
        return YES;
    }
    if ([textField isEqual:self.identityCardNumTextField]) {
        return textField.text.length < 18;
    }
    return YES;
}



@end
