//
//  HSJRollOutViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJRollOutViewModel.h"
#import "NSString+HxbPerMilMoney.h"

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
        self.pageNumber = 0;
        self.footerType = HSJRefreshFooterTypeMoreData;
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

- (void)getPlans:(void(^)(BOOL isSuccess))resultBlock {
    NSUInteger page = self.pageNumber + 1;;
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_PlanListURL;
        request.requestArgument = @{@"filter": @"4", @"page": @(page)};
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
                HSJRollOutCellViewModel *vm = [HSJRollOutCellViewModel new];
                vm.model = model;
                [temp addObject:vm];
            }
            if (temp.count > 0) {
                [weakSelf.dataSource addObjectsFromArray:temp];
            }
            
            if (weakSelf.pageSize > weakSelf.totalCount) {
                weakSelf.footerType = HSJRefreshFooterTypeNone;
            } else if (weakSelf.pageSize * weakSelf.pageNumber > weakSelf.totalCount) {
                weakSelf.footerType = HSJRefreshFooterTypeNoMoreData;
            } else {
                weakSelf.footerType = HSJRefreshFooterTypeNone;
            }
        }
        resultBlock(responseData != nil);
    }];
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    [self.dataSource enumerateObjectsUsingBlock:^(HSJRollOutCellViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isEditing = editing;
    }];
}

- (void)calAmount {
    CGFloat value = 0;
    for (HSJRollOutCellViewModel *vm in self.dataSource) {
        if (vm.isSelected) {        
            value += vm.model.redProgressLeft.floatValue;
        }
    }
    
    NSString *valueString = [NSString GetPerMilWithDouble:value];
    valueString = [valueString isEqualToString:@"0"] ? @"0.00" : valueString;
    self.amount = [NSString stringWithFormat:@"待转出金额%@元", valueString];
}

@end
