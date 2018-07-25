//
//  HSJHomePlanView.h
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBRequestUserInfoViewModel.h"
#import "HSJPlanModel.h"

@interface HSJHomePlanView : UIView

@property (nonatomic, strong) HSJPlanModel *planModel;

@property (nonatomic, strong) HXBRequestUserInfoViewModel *userViewModel;

@end
