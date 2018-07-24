//
//  HXBNoticeVCViewModel.m
//  hoomxb
//
//  Created by HXB-C on 2018/1/12.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBNoticeVCViewModel.h"
#import "HXBNoticModel.h"
#import "NSObject+YYModel.h"

@interface HXBNoticeVCViewModel ()

@property (nonatomic, assign) int dataPage;

@property (nonatomic, strong) NSMutableArray<HSJNoticeListModel *> *noticeList;

@end
@implementation HXBNoticeVCViewModel

- (void)noticeRequestWithisUPReloadData:(BOOL)isUPReloadData andCallbackBlock: (void(^)(BOOL isSuccess))callbackBlock
{
    
    if (isUPReloadData) {
        self.dataPage = 1;
    }
    else {
        self.dataPage++;
    }
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        
        
        request.requestUrl = kHXBHome_AnnounceURL;
        request.requestMethod = NYRequestMethodGet;
        request.showHud = NO;
        request.requestArgument = @{
                                    @"page" : @(self.dataPage),
                                    @"pageSize" : @kPageCount
                                    };
        request.modelType = [HXBNoticModel class];
    } responseResult:^(HXBNoticModel *responseData, NSError *erro) {
        if (!erro) {
            if (isUPReloadData) {
                [weakSelf.noticeList removeAllObjects];
            }
            
            [weakSelf.noticeList addObjectsFromArray:responseData.dataList];
            weakSelf.noticModel = responseData;
            weakSelf.noticModel.dataList = weakSelf.noticeList;
            callbackBlock(YES);
        } else {
            weakSelf.dataPage--;
            if (callbackBlock) {
                callbackBlock(NO);
            }
        }
    }];
    
}

- (NSMutableArray<HSJNoticeListModel *> *)noticeList {
    if (!_noticeList) {
        _noticeList = [NSMutableArray array];
    }
    return _noticeList;
}
@end
