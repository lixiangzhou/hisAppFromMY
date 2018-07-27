//
//  HSJBuyHeadView.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJBuyHeadView : UIView
@property (nonatomic, assign) float addUpLimitMoney;
@property (nonatomic, assign) BOOL isKeepKeyboard;
@property (nonatomic, assign) BOOL enableContentTf;

@property (nonatomic, copy) NSString *inputMoney;
///加入条件加入金额%@元起，%@元的整数倍递增
@property (nonatomic, copy) NSString *addCondition;

@property (nonatomic, strong) void (^textChange)(NSString  *text);
@end
