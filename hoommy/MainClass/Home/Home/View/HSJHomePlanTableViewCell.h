//
//  HSJHomePlanTableViewCell.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJHomePlanModel.h"

extern NSString *const HSJHomePlanCellIdentifier;

@interface HSJHomePlanTableViewCell : UITableViewCell

@property (nonatomic, strong) HSJHomePlanModel *planModel;

@property (nonatomic, strong) void (^intoButtonAct)(NSString *planId);
@end
