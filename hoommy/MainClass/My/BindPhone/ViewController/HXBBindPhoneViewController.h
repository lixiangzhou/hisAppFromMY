//
//  HXBBindPhoneViewController.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBBindPhoneVCViewModel.h"
#import "HXBUserInfoModel.h"
#import "HXBBaseViewController.h"

@interface HXBBindPhoneViewController : HXBBaseViewController

@property (nonatomic, strong) HXBUserInfoModel* userInfoModel;

@property (nonatomic, assign) HXBBindPhoneStepType bindPhoneStepType;

@end
