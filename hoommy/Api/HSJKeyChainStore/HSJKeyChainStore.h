//
//  HSJKeyChainStore.h
//  hoommy
//
//  Created by caihongji on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSJKeyChainStore : NSObject
//初始化
- (instancetype)initWithService:(NSString *)service;

//保存
- (void)setItemForKey:(id)item ForKey:(NSString *)key;

//移除
- (BOOL)removeItemForKey:(NSString *)key;
- (BOOL)removeAllItems;

//获取
- (id)itemForkey:(NSString*)key;
@end
