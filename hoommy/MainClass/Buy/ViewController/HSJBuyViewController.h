//
//  HSJBuyViewController.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController.h"
#import "HSJPlanModel.h"

@interface HSJBuyViewController : HXBBaseViewController
@property (nonatomic, strong) HSJPlanModel *planModel;
@property (nonatomic, copy) NSString *planId;
@end
