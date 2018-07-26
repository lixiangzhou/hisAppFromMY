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
 描述文案
 */
@property (nonatomic, copy) NSString *describeStr;

@property (nonatomic, strong) void(^viewClickBlock)(void);

- (void)setAmountText:(NSString *)amountText andWithAmountTextUnit:(NSString *)amountTextUnit;

@end
