//
//  HSJRollOutHistoryViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutHistoryViewModel.h"
#import "HSJRollOutModel.h"

@interface HSJRollOutHistoryViewModel ()
@property (nonatomic, assign) NSInteger exitedPageNumber;
@property (nonatomic, assign) NSInteger exitedPageSize;
@property (nonatomic, assign) NSInteger exitedTotalCount;

@property (nonatomic, assign) NSInteger exitingPageNumber;
@property (nonatomic, assign) NSInteger exitingPageSize;
@property (nonatomic, assign) NSInteger exitingTotalCount;
@end

@implementation HSJRollOutHistoryViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.exitingDataSource = [NSMutableArray new];
        self.exitedDataSource = [NSMutableArray new];
    }
    return self;
}

- (void)getPlansWithType:(HSJRollOutPlanType)type isNew:(BOOL)isNew resultBlock:(void(^)(BOOL isSuccess))resultBlock {
    NSUInteger page = 1;
    if (isNew == NO) {
        if (type == HSJRollOutPlanTypeExited) {
            page = self.exitedPageNumber + 1;
        } else {
            page = self.exitingPageNumber + 1;
        }
    }
    
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanListURL;
        if (type == HSJRollOutPlanTypeExited) {
            request.requestArgument = @{@"filter": @"3", @"page": @(page)};
        } else {
            request.requestArgument = @{@"filter": @"2", @"page": @(page)};
        }
        
    } responseResult:^(id responseData, NSError *erro) {
        if (responseData) {
            
            NSInteger totalCount = [responseData[@"totalCount"] integerValue];
            NSInteger pageSize = [responseData[@"pageSize"] integerValue];
            NSInteger pageNumber = [responseData[@"pageNumber"] integerValue];
            
            if (type == HSJRollOutPlanTypeExited) {
                self.exitedPageNumber = pageNumber;
                self.exitedPageSize = pageSize;
                self.exitedTotalCount = totalCount;
            } else {
                self.exitingPageNumber = pageNumber;
                self.exitingPageSize = pageSize;
                self.exitingTotalCount = totalCount;
            }
            
            NSArray *dataList = responseData[@"dataList"];
            
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataList.count];
            for (NSInteger i = 0; i < dataList.count; i++) {
                HSJRollOutModel *model = [[HSJRollOutModel alloc] initWithDictionary:dataList[i]];
                [temp addObject:model];
            }
            
            if (type == HSJRollOutPlanTypeExited) {
                if (isNew) {
                    self.exitedDataSource = temp;
                } else {
                    [self.exitedDataSource addObjectsFromArray:temp];
                }
            } else {
                if (isNew) {
                    self.exitingDataSource = temp;
                } else {
                    [self.exitingDataSource addObjectsFromArray:temp];
                }
            }
        }
        
        resultBlock(responseData != nil);
    }];
}
@end
