//
//  HSJBankCardListViewModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HSJBankCardListViewModel : HSJBaseViewModel
@property (nonatomic, strong) NSMutableArray *bankListModels;

/**
 获取银行卡列表
 
 */
- (void)bankCardListRequestWithResultBlock: (void(^)(BOOL isSuccess))resultBlock;
@end
