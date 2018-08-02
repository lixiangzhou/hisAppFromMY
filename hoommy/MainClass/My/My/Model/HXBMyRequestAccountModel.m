//
//  HXBMyRequestAccountModel.m
//  hoomxb
//
//  Created by hxb on 2017/10/30.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBMyRequestAccountModel.h"

@implementation HXBMyRequestAccountModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"operateList" : [MyRequestOperateModel class]
             };
}

- (void)setEarnTotal:(double)earnTotal{
    if (earnTotal < 0) {
        _earnTotal = 0.00;
    } else {
        _earnTotal = earnTotal;
    }
}

@end

@implementation MyRequestOperateModel
@end
