//
//  HSJFinAddRecortdModel.h
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJFinAddRecortdModel : HSJBaseModel

@property (nonatomic,strong)NSString *amount; /// 投资金额
@property (nonatomic,strong)NSString *lendTime; ///投资时间
@property (nonatomic,strong)NSString *loanId; ///散标id
@property (nonatomic,strong)NSString *status; ///状态
@property (nonatomic,strong)NSString *ID;///

@property (nonatomic,strong)NSString *recoveryAmount; ///回收金额
@property (nonatomic,strong)NSString *recoveryInterest; ///已赚收益
@property (nonatomic,strong)NSString *rollOutleft; ///待转让金额
@property (nonatomic,strong)NSString *financePlanSubpointId; ///计划子账户id
@property (nonatomic,strong)NSString *tranfer; ///是否有转让记录

@end
