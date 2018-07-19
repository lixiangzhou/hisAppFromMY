//
//  HSJRollOutModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJRollOutModel : HSJBaseModel



/// 待转让金额
@property (nonatomic, copy) NSString *redProgressLeft;
/// 加入金额
@property (nonatomic, copy) NSString *finalAmount;
/// 状态（PURCHASE_END：锁定期，PURCHASEING：债转匹配中）, REDEMPTION_PERIOD: ‘开放期’,
@property (nonatomic, copy) NSString *status;
/// 已获收益 累计收益
@property (nonatomic, copy) NSString *earnAmount;
/// 加入时间
@property (nonatomic, copy) NSString *registerTime;
/// 实际退出日期
@property (nonatomic, copy) NSString *quitDate;
/// 预期收益
@property (nonatomic, copy) NSString *totalInterest;

@end
