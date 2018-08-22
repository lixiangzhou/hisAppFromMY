//
//  HSJPlanDetailTopView.h
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJPlanDetailViewModel.h"

@interface HSJPlanDetailTopView : UIView
@property (nonatomic, strong) HSJPlanDetailViewModel *viewModel;
@property (nonatomic, copy) void (^calBlock)(UIButton *);
@end
