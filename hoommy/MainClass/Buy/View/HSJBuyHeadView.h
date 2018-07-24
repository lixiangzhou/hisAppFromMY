//
//  HSJBuyHeadView.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJBuyHeadView : UIView
@property (nonatomic, copy) NSString *inputMoney;
@property (nonatomic, assign) float addUpLimitMoney;
@property (nonatomic, assign) BOOL isKeepKeyboard;

@property (nonatomic, strong) void (^textChange)(NSString  *text);
@end
