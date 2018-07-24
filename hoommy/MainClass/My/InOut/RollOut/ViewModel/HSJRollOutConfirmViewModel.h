//
//  HSJRollOutConfirmViewModel.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJRollOutConfirmModel.h"

@interface HSJRollOutConfirmViewModel : HSJBaseViewModel
@property (nonatomic, strong) HSJRollOutConfirmModel *model;
/// 转出金额
@property (nonatomic, copy) NSString *amountAndTotalEarnInterest;

/// 转出的确认信息
- (void)quitConfrim:(NSArray *)ids resultBlock:(void(^)(BOOL isSuccess))resultBlock;

/// 转出
- (void)quit:(NSArray *)ids smsCode:(NSString *)smsCode resultBlock:(void (^)(BOOL))resultBlock;

/// 短验
- (void)sendSms:(void(^)(BOOL isSuccess))resultBlock;
@end
