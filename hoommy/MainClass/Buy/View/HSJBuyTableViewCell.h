//
//  HSJBuyTableViewCell.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJBuyCellModel.h"

@interface HSJBuyTableViewCell : UITableViewCell

- (void)bindData:(BOOL)isLastItem cellDataModel:(HSJBuyCellModel*)model;
@end
