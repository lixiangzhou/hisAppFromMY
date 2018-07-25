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
 code 码
 */
static NSString *const kHXBUmeng_loginToRegist = @"1000";
static NSString *const kHXBUmeng_registFirst = @"1001";
static NSString *const kHXBUmeng_registSuccess = @"1002";
static NSString *const kHXBUmeng_registSuccess_lead = @"1003";
static NSString *const kHXBUmeng_registSuccess_return = @"1004";
static NSString *const kHXBUmeng_alertBtn = @"1005";
static NSString *const kHXBUmeng_commitBtn = @"1006";
static NSString *const kHXBUmeng_topup_money = @"1007";
static NSString *const kHXBUmeng_withdraw_money = @"1008";
static NSString *const kHXBUmeng_invite_entrance = @"1009";
static NSString *const kHXBUmeng_invite_alert = @"1010";
static NSString *const kHXBUmeng_invite_weChat = @"1011";
static NSString *const kHXBUmeng_invite_friendCircle = @"1012";
static NSString *const kHXBUmeng_invite_QQ = @"1013";
static NSString *const kHXBUmeng_invite_QQSpace = @"1014";
static NSString *const kHXBUmeng_investSucess_seeResult = @"1015";
static NSString *const kHXBUmeng_inviteSucess_share = @"1016";

#endif /* HSJNetStateCode_h */
