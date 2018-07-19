//
//  HSJPlanModel.h
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJPlanModel : HSJBaseModel

/// 是否购买
@property (nonatomic, assign) BOOL hasBuy;
/// 万元年化收益
@property (nonatomic, copy) NSString *tenThousandExceptedIncome;
/// 年利率 （新手产品基础利率也取此字段）
@property (nonatomic, copy) NSString *expectedRate;
/// 计划期限（锁定期）（新手产品为月时取此字段）
@property (nonatomic, copy) NSString *lockPeriod;
/// 是否是新手计划(1:是新手 0:非新手)
@property (nonatomic, copy) NSString *novice;
/// 进入锁定期时间
@property (nonatomic, copy) NSString *financeEndTime;
/// 基础利率
@property (nonatomic, copy) NSString *baseInterestRate;
/// 锁定结束时间
@property (nonatomic, copy) NSString *endLockingTime;
/// 计划 id
@property (nonatomic, copy) NSString *id;
/// 加息利率
@property (nonatomic, copy) NSString *extraInterestRate;
/// 计划名称
@property (nonatomic, copy) NSString *name;
/// 新手贴息收益率
@property (nonatomic, copy) NSString *subsidyInterestRate;
/// 新手产品锁定期（天）
@property (nonatomic, assign) int lockDays;
@end
