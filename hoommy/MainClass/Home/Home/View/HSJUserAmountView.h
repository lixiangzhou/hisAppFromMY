//
//  HSJUserAmountView.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJUserAmountView : UIView


/**
 累计金额
 */
@property (nonatomic, copy) NSString *amountStr;
/**
 累计金额单位
 */
@property (nonatomic, copy) NSString *amountUnit;
/**
 描述文案
 */
@property (nonatomic, copy) NSString *describeStr;

- (void)setAmountText:(NSString *)amountText andWithAmountTextUnit:(NSString *)amountTextUnit;

@end
