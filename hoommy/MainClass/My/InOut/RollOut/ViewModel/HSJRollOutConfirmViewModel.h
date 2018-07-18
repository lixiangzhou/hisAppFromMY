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

- (void)quitConfrim:(NSArray *)ids resultBlock:(void(^)(BOOL isSuccess))resultBlock;

- (void)quit:(NSArray *)ids smsCode:(NSString *)smsCode resultBlock:(void (^)(BOOL))resultBlock;
@end
