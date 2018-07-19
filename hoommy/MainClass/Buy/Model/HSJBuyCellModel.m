//
//  HSJBuyCellModel.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyCellModel.h"

@implementation HSJBuyCellModel

- (instancetype)initCellModel:(BOOL)isSvnImage showArrow:(BOOL)isShowArrow {
    self = [super init];
    if(self) {
        self.isSvnImage = isSvnImage;
        self.isShowArrow = isShowArrow;
    }
    
    return self;
}
@end
