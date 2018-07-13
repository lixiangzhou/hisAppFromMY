//
//  HXBBankView.h
//  hoomxb
//
//  Created by HXB-C on 2017/8/10.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXBBankCardModel;
typedef void(^unbundBankBlock)(HXBBankCardModel *bankCardModel);//解绑block

@interface HXBBankView : UIView

@property (nonatomic, copy) void (^unbundBankBlock)(HXBBankCardModel *bankCardModel);

@end
