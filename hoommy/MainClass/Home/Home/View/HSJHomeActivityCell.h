//
//  HSJHomeActivityCell.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJHomePlanModel.h"

extern NSString *const HSJHomeActivityCellIdentifier;

@interface HSJHomeActivityCell : UITableViewCell

@property (nonatomic, strong) void(^updateCellHeight)(CGFloat height, NSInteger index);

- (void)bindData:(HSJHomePlanModel*)planModel cellIndexPath:(NSIndexPath*)indexPath;
@end
