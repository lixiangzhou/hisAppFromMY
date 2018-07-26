//
//  HSJFinAddRecortdViewModel.m
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJFinAddRecortdViewModel.h"
#import "HSJFinAddRecortdModel.h"
#import "YYModel.h"

@interface HSJFinAddRecortdViewModel ()

@end

@implementation HSJFinAddRecortdViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray new];
        self.pageNumber = 1;
    }
    return self;
}

- (void)getFinAddRecortd:(BOOL)isNew planID:(NSString *)planID resultBlock:(void(^)(BOOL isSuccess))resultBlock;{
    NSUInteger page = 1;
    if (isNew == NO) {
        page = self.pageNumber + 1;
    }
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_LoanRecordURL(planID);
        request.requestArgument = @{@"page": @(page)};
    } responseResult:^(id responseData, NSError *erro) {
        if (responseData) {
            NSDictionary *data = responseData[@"data"];
            weakSelf.totalCount = [data[@"totalCount"] integerValue];
            weakSelf.pageSize = [data[@"pageSize"] integerValue];
            weakSelf.pageNumber = [data[@"pageNumber"] integerValue];
            
            NSArray *dataList = data[@"dataList"];
            
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataList.count];
        
            [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HSJFinAddRecortdModel *model = [HSJFinAddRecortdModel new];
                [model yy_modelSetWithDictionary:obj];
                [temp addObject:model];
            }];
            
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
