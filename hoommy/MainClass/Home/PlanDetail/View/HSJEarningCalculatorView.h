//
//  HSJEarningCalculatorView.h
//  hoommy
//
//  Created by lxz on 2018/7/24.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJEarningCalculatorView : UIView
+ (instancetype)shared;

+ (void)showWithInterest:(double)interest buyBlock:(void (^)(NSString *value))buyBlock;

@end
