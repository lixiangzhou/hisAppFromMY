//
//  HXBMYCapitalRecord_TableView.h
//  hoomxb
//
//  Created by HXB on 2017/5/23.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

//#import "HXBBaseTableView.h"
@class HXBMYModel_CapitalRecordDetailModel;///资金记录的MOdel
@class HXBMYViewModel_MainCapitalRecordViewModel;///资金记录的ViewModel
///资金统计的列表
@interface HXBMYCapitalRecord_TableView : UITableView
@property (nonatomic,strong)NSArray <HXBMYViewModel_MainCapitalRecordViewModel *>*capitalRecortdDetailViewModelArray;
@property (nonatomic, assign) NSInteger totalCount;

@end
