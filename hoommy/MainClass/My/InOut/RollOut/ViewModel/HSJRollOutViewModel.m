//
//  HSJRollOutViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutViewModel.h"

@interface HSJRollOutViewModel ()
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger totalCount;
@end

@implementation HSJRollOutViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)getAssets:(void(^)(BOOL isSuccess))resultBlock {
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanAccountRequestURL;
        request.modelType = [HSJPlanAssetsModel class];
    } responseResult:^(id responseData, NSError *erro) {
        weakSelf.assetsModel = responseData;
        resultBlock(responseData != nil);
    }];
}

- (void)getPlans:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock {
    NSUInteger page = 1;
    if (isNew == NO) {
        page = self.pageNumber + 1;
    }
    
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanListURL;
        request.requestArgument = @{@"filter": @"1", @"page": @(page)};
    } responseResult:^(id responseData, NSError *erro) {
        if (responseData) {
            NSDictionary *data = responseData[@"data"];
            weakSelf.totalCount = [data[@"totalCount"] integerValue];
            weakSelf.pageSize = [data[@"pageSize"] integerValue];
            weakSelf.pageNumber = [data[@"pageNumber"] integerValue];
            
            NSArray *dataList = data[@"dataList"];
            
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataList.count];
            for (NSInteger i = 0; i < dataList.count; i++) {
                HSJRollOutModel *model = [[HSJRollOutModel alloc] initWithDictionary:dataList[i]];
                [temp addObject:model];
            }
            
            if (isNew) {
                weakSelf.dataSource = temp;
            } else {
                [weakSelf.dataSource addObjectsFromArray:temp];
            }
        }
        resultBlock(responseData != nil);
    }];
}

@end
