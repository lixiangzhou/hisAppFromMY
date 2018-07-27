//
//  HSJPlanBuyResultViewController.h
//  hoommy
//
//  Created by caihongji on 2018/7/26.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseViewController.h"

@interface HSJPlanBuyResultViewController : HXBBaseViewController
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *erroInfo;
//起息日
@property (nonatomic, copy) NSString *lockStart;
@end
