//
//  HXBBankCardListViewController.h
//  hoomxb
//
//  Created by HXB-C on 2017/6/28.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseViewController.h"

@interface HXBBankCardListViewController : HXBBaseViewController

/**
 获取银行卡回调
 */
@property (nonatomic, copy) void(^bankCardListBlock)(NSString *bankCode, NSString *bankName);

@end
