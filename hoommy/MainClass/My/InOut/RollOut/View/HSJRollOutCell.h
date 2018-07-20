//
//  HSJRollOutCell.h
//  hoommy
//
//  Created by lxz on 2018/7/18.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJRollOutCellViewModel.h"

UIKIT_EXTERN NSString *const HSJRollOutCellIdentifier;

@interface HSJRollOutCell : UITableViewCell

@property (nonatomic, strong) HSJRollOutCellViewModel *viewModel;

/// Cell 中的转出按钮
@property (nonatomic, copy) void(^rollOutBlock)(HSJRollOutCellViewModel *viewModel);

/// Cell 中的选中按钮
@property (nonatomic, copy) void(^selectBlock)(HSJRollOutCellViewModel *viewModel);

@end
