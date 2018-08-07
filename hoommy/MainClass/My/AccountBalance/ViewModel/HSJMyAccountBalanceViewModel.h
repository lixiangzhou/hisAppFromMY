//
//  HSJMyAccountBalanceViewModel.h
//  hoommy
//
//  Created by hxb on 2018/7/30.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJBaseModel.h"

@class InprocessCountModel;

@interface HSJMyAccountBalanceViewModel : HSJBaseViewModel

@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;
@property (nonatomic, strong) InprocessCountModel *inprocessCountModel;
/// 提现处理中个数
- (void)accountWithdrawaProcessRequestMethod: (NYRequestMethod)requestMethod
                                 resultBlock: (void(^)(BOOL isSuccess))resultBlock;
@end

@interface InprocessCountModel : HSJBaseModel

@property (nonatomic, assign) NSUInteger inprocessCount;

@end
