//
//  HSJFinAddRecortdCell.h
//  hoommy
//
//  Created by hxb on 2018/7/25.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJFinAddRecortdModel.h"

UIKIT_EXTERN NSString * const HSJFinAddRecortdCellIdentifier;


@interface HSJFinAddRecortdCell : UITableViewCell

@property (nonatomic, strong) HSJFinAddRecortdModel *model;
@property (nonatomic, copy) void(^statusActionBlock)(HSJFinAddRecortdModel *model);

@end
