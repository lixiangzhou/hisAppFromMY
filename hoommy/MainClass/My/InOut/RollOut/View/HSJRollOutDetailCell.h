//
//  HSJRollOutDetailCell.h
//  hoommy
//
//  Created by lxz on 2018/7/23.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJRollOutPlanDetailRowModel.h"

UIKIT_EXTERN NSString *const HSJRollOutDetailCellIdentifier;

@interface HSJRollOutDetailCell : UITableViewCell
@property (nonatomic, strong) HSJRollOutPlanDetailRowModel *model;

@property (nonatomic, assign) BOOL hideBottomLine;
@end
