//
//  HSJPlanAssetsModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJPlanAssetsModel : HSJBaseModel
/// 月升当前持有资产
@property (nonatomic, assign) CGFloat currentStepupAmount;
/// 月升可转出总额
@property (nonatomic, assign) CGFloat stepUpCanSaleAmount;
@end
