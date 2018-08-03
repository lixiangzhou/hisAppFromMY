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
//逻辑数据
@property (nonatomic, strong) HSJHomeModel *recordHomeModel;
@property (nonatomic, assign) BOOL recordIsLogin;
@end

@implementation HSJHomeVCViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recordIsLogin = KeyChain.isLogin;
    }
    return self;
}

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
        } else {
            planModel.cellHeight = 0;
        }
    }
}

- (void)reloadPage:(void (^)(BOOL needReload))resultBlock {
    BOOL isFresh = NO;
    if(KeyChain.isLogin != self.recordIsLogin) {
        isFresh = YES;
    }
    else if(!self.recordHomeModel) {
        isFresh = YES;
    }
    else if(!self.homeModel) {
        isFresh = YES;
    }
    else {
        NSDictionary *tempDic1 = [self.homeModel toDictionary];
        NSDictionary *tempDic2 = [self.recordHomeModel toDictionary];
        NSArray *tempList1 = [tempDic1 arrayAtPath:@"dataList"];
        NSArray *tempList2 = [tempDic2 arrayAtPath:@"dataList"];
        if(tempList1.count != tempList2.count) {
            isFresh = YES;
        }
        else {
            for (int i=0; i<tempList1.count; i++) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:[tempList1 safeObjectAtIndex:i]];
                [dic1 removeObjectForKey:@"diffTime"];
                NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:[tempList2 safeObjectAtIndex:i]];
                [dic2 removeObjectForKey:@"diffTime"];
                if(![dic1 isEqualToDictionary:dic2]) {
                    isFresh = YES;
                    break;
                }
            }
        }
    }
    
    if(isFresh) {
        self.recordIsLogin = KeyChain.isLogin;
        self.recordHomeModel = self.homeModel;
    }
    if (resultBlock) {
        resultBlock(isFresh);
    }
}

@end
