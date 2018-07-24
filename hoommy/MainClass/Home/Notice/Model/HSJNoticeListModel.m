//
//  HSJNoticeListModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/24.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJNoticeListModel.h"

@implementation HSJNoticeListModel

- (NSDictionary *)map {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [dic setObject:@"id" forKey:@"ID"];
    return [NSDictionary dictionaryWithDictionary:dic];
}

@end
