//
//  HSJMyViewVCViewModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/12.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewVCViewModel.h"
#import "YYModel.h"

@implementation HSJMyViewVCViewModel

- (void)downLoadAccountInfo:(void (^)(BOOL isSuccess))completion {
    
    NYBaseRequest *accountInfoAPI = [[NYBaseRequest alloc]init];
    accountInfoAPI.requestUrl = kHXBUser_AccountInfoURL;
    accountInfoAPI.requestMethod = NYRequestMethodGet;
    kWeakSelf
    [accountInfoAPI loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        weakSelf.accountModel = [[HXBMyRequestAccountModel alloc]init];
        [weakSelf.accountModel yy_modelSetWithDictionary:responseObject[@"data"]];
        if (completion) {
            completion(YES);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (completion) {
            completion(NO);
        }
    }];
}

@end
