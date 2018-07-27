//
//  HSJHomePlanModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomePlanModel.h"
#import <UIImageView+WebCache.h>

@implementation HSJHomePlanModel

- (NSDictionary *)map {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [dic setObject:@"id" forKey:@"ID"];
    return [NSDictionary dictionaryWithDictionary:dic];
}

@end
