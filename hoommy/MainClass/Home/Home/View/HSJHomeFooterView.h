//
//  HSJHomeFooterView.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJGlobalInfoModel.h"

@interface HSJHomeFooterView : UIView

- (void)updateData;

///平台累计成交金额点击事件
@property (nonatomic, strong) void(^platformAmountClickBlock)(void);
///平台为用户累计赚取金额点击事件
@property (nonatomic, strong) void(^userAmountClickBlock)(void);
///恒丰银行存管点击事件
@property (nonatomic, strong) void(^bankClickBlock)(void);
///AAA信用评级点击事件
@property (nonatomic, strong) void(^creditClickBlock)(void);
///2亿注册资本点击事件
@property (nonatomic, strong) void(^registeredCapitalClickBlock)(void);
@end
