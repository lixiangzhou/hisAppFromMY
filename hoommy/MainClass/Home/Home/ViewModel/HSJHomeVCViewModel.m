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

@interface HSJHomeVCViewModel()

@property (nonatomic, strong) NSMutableArray *cellHeightArray;

@end
@implementation HSJHomeVCViewModel

- (void)getHomeDataWithResultBlock:(NetWorkResponseBlock)resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHSJHomeBaby;
        request.requestMethod = NYRequestMethodGet;
        request.modelType = [HSJHomeModel class];
        request.showHud = YES;
    } responseResult:^(HSJHomeModel *responseData, NSError *erro) {
        if (responseData) {
            weakSelf.homeModel = responseData;
            HSJHomePlanModel *planModel = [self.homeModel.dataList safeObjectAtIndex:0];
            //缓存第一个计划的id
            KeyChain.firstPlanIdInPlanList = planModel.ID;
        }
        resultBlock(responseData,erro);
    }];
}

- (void)getGlobal:(void (^)(HSJGlobalInfoModel *))resultBlock {
    kWeakSelf
    [[HSJGlobalInfoManager shared] getData:^(HSJGlobalInfoModel *infoModel) {
        weakSelf.infoModel = infoModel;
        if (resultBlock) {
            resultBlock(infoModel);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSJHomePlanModel * cellmodel = self.homeModel.dataList[indexPath.row];
    if ([cellmodel.viewItemType  isEqual: @"product"]) {
        HSJHomePlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomePlanCellIdentifier];
        cell.planModel = cellmodel;
        return cell;
    } else if ([cellmodel.viewItemType  isEqual: @"signuph5"] && !KeyChain.isLogin) {
        HSJHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomeActivityCellIdentifier];
        cell.planModel = cellmodel;
        return cell;
    } else if ([cellmodel.viewItemType  isEqual: @"h5"]) {
        HSJHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:HSJHomeActivityCellIdentifier];
        cell.planModel = cellmodel;
        return cell;
    }
    return nil;
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

    kWeakSelf
    for (int i = 0; i < homeModel.dataList.count; i++) {
        HSJHomePlanModel *planModel = homeModel.dataList[i];
        if ([planModel.viewItemType  isEqual: @"product"]) {
            self.cellHeightArray[i] = KeyChain.isLogin ? @kScrAdaptationH750(676) : @kScrAdaptationH750(598);

        } else if ([planModel.viewItemType  isEqual: @"signuph5"])  {
            self.cellHeightArray[i] = @kScrAdaptationH750(145);
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:planModel.image] options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    CGFloat cellHeight = kScreenWidth / image.size.width * image.size.height + kScrAdaptationH750(20);
                    if (weakSelf.updateCellHeight) {
                        weakSelf.cellHeightArray[i] = @(cellHeight);
                    }
                }
            }];
        } else if ([planModel.viewItemType  isEqual: @"h5"]) {
            self.cellHeightArray[i] = @kScrAdaptationH750(200);
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:planModel.image] options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    CGFloat cellHeight = kScreenWidth / image.size.width * image.size.height + kScrAdaptationH750(20);
                    if (weakSelf.updateCellHeight) {
                        weakSelf.cellHeightArray[i] = @(cellHeight);
                    }
                }
            }];
        } else {
            self.cellHeightArray[i] = @0;
        }
    }

    if (self.updateCellHeight) {
        self.updateCellHeight();
    }
}

- (NSMutableArray *)cellHeightArray {
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}

@end
