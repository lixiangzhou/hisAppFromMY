//
//  HSJHomeVCViewModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeVCViewModel.h"
#import "HSJHomeModel.h"
#import "HSJGlobalInfoManager.h"
#import <UIImageView+WebCache.h>
#import "HSJHomePlanTableViewCell.h"
#import "HSJHomeActivityCell.h"
#import <ReactiveObjC.h>
#import "HXBGeneralAlertVC.h"
#import "HSJRiskAssessmentViewController.h"

@interface HSJHomeVCViewModel()
@end

@implementation HSJHomeVCViewModel

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock showHug:(BOOL)isShowHug{
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHSJHomeBaby;
        request.requestMethod = NYRequestMethodGet;
        request.modelType = [HSJHomeModel class];
        request.showHud = isShowHug;
    } responseResult:^(HSJHomeModel *responseData, NSError *erro) {
        if (responseData) {
            weakSelf.homeModel = responseData;
            [self.homeModel.dataList enumerateObjectsUsingBlock:^(HSJHomePlanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.viewItemType isEqualToString:@"product"]) {
                    KeyChain.firstPlanIdInPlanList = obj.ID;//缓存第一个计划的id
                    *stop = YES;
                }
            }];
        }
        resultBlock(responseData,erro);
    }];
}

- (void)setHomeModel:(HSJHomeModel *)homeModel {
    _homeModel = homeModel;
    NSMutableArray<HSJHomePlanModel *> *cellDataList = [NSMutableArray arrayWithArray:homeModel.dataList];
     if (KeyChain.isLogin) {
         [cellDataList enumerateObjectsUsingBlock:^(HSJHomePlanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.viewItemType isEqualToString:@"signuph5"]) {
                 *stop = YES;
                 if (*stop == YES) {
                     [cellDataList removeObject:obj];
                 }
             }
         }];
    }
    _homeModel.dataList = cellDataList;

    for (int i = 0; i < homeModel.dataList.count; i++) {
        HSJHomePlanModel *planModel = homeModel.dataList[i];
        if ([planModel.viewItemType  isEqual: @"product"]) {
            planModel.cellHeight = KeyChain.isLogin ? kScrAdaptationH750(676) : kScrAdaptationH750(598);
        } else if ([planModel.viewItemType  isEqual: @"signuph5"])  {
            planModel.cellHeight = kScrAdaptationH750(157);
        } else if ([planModel.viewItemType  isEqual: @"h5"]) {
            planModel.cellHeight = kScrAdaptationH750(200);
        }
    }
}

@end
