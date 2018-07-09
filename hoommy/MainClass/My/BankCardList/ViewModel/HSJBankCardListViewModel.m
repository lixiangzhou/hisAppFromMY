//
//  HSJBankCardListViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBankCardListViewModel.h"
#import "HSJBankListModel.h"
@implementation HSJBankCardListViewModel

- (void)bankCardListRequestWithResultBlock: (void(^)(BOOL isSuccess))resultBlock
{
    kWeakSelf
    NYBaseRequest *alterLoginPasswordAPI = [[NYBaseRequest alloc] init];
//    alterLoginPasswordAPI.requestUrl = kHXBSetWithdrawals_banklistURL;
    alterLoginPasswordAPI.requestMethod = NYRequestMethodGet;
    //    alterLoginPasswordAPI.requestArgument = requestArgument;
    [alterLoginPasswordAPI loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        NSArray *bankArr = responseObject[@"data"][@"dataList"];
        [bankArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.bankListModels addObject:[[HSJBankListModel alloc] initWithDictionary:obj]];
        }];
        
        if (resultBlock) {
            resultBlock(YES);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        //        [HxbHUDProgress showTextWithMessage:@"请求失败"];
        if (resultBlock) {
            resultBlock(NO);
        }
    }];
}

- (NSMutableArray *)bankListModels
{
    if (!_bankListModels) {
        _bankListModels = [NSMutableArray array];
    }
    return _bankListModels;
}
@end
