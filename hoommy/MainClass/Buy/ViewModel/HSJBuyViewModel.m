//
//  HSJBuyViewModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewModel.h"

@implementation HSJBuyViewModel

- (void)buildCellDataList {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:2];
    self.cellDataList = dataList;
    
    HSJBuyCellModel *cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:NO];
    cellModel.iconName = @"leftMoneyNormal";
    NSString *str1 = @"可用余额";
    NSString *str2 = @"\n3,122.00元";
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
    [dataList addObject:cellModel];
    
    cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:YES];
    cellModel.iconName = @"leftMoneySelect";
    str1 = @"上海银行 (*432)";
    str2 = @"\n单笔限5万，日单限20万";
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:NO];
    [dataList addObject:cellModel];
}

- (NSAttributedString*)buildAttributedString:(NSString*)str1 secondString:(NSString*)str2 state:(BOOL)isCanSelected {
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSMutableString stringWithFormat:@"%@%@", str1, str1]];
    if(isCanSelected) {
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_28, NSForegroundColorAttributeName:kHXBFontColor_333333_100} range:NSMakeRange(0, str1.length)];
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_26, NSForegroundColorAttributeName:kHXBFontColor_9295A2_100} range:NSMakeRange(str1.length, str2.length)];
    }
    else {
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_28, NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, str1.length)];
        [tempStr setAttributes:@{NSFontAttributeName:kHXBFont_26, NSForegroundColorAttributeName:kHXBFontColor_9295A2_100} range:NSMakeRange(str1.length, str2.length)];
    }
    
    return tempStr;
}
@end
