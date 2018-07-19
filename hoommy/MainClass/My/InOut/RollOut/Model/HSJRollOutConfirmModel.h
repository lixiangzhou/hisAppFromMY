//
//  HSJRollOutConfirmModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJRollOutConfirmModel : HSJBaseModel
/// 本金
@property (nonatomic, copy) NSString *amount;

/// 预期收益
@property (nonatomic, copy) NSString *totalEarnInterest;

/// 预计转出金额(本金+预期收益)
@property (nonatomic, copy) NSString *amountAndTotalEarnInterest;
@end
