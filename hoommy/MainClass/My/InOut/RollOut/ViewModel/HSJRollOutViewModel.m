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
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanAccountRequestURL;
        request.modelType = [HSJPlanAssetsModel class];
    } responseResult:^(id responseData, NSError *erro) {
        self.assetsModel = responseData;
        resultBlock(responseData != nil);
    }];
}

- (void)getPlans:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock {
    NSUInteger page = 1;
    if (isNew == NO) {
        page = self.pageNumber + 1;
    }
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanListURL;
        request.requestArgument = @{@"filter": @"1", @"page": @(page)};
    } responseResult:^(id responseData, NSError *erro) {
        if (responseData) {
            self.totalCount = [responseData[@"totalCount"] integerValue];
            self.pageSize = [responseData[@"pageSize"] integerValue];
            self.pageNumber = [responseData[@"pageNumber"] integerValue];
            
            NSArray *dataList = responseData[@"dataList"];
            
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataList.count];
            for (NSInteger i = 0; i < dataList.count; i++) {
                HSJRollOutModel *model = [[HSJRollOutModel alloc] initWithDictionary:dataList[i]];
                [temp addObject:model];
            }
            
            if (isNew) {
                self.dataSource = temp;
            } else {
                [self.dataSource addObjectsFromArray:temp];
            }
        }
        resultBlock(responseData != nil);
    }];
}

@end
