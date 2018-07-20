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
UIKIT_EXTERN const CGFloat HSJRollOutCellHeight;

@interface HSJRollOutCell : UITableViewCell

@property (nonatomic, strong) HSJRollOutCellViewModel *viewModel;

@end
