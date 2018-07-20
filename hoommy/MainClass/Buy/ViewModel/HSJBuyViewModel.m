//
//  HSJBuyViewModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewModel.h"

@implementation HSJBuyViewModel
#pragma mark 数据请求处理

#pragma  mark 逻辑处理
- (NSArray *)cellDataList {
    if(!_cellDataList) {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:2];
        _cellDataList = dataList;
        
        HSJBuyCellModel *cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:NO];
        [dataList addObject:cellModel];
        
        cellModel = [[HSJBuyCellModel alloc] initCellModel:NO showArrow:YES];
        [dataList addObject:cellModel];
    }
    
    return _cellDataList;
}

- (void)buildCellDataList {

    HSJBuyCellModel *cellModel = [self.cellDataList safeObjectAtIndex:0];
    cellModel.iconName = @"leftMoneyNormal";
    NSString *str1 = @"可用余额";
    NSString *str2 = @"\n3,122.00元";
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:YES];
    
    cellModel = [self.cellDataList safeObjectAtIndex:1];
    cellModel.iconName = @"leftMoneySelect";
    str1 = @"上海银行 (*432)";
    str2 = @"\n单笔限5万，日单限20万";
    cellModel.title = [self buildAttributedString:str1 secondString:str2 state:NO];
}

- (NSAttributedString*)buildAttributedString:(NSString*)str1 secondString:(NSString*)str2 state:(BOOL)isCanSelected {
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSMutableString stringWithFormat:@"%@%@", str1, str2]];
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
