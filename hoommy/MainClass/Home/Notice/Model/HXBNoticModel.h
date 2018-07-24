//
//  HXBNoticModel.h
//  hoomxb
//
//  Created by HXB-C on 2017/7/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseModel.h"
#import "HSJNoticeListModel.h"

@interface HXBNoticModel : HSJBaseModel

@property (nonatomic, strong) NSArray<HSJNoticeListModel *> *dataList;


@property (nonatomic, assign) int pageNumber;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) int totalCount;

@end
