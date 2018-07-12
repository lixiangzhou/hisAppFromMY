//
//  HSJNetWorkUrl.h
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#ifndef HSJNetWorkUrl_h
#define HSJNetWorkUrl_h

#define kHXBMY_VersionUpdateURL @"/update"//版本更新

//MARK: ======================= 协议 ==========================
//协议或合同名    端口号后链接    状态    账户内连接
#define kHXB_Negotiate_SginUPURL @"/agreement/signup"///《注册服务协议》
#define kHXB_Negotiate_CertificationURL @"/agreement/realname"///《红小宝认证服务协议》
#define kHXB_Negotiate_ServePlanURL @"/agreement/plan"///《红利智投服务协议书》
#define kHXB_Negotiate_ServePlanMonthURL @"/agreement/planMonth"///《按月付息服务协议书》
#define kHXB_Negotiate_ServePlan_AccountURL(productID) [NSString stringWithFormat: @"/acount/plan/%@/agreement",(productID)]///账户内服务协议 plan
#define kHXB_Negotiate_ServeMonthPlan_AccountURL(productID) [NSString stringWithFormat: @"/acount/planMonth/%@/agreement",(productID)]///账户内按月付息服务协议
#define kHXB_Negotiate_ServeLoan_AccountURL(productID) [NSString stringWithFormat: @"/acount/loan/%@/agreement/",(productID)]///账户内《借款协议》
#define kHXB_Negotiate_ServeLoanURL @"/agreement/loan"///《借款服务协议书》
#define kHXB_Negotiate_Anti_MoneyLaunderingURL @"/agreement/antimoney"///《反洗钱告知暨客户出借承诺书》
#define kHXB_Negotiate_LoanTruansferURL @"/agreement/debts"///《债权转让及受让协议》
#define kHXB_Negotiate_ServeCreditor_AccountURL(productID) [NSString stringWithFormat: @"/account/transfer/%@/agreement",(productID)]///账户内《债权转让及受让协议》
#define kHXB_Negotiate_depository @"/agreement/depository" ///《存管开户协议》
#define kHXB_Negotiate_thirdpart @"/agreement/thirdpart" ///《恒丰银行股份有限公司杭州分行网络交易资金账户三方协议》
#define kHXB_Negotiate_authorize @"/agreement/authorize" ///《红小宝平台授权协议》
#define kHXB_Negotiate_couponExchangeInstructionsUrl @"/discount/explain" ///优惠券使用说明

#define kHXB_Negotiate_AddTrustURL @"/landing/trust"///增信页
#define kHXB_Agreement_Hint @"/agreement/hint"//网络借贷协议书

//MARK: ======================= 用户 =======================
#define kHXBUser_UserInfoURL @"/account/info"///用户信息
#define kHXBUser_LoginURL @"/user/login"//登录
#define kHXBUser_SignUPURL @"/user/signup"//注册
#define HXBAccount_ForgotPasswordURL @"/forgot"///忘记密码
#define kHXBUser_checkCaptchaURL @"/checkCaptcha"///校验 图片验证码
#define kHXBUser_smscodeURL @"/verifycode/send"//@"/send/smscode"///发送短信接口
#define kHXBUser_CheckMobileURL @"/checkMobile"///校验手机号
#define kHXBUser_CheckExistMobileURL @"/checkExistMobile"///忘记密码校验手机号
#define kHXBUser_realnameURL @"/user/realname"///实名认证
#define kHXBUser_riskModifyScoreURL @"/user/riskModifyScore"///风险评测
#define kHXBUser_financialAdvisorURL @"/account/advisor" //获取理财顾问信息
#define kHXBUser_AccountInfoURL @"/account"///账户内数据总览

//MARK: ======================= 账户设置 =======================
#define kHXBSetUPAccount_MobifyPassword_LoginRequestURL @"/account/password"//修改登录密码
#define kHXBSetTransaction_MobifyPassword_CheckIdentityAuthURL @"/checkIdentityAuth"//修改交易密码--验证用户身份信息接口
#define kHXBSetTransaction_MobifyPassword_SendSmscodeURL @"/send/smscode/base"//修改交易密码--发送验证码
#define kHXBSetTransaction_MobifyPassword_CheckIdentitySmsURL @"/account/checkIdentitySms"//修改交易密码--校验身份证和短信接口

#define kHXBSetGesturePasswordRequest_CheckLoginPasswordURL @"/user/checkLoginPassword"//校验登录密码
#define kHXBSetTransaction_MobifyPassword_CashpwdEditURL @"/account/cashpwd/edit"//修改交易密码--修改交易密码接口w
#define kHXBSetTransaction_MobifyPhoneNumber_CashMobileEditURL @"/account/mobile"//修改手机号--修改手机号接口

#define kHXBUser_CheckExistMobileURL @"/checkExistMobile"///忘记密码校验手机号
#define kHXBUser_LoginURL @"/user/login"//登录

//MARK: ======================= 存管 ==========================
#define kHXBOpenDepositAccount_Escrow @"/user/escrow" //用户开通存管账户
#define kHXBUserInfo_UnbindBankCard @"/account/bankcard/unbind" // 解绑银行卡操作
#define kHXBUserInfo_BankCard @"/account/bankcard"//@"/account/user/card" //用户获取绑定银行卡信息
#define kHXBAccount_quickpay_smscode @"/account/smscode/" //代扣充值获取手机验证码
#define kHXBAccount_Bindcard @"/account/bindcard" //绑卡
#define kHXBUser_checkCardBin @"/user/checkCardBin" //卡bin校验




//MARK: ======================= 用户 =======================
#define kHXBUser_UserInfoURL @"/account/info"///用户信息




#define kHXBUser_signOutURL @"/logout" /// 登出



//MARK: ======================= 账户信息 =======================
#define kHXBUser_QuestionsURL           @"/questions"///常见问题



//MARK: ======================= 协议 ==========================
#define kHXB_Negotiate_thirdpart @"/agreement/thirdpart" ///《恒丰银行股份有限公司杭州分行网络交易资金账户三方协议》


#endif /* HSJNetWorkUrl_h */
