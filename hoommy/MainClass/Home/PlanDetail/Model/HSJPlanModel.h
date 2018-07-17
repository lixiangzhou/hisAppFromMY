//
//  HSJPlanModel.h
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJPlanModel : HSJBaseModel

@property (nonatomic, assign) BOOL allowAccess;
@property (nonatomic, copy) NSString *isRolePassed;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, assign) NSInteger contactId;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *cashType;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *quitRate;
@property (nonatomic, assign) BOOL showDiscount;
@property (nonatomic, copy) NSString *interestRate;
@property (nonatomic, assign) NSInteger totalExpectedRate;
/// 是否购买
@property (nonatomic, assign) BOOL hasBuy;
/// 万元年化收益
@property (nonatomic, copy) NSString *tenThousandExceptedIncome;
/// 财务状况
@property (nonatomic, copy) NSString *financeStatus;
/// 计划期限
@property (nonatomic,copy) NSString *lockPeriodStr;
/// 文案
@property (nonatomic, copy) NSString *tag;
///最终注册总金额
@property (nonatomic,copy) NSString *finishRatio;
/// 服务协议
@property (nonatomic, copy) NSString *contractUrl;
///当前时间 lockDay 销售期限(天)
@property (nonatomic,copy) NSString *currentTime;
/// 新手剩余额度
@property (nonatomic, copy) NSString *newbiePlanLeftAmount;
/// 预期收益计算值(100 的收益)新手产品计划收益
@property (nonatomic, copy) NSString *totalInterest;
/// 是否首次够买
@property (nonatomic, copy) NSString *isFirst;
/// 剩余可追加金额
@property (nonatomic, copy) NSString *userRemainAmount;
/// 新手购买额度
@property (nonatomic, copy) NSString *newbiePlanAmount;
/// 剩余可投
@property (nonatomic, copy) NSString *remainAmount;
/// 计划介绍
@property (nonatomic, copy) NSString *introduce;
/// 计划状态
@property (nonatomic, copy) NSString *unifyStatus;
/// 已获收益（累计赚取）
@property (nonatomic, copy) NSString *earnInterest;
/// 提前退出费率
@property (nonatomic, copy) NSString *quitRateAdvance;
/// 年利率 （新手产品基础利率也取此字段）
@property (nonatomic, copy) NSString *expectedRate;
/// 计划期限（锁定期）（新手产品为月时取此字段）
@property (nonatomic, copy) NSString *lockPeriod;
/// 单笔加入上线
@property (nonatomic, copy) NSString *singleMaxRegisterAmount;
/// 是否是新手计划(1:是新手 0:非新手)
@property (nonatomic, copy) NSString *novice;
/// 开始销售时间
@property (nonatomic, copy) NSString *beginSellingTime;
/// 月升STEPUP
@property (nonatomic, copy) NSString *financePlanType;
/// 最小注册金额
@property (nonatomic, copy) NSString *minRegisterAmount;
/// 进入锁定期时间
@property (nonatomic, copy) NSString *financeEndTime;
/// 销售期限(天)
@property (nonatomic, copy) NSString *salePeriod;
/// 补发开始时间
@property (nonatomic, copy) NSString *beginResellingTime;
/// 理财计划预定日志次数
@property (nonatomic, copy) NSString *rsvCount;
/// 优惠券加息利率
@property (nonatomic, copy) NSString *couponInterestRate;
/// 基础利率
@property (nonatomic, copy) NSString *baseInterestRate;
/// 锁定结束时间
@property (nonatomic, copy) NSString *endLockingTime;
/// 计入费率
@property (nonatomic, copy) NSString *buyInRate;
/// 计划 id
@property (nonatomic, copy) NSString *id;
/// 销售结束时间
@property (nonatomic, copy) NSString *endSellingTime;
/// 加息利率
@property (nonatomic, copy) NSString *extraInterestRate;
/// 计划名称
@property (nonatomic, copy) NSString *name;
/// 新手贴息收益率
@property (nonatomic, copy) NSString *subsidyInterestRate;
/// 可投资对象
@property (nonatomic, copy) NSString *productsJson;
/// 超出预期收益部分作为服务费
@property (nonatomic, copy) NSString *interestName;
/// 预定满额用时
@property (nonatomic, copy) NSString *fillTime;
/// 注册倍数金额
@property (nonatomic, copy) NSString *registerMultipleAmount;
/// 加入人次
@property (nonatomic, copy) NSString *joinCount;
/// 锁开始
@property (nonatomic,copy) NSString *lockStart;
/// 倒计时时间戳
@property (nonatomic, copy) NSString *diffTime;
// 还款方式
@property (nonatomic, copy) NSString *featuredSlogan;
/// 是否有可用抵扣券
@property (nonatomic, assign) BOOL hasDiscountCoupon;
/// 是否有可用满减券
@property (nonatomic, assign) BOOL hasMoneyOffCoupon;
/// 剩余天数
@property (nonatomic, assign) NSInteger lastDays;
/// 收益方式文案，文案规则：HXB返回：按月付息，INVEST返回：收益复投
@property (nonatomic, copy) NSString *incomeApproach;
/// 锁定期扩展
@property (nonatomic, copy) NSString *extendLockPeriod;
/// 冷静期
@property (nonatomic, assign) NSInteger coolingOffPeriod;
/// 默认退出方式
@property (nonatomic, copy) NSString *quitWayDefault;
/// 退出方式说明
@property (nonatomic, copy) NSString *quitWaysDesc;
/// 新手产品锁定期（天）
@property (nonatomic, assign) int lockDays;
@end
