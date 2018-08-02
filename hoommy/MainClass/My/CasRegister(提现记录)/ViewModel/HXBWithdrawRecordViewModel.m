//
//  HXBWithdrawRecordViewModel.m
//  hoomxb
//
//  Created by HXB-C on 2017/10/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWithdrawRecordViewModel.h"
#import "HXBWithdrawRecordListModel.h"
#import "HXBWithdrawRecordModel.h"
#import "YYModel.h"
#import "NSString+HxbGeneral.h"

@interface HXBWithdrawRecordViewModel ()

@property (nonatomic, strong) NSMutableArray <HXBWithdrawRecordModel *> *dataList;

@end

@implementation HXBWithdrawRecordViewModel

- (HXBWithdrawRecordListModel *)withdrawRecordModel {
    if (!_withdrawRecordListModel) {
        _withdrawRecordListModel = [[HXBWithdrawRecordListModel alloc] init];
    }
    return _withdrawRecordListModel;
}

- (void)withdrawRecordProgressRequestWithLoading:(BOOL)isLoading resultBlock: (void(^)(BOOL isSuccess))resultBlock {
    kWeakSelf
    NYBaseRequest *withdrawRecordAPI = [[NYBaseRequest alloc] initWithDelegate:self];
    withdrawRecordAPI.requestUrl = kHXBSetWithdrawals_recordtURL;
    withdrawRecordAPI.showHud = isLoading;
    withdrawRecordAPI.requestMethod = NYRequestMethodPost;
    withdrawRecordAPI.requestArgument = @{
                                         @"page" : @(self.withdrawRecordPage).description,
                                         @"pageSize" : @kPageCount
                                         };
    
    [withdrawRecordAPI loadData:^(NYBaseRequest *request, NSDictionary *responseObject) {
        if (weakSelf.withdrawRecordPage <= 1) {
            weakSelf.withdrawRecordPage = 1;
            [weakSelf.dataList removeAllObjects];
        }
        
        
        weakSelf.withdrawRecordListModel = [HXBWithdrawRecordListModel yy_modelWithDictionary:responseObject[kResponseData]];
        [weakSelf.dataList addObjectsFromArray:weakSelf.withdrawRecordListModel.dataList];
        weakSelf.withdrawRecordListModel.dataList = weakSelf.dataList;
        
        [weakSelf rormatDataList];
        
        if (resultBlock) {
            resultBlock(YES);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) {
            resultBlock(NO);
        }
    }];
}

/// 格式化数据源
- (void)rormatDataList {
    
    if (self.withdrawRecordListModel.dataList.count <= 0) {
        return;
    }
    
    self.formatWithdrawRecordDataKeyList = [NSMutableArray arrayWithCapacity:self.withdrawRecordListModel.dataList.count];
    for (int i=0; i<self.withdrawRecordListModel.dataList.count; i++) {
        HXBWithdrawRecordModel *model = self.withdrawRecordListModel.dataList[i];
        [self.formatWithdrawRecordDataKeyList addObject:[NSString hxb_formatKeyString:model.applyTimeStr]];
    }
    self.formatWithdrawRecordDataKeyList = [self.formatWithdrawRecordDataKeyList valueForKeyPath:@"@distinctUnionOfObjects.self"];//去重
    
    NSMutableArray *withdrawRecordListModel_temp = [NSMutableArray arrayWithArray:self.withdrawRecordListModel.dataList];
    self.formatWithdrawRecordDataValueList = [NSMutableDictionary dictionaryWithCapacity:self.formatWithdrawRecordDataKeyList.count];
    for (int i=0; i<self.formatWithdrawRecordDataKeyList.count; i++) {
        
        NSMutableArray *keyValueArray_temp = [NSMutableArray arrayWithCapacity:0];
        [withdrawRecordListModel_temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HXBWithdrawRecordModel *model = withdrawRecordListModel_temp[idx];
            if ([self.formatWithdrawRecordDataKeyList[i] isEqualToString:[NSString hxb_formatKeyString:model.applyTimeStr]]) {
                [keyValueArray_temp addObject:model];
//                [withdrawRecordListModel_temp removeObject:model];
            }
        }];
        
        [self.formatWithdrawRecordDataValueList setObject:keyValueArray_temp forKey:self.formatWithdrawRecordDataKeyList[i]];
        [withdrawRecordListModel_temp removeObjectsInArray:keyValueArray_temp];
    }
}

- (NSMutableArray<NSString *> *)formatWithdrawRecordDataKeyList {
    if (!_formatWithdrawRecordDataKeyList) {
        _formatWithdrawRecordDataKeyList = [NSMutableArray new];
    }
    return _formatWithdrawRecordDataKeyList;
}

-(NSMutableDictionary *)formatWithdrawRecordDataValueList {
    if (!_formatWithdrawRecordDataValueList) {
        _formatWithdrawRecordDataValueList = [NSMutableDictionary new];
    }
    return _formatWithdrawRecordDataValueList;
}

- (NSInteger)withdrawRecordPage{
    if (_withdrawRecordPage <= 1) {
        _withdrawRecordPage = 1;
    }
    return _withdrawRecordPage;
}

- (NSMutableArray<HXBWithdrawRecordModel *> *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
