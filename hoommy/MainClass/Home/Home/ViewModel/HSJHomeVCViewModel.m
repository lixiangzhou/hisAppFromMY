//
//  HSJHomeVCViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeVCViewModel.h"
#import "HSJHomeModel.h"
@implementation HSJHomeVCViewModel

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHSJHomeBaby;
        request.requestMethod = NYRequestMethodGet;
        request.modelType = [HSJHomeModel class];
    } responseResult:^(HSJHomeModel *responseData, NSError *erro) {
        weakSelf.homeModel = responseData;
        resultBlock(responseData,erro);
    }];
}

@end
