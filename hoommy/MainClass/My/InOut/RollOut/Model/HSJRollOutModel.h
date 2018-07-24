//
//  HSJRollOutModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

typedef enum : NSUInteger {
    /// QUIT: 可退出
    HSJStepUpStatusQUIT,
    /// NOQUIT: 不可退出
    HSJStepUpStatusNOQUIT,
    /// QUITING: 退出中
    HSJStepUpStatusQUITING,
} HSJStepUpStatus;

@interface HSJRollOutModel : HSJBaseModel

/// 计划ID
@property (nonatomic, copy) NSString *id;
/// 待转让金额
@property (nonatomic, copy) NSString *redProgressLeft;
/// 加入金额
@property (nonatomic, copy) NSString *finalAmount;
/// 加入金额 （账户内计划详情）
@property (nonatomic, copy) NSString *amount;
/// 已获收益 累计收益
@property (nonatomic, copy) NSString *earnAmount;
/// 加入时间
@property (nonatomic, copy) NSString *registerTime;
/// 退出日期
@property (nonatomic, copy) NSString *endLockingTime;
/// 预期收益
@property (nonatomic, copy) NSString *totalInterest;
/// 月升计划状态
@property (nonatomic, copy) NSString *stepUpPlanStatus;
/// 请求退出时间
@property (nonatomic, copy) NSString *endLockingRequestTime;

@end
