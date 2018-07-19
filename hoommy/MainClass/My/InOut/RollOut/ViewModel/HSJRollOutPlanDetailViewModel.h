//
//  HSJRollOutPlanDetailViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJRollOutModel.h"

@interface HSJRollOutPlanDetailViewModel : HSJBaseViewModel
@property (nonatomic, strong) HSJRollOutModel *model;

@property (nonatomic, strong) NSArray *dataSource;
@end
