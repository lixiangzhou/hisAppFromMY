//
//  HSJPlanModel.m
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanModel.h"

@implementation HSJPlanModel

- (NSMutableDictionary *)map {
    NSMutableDictionary *dic = [super map];
    [dic setValue:@"id" forKey:@"planId"];
    
    return dic;
}

@end
