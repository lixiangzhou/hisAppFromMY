//
//  HSJBaseModel.m
//  NetWorkingTest
//
//  Created by HXB-C on 2017/3/27.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseModel.h"

@implementation HSJBaseModel


/**
 映射特殊的解析字段

 @return 映射结果
 */
- (NSDictionary *)map {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [dic setObject:@"id" forKey:@"message"];
    return [NSDictionary dictionaryWithDictionary:dic];
}
@end
