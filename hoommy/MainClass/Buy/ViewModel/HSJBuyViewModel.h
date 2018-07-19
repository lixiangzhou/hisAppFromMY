//
//  HSJBuyViewModel.h
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HSJBuyCellModel.h"

@interface HSJBuyViewModel : HSJBaseViewModel
@property (nonatomic, strong) NSArray *cellDataList;

- (void)buildCellDataList;
@end
