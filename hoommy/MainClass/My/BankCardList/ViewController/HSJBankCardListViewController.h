//
//  HSJBankCardListViewController.h
//  hoommy
//
//  Created by HXB-C on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController.h"

@interface HSJBankCardListViewController : HXBBaseViewController

/**
 获取银行卡回调
 */
@property (nonatomic, copy) void(^bankCardListBlock)(NSString *bankCode, NSString *bankName);

@end
