//
//  HSJGlobalInfoModel.h
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJGlobalInfoModel : HSJBaseModel

/// 最后更新日期
@property (nonatomic, copy) NSString *lastCacheTime;

/// 近７日加入计划的人数
@property (nonatomic, assign) NSInteger financePlanSubPointCountIn7Days;

/// 近７日计划的累计收益
@property (nonatomic, assign) CGFloat financePlanEarnInterestIn7Days;

/// 近７日月升的人数
@property (nonatomic, assign) NSInteger stepupPlanSubPointCountIn7Days;

/// 近７日月升的累计收益
@property (nonatomic, assign) CGFloat stepupPlanEarnInterestIn7Days;

/// 债权成交总金额
@property (nonatomic, assign) CGFloat loanTransactionAmount;

/// 债权成交总笔数
@property (nonatomic, assign) NSInteger loanTransactionCount;

/// 债权转让累计转出总金额
@property (nonatomic, assign) CGFloat transferTransactionAmount;

/// 债权转让累计成交总笔数
@property (nonatomic, assign) NSInteger transferTransactionCount;

/// 债权转让平均耗时（秒）
@property (nonatomic, assign) CGFloat transferTime;

/// 计划累计购买总金额
@property (nonatomic, assign) NSInteger financePlanSumAmount;

/// 计划加入总人次
@property (nonatomic, assign) NSInteger financePlanBuyerRecordsCount;

/// 计划加入总人数
@property (nonatomic, assign) NSInteger financePlanSubPointCount;

/// 计划为用户累计赚取收益
@property (nonatomic, assign) CGFloat financePlanEarnInterest;

/**
 累计成交金额单位
 */
@property (nonatomic, copy) NSString *financePlanSumAmountTextUnit;

/**
 累计成交金额
 */
@property (nonatomic, copy) NSString *financePlanSumAmountText;

/**
 为用户赚取金额单位
 */
@property (nonatomic, copy) NSString *financePlanEarnInterestTextUnit;

/**
 为用户赚取金额
 */
@property (nonatomic, copy) NSString *financePlanEarnInterestText;
@end
