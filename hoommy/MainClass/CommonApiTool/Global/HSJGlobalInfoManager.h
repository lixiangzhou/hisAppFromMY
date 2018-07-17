//
//  HSJGlobalInfoManager.h
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJBaseViewModel.h"
#import "HSJGlobalInfoModel.h"

@interface HSJGlobalInfoManager : HSJBaseViewModel

@property (nonatomic, strong) HSJGlobalInfoModel *infoModel;

+ (instancetype)shared;
/// 获取全局数据，一般不用调用此方法，直接使用 infoModel 属性即可，
/// 如果 resultBlock 有值，infoModel 会在 resultBlock 返回，
/// 如果没有值，可以通过属性 infoModel 获取
- (void)getData:(void (^)(HSJGlobalInfoModel *infoModel))resultBlock;

/// 相当于 [self getData:nil]
- (void)getData;
@end
