//
//  HSJMyAccountBalanceViewModel.m
//  hoommy
//
//  Created by hxb on 2018/7/30.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyAccountBalanceViewModel.h"

@implementation HSJMyAccountBalanceViewModel

- (void)accountWithdrawaProcessRequestMethod: (NYRequestMethod)requestMethod
                          resultBlock: (void(^)(BOOL isSuccess))resultBlock {
    NYBaseRequest *request = [[NYBaseRequest alloc] initWithDelegate:self];
    request.requestUrl = kHXBSetWithdrawals_withdrawProcessURL;
    request.requestMethod = requestMethod;
    request.showHud = NO;
    kWeakSelf
    [request loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        weakSelf.inprocessCountModel = [[InprocessCountModel alloc] initWithDictionary:responseObject[@"data"]];
        if (resultBlock) resultBlock(YES);
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) resultBlock(NO);
    }];
}

@end


@implementation InprocessCountModel

@end
