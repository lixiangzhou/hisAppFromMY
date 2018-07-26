//
//  HSJBuyFootView.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSJBuyFootView : UIView
@property (nonatomic, copy) NSString *btnContent;
@property (nonatomic, strong) UIColor *buttonBackGroundColor;

@property (nonatomic, assign) BOOL isAgreeRiskApplyAgreement;
@property (nonatomic, assign) BOOL isAgreementGroup;
@property (nonatomic, assign) BOOL isShowAgreeRiskApplyAgreementView;
@property (nonatomic, assign) BOOL enableAddButton;


@property (nonatomic, strong) void (^addAction)(void);
@property (nonatomic, strong) void (^lookUpAgreement)(void);
@end
