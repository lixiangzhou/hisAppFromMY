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
    //服务器错误
    kHXBCode_Enum_NoServerFaile = 500,
    //购买处理中
    kHXBPurchase_Processing = -999,
} HSJNetStateCode;


#endif /* HSJNetStateCode_h */
