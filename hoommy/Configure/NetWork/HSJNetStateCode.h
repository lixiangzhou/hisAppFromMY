//
//  HSJNetStateCode.h
//  HXBCriterionProject
//
//  Created by caihongji on 2017/11/28.
//  Copyright © 2017年 caihongji. All rights reserved.
//
#ifndef HSJNetStateCode_h
#define HSJNetStateCode_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HSJNetStateCodeTokenNotJurisdiction = 401,
    // 如果网络层已经做了弹窗处理， 那么就会返回这个错误码
    HSJNetStateCodeAlreadyPopWindow = -100000,
    // 当封装多处使用的通用接口时， 如果state的值是非0值， 那么就以这个错误吗构建一个NSErro对象，回传给调用者
    HSJNetStateCodeCommonInterfaceErro = -200000,
    // 成功
    HSJNetStateCodeSuccess = 0,
    ///服务器时间与系统时间相差过大
    kHXBCode_Enum_RequestOverrun = 412,
    //开户或绑卡超过次数
    kHXBOpenAccount_Outnumber = 5068,
    // 解绑银行卡失败（跳结果页）
    kHXBCode_UnBindCardFail = 4002,
    ///Form错误处理字段
    kHXBCode_Enum_ProcessingField = 104,
    ///未登录
    kHXBCode_Enum_NotSigin = 402,
    /// token 单点登录
    kHXBCode_Enum_SingleLogin = 409,
    ///图验次数超限
    kHXBCode_Enum_CaptchaTransfinite = 411,
    //服务器错误
    kHXBCode_Enum_NoServerFaile = 500,
    //购买处理中
    kHXBPurchase_Processing = -999,
} HSJNetStateCode;

typedef enum : NSUInteger {
    kBuy_Toast = 10001,
    kBuy_Result = 10002,
    kBuy_Processing = 10003,
} KHXBBuy_Code;

/**
 友盟统计码
 */
///首页
static NSString *const kHSJUmeng_HomeTabClick = @"2001";
static NSString *const kHSHUmeng_HomeNoticeClick = @"2002";
static NSString *const kHSHUmeng_HomeSignupClick = @"2003";
static NSString *const kHSHUmeng_HomeSignupPlanClick = @"2005";
static NSString *const kHSHUmeng_HomeSafeClick = @"2006";
static NSString *const kHSHUmeng_HomeBankClick = @"2007";
static NSString *const kHSHUmeng_HomeCreditClick = @"2008";
static NSString *const kHSHUmeng_HomeRegisteredCapitalClick = @"2009";
static NSString *const kHSHUmeng_HomeSignInPlanClick = @"2010";

///详情页面
static NSString *const kHSHUmeng_DetailBackClick = @"2012";
static NSString *const kHSHUmeng_DetailUnBuyInClick = @"2013";
static NSString *const kHSHUmeng_DetailUnBuyCalculatorClick = @"2014";
static NSString *const kHSHUmeng_DetailHasBuyInClick = @"2015";
static NSString *const kHSHUmeng_DetailHasBuyOutClick = @"2016";
static NSString *const kHSHUmeng_DetailHasBuyCalculatorClick = @"2017";

///开户页
static NSString *const kHSHUmeng_DepositoryTipOpenClick = @"2033";
static NSString *const kHSHUmeng_DepositoryTipCloseClick = @"2034";
static NSString *const kHSHUmeng_DepositoryBackClick = @"2035";
static NSString *const kHSHUmeng_DepositoryNameTextFieldClick = @"2036";
static NSString *const kHSHUmeng_DepositoryIDTextFieldClick = @"2037";
static NSString *const kHSHUmeng_DepositoryTransactionPwdTextFieldClick = @"2038";
static NSString *const kHSHUmeng_DepositoryBankNoTextFieldClick = @"2039";
static NSString *const kHSHUmeng_DepositoryMobileTextFieldClick = @"2040";
static NSString *const kHSHUmeng_DepositoryBankListClick = @"2041";
static NSString *const kHSHUmeng_DepositoryOpenClick = @"2042";

#endif /* HSJNetStateCode_h */
