//
//  HXBModifyTransactionPasswordAgent.m
//  hoomxb
//
//  Created by caihongji on 2018/2/6.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBModifyTransactionPasswordAgent.h"


@implementation HXBModifyTransactionPasswordAgent

+ (void)modifyTransactionPasswordWithRequestBlock:(void(^)(NYBaseRequest *request))requestBlock resultBlock:(void (^)(BOOL isSuccess, NSError *error))resultBlock
{
    NYBaseRequest *request = [[NYBaseRequest alloc] init];
    request.requestMethod = NYRequestMethodPost;
    if (requestBlock) {
        requestBlock(request);
    }
    
    [request loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        if (resultBlock) {
            resultBlock(YES, nil);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if(request.responseObject){
            error = [NSError errorWithDomain:@"" code:kHXBCode_CommonInterfaceErro userInfo:request.responseObject];
        }
        if (resultBlock) {
            resultBlock(NO, error);
        }
    }];
}

/**
 获取银行卡信息
 
 @param requestBlock 返回请求
 @param resultBlock 返回数据
 */
+ (void)bankCardInfoWithRequestBlock:(void(^)(NYBaseRequest* request)) requestBlock
                         ResultBlock:(void(^)(HXBBankCardModel *viewModel, NSError *error))resultBlock {
    NYBaseRequest *request = [[NYBaseRequest alloc] init];
    request.requestMethod = NYRequestMethodGet;
    request.requestUrl = kHXBUserInfo_BankCard;
    request.showHud = YES;
    if (requestBlock) {
        requestBlock(request);
    }
    [request loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        NSDictionary *data = responseObject[kResponseData];
        HXBBankCardModel *viewModel = [[HXBBankCardModel alloc] init];
        [viewModel yy_modelSetWithDictionary:data];
        if (resultBlock) resultBlock(viewModel, nil);
    } failure:^(NYBaseRequest *request, NSError *error) {
        if(request.responseObject) {
            error = [NSError errorWithDomain:@"" code:kHXBCode_CommonInterfaceErro userInfo:request.responseObject];
        }
        if (resultBlock) resultBlock(nil, error);
    }];
}

@end
