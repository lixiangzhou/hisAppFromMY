//
//  HSJHomePlanModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJHomePlanModel : HSJBaseModel
/**
 视图类型
 */
@property (nonatomic, copy) NSString *viewItemType;
/**
  基础利率
 */
@property (nonatomic, copy) NSString *baseInterestRate;
/**
 开始销售时间
 */
@property (nonatomic, copy) NSString *beginSellingTime;
/**
 计划类型复投，提现
 */
@property (nonatomic, copy) NSString *cashType;
/**
 年化利率
 */
@property (nonatomic, copy) NSString *expectedRate;
/**
 加息利率
 */
@property (nonatomic, assign) float extraInterestRate;
/**
 计划类型月升 STEPUP
 */
@property (nonatomic, copy) NSString *financePlanType;
/**
 计划 Id
 */
@property (nonatomic, copy) NSString *ID;
/**
  锁定期限(月),计划期限
 */
@property (nonatomic, copy) NSString *lockPeriod;

/**
 新手的锁定期
 */
@property (nonatomic, copy) NSString *lockDays;

/**
 最小购买金额
 */
@property (nonatomic, assign) float minRegisterAmount;
/**
 计划名称
 */
@property (nonatomic, copy) NSString *name;
/**
  是否有可用抵扣券
 */
@property (nonatomic, assign) BOOL hasDiscountCoupon;
/**
 是否有可用满减券
 */
@property (nonatomic, assign) BOOL hasMoneyOffCoupon;
/**
 贴息收益率
 */
@property (nonatomic, assign) float subsidyInterestRate;
/**
 运营文案
 */
@property (nonatomic, copy) NSString *tag;
/**
 万元每天收益(月升))
 */
@property (nonatomic, copy) NSString *tenThousandExceptedIncome;
/**
 计划状态
 */
@property (nonatomic, copy) NSString *unifyStatus;
/**
 倒计时时间戳
 */
@property (nonatomic, assign) double diffTime;
/**
 按月提取/收益复投
 */
@property (nonatomic, copy) NSString *featuredSlogan;

//--------------------------- signuph5 和 h5 ----------------------

/**
 link
 */
@property (nonatomic, copy) NSString *link;
/**
 跳转类型
 */
@property (nonatomic, copy) NSString *type;
/**
 title
 */
@property (nonatomic, copy) NSString *title;

/**
 图片地址
 */
@property (nonatomic, copy) NSString *image;

/**
 cell的高度
 */
@property (nonatomic, assign) float cellHeight;

@end
