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
#define kHXBSplash            @"/splash"///闪屏接口
#define kHXBHome_PopView @"/popups"///首页弹窗
#define kGlobal                 @"/global" /// 全局统计
#define kHSJHomeBaby            @"/home/baby" /// 全局统计

//MARK: ======================= 协议 ==========================
//协议或合同名    端口号后链接    状态    账户内连接
#define kHXB_Negotiate_SginUPURL @"/agreement/babygoSignup"///《注册服务协议》
#define kHXB_Negotiate_ServePlanURL @"/agreement/plan"///《月升服务协议书》
#define kHXB_Agreement_Hint @"/agreement/hint"//网络借贷协议书
#define kHXB_Negotiate_ServePlan_AccountURL(productID) [NSString stringWithFormat: @"/acount/planRise/%@/agreement",(productID)]//我的月升服务协议

#define kHXB_Negotiate_CertificationURL @"/agreement/realname"///《红小宝认证服务协议》
#define kHXB_Negotiate_ServePlanMonthURL @"/agreement/planMonth"///《按月付息服务协议书》
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

//MARK: ======================= 用户 =======================
#define kHXBUser_UserInfoURL @"/account/info"///用户信息
#define kHXBUser_LoginURL @"/user/login"//登录
#define kHXBUser_SignUPURL @"/user/signup"//注册
#define kHXBUser_CaptchaURL @"/captcha"//获取图验
#define HXBAccount_ForgotPasswordURL @"/forgot"///忘记密码
#define kHXBUser_checkCaptchaURL @"/checkCaptcha"///校验 图片验证码
#define kHXBUser_smscodeURL @"/verifycode/send"//@"/send/smscode"///发送短信接口
#define kHXBUser_CheckMobileURL @"/checkMobile"///校验手机号
#define kHXBUser_CheckMobileExistURL @"/checkMobileExist"///校验手机号是否注册
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


#define kHXBMY_PlanAccountRequestURL @"/account/planAssets"///账户内 账户内Plan资产
#define kHXBMY_PlanListURL @"/account/plan"//账户内  planlist
#define kHXBMY_PlanDetaileURL(planID) [NSString stringWithFormat:@"/account/plan/%@",(planID)]
#define kHXBMY_LoanRecordURL(planID) [NSString stringWithFormat:@"/account/plan/%@/loanRecord",(planID)] ///我的计划投标记录
#define kHXBMY_PlanQuit @"/account/plan/quit"

#define kHXBHome_AnnounceURL @"/announce"//公告

//MARK: ======================= 存管 ==========================
#define kHXBOpenDepositAccount_Escrow @"/user/escrow" //用户开通存管账户
#define kHXBUserInfo_UnbindBankCard @"/account/bankcard/unbind" // 解绑银行卡操作
#define kHXBUserInfo_BankCard @"/account/bankcard"//@"/account/user/card" //用户获取绑定银行卡信息
#define kHXBAccount_quickpay_smscode @"/account/smscode/" //代扣充值获取手机验证码
#define kHXBAccount_Bindcard @"/account/bindcard" //绑卡
#define kHXBUser_checkCardBin @"/user/checkCardBin" //卡bin校验
#define kHXBWithdraw @"/account/withdraw" //提现页面
#define kHXBAccount_quickpay @"/account/quickpay" //代扣充值接口 短验和语音统一为一个借口

//MARK: ======================= 充值提现 =======================
#define kHXBSetWithdrawals_withdrawURL   @"/account/withdraw"//提现
#define kHXBSetWithdrawals_withdrawProcessURL   @"/account/withdraw/process"//提现处理的个数
#define kHXBSetWithdrawals_banklistURL   @"/banklist"//提现
#define kHXBSetWithdrawals_withdrawArriveTimeURL   @"/account/withdraw/arriveTime"//到账时间
#define kHXBSetWithdrawals_recordtURL    @"/account/withdraw/record"//提现记录


//MARK: ======================= 用户 =======================
#define kHXBMY_CapitalRecordURL @"/account/tradlist"///交易记录

#define kHXBFinanc_PlanDetaileURL(planID) [NSString stringWithFormat:@"/plan/%ld",(planID)]///计划详情

#define kHXBUser_signOutURL @"/logout" /// 登出



//MARK: ======================= 账户信息 =======================
#define kHXBUser_QuestionsURL           @"/baby/questions"///常见问题

//MARK: ======================= H5 =======================
#define kHXBH5_RiskEvaluationURL [NSString stringWithFormat:@"%@/account/risk",[KeyChain h5host]]//风险评测
#define kHXBH5_BuyPlanRangeURL(planId) [NSString stringWithFormat:@"%@/plan/%@/range",[KeyChain h5host], planId]//投资范围

//MARK: ======================= 协议 ==========================
#define kHXB_Negotiate_thirdpart @"/agreement/thirdpart" ///《恒丰银行股份有限公司杭州分行网络交易资金账户三方协议》

//MARK: ======================= 购买 ==========================
#define kHXBFin_Plan_ConfirmBuyReslutURL(planID) [NSString stringWithFormat:@"/plan/%@/result",(planID)]//确认购买

#endif /* HSJNetWorkUrl_h */
