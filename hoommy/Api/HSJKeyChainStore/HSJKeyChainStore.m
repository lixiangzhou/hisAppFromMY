//
//  HSJKeyChainStore.m
//  hoommy
//
//  Created by caihongji on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJKeyChainStore.h"
#import "UICKeyChainStore.h"

@interface HSJKeyChainStore()

@property (nonatomic, strong) UICKeyChainStore *keychain;

@end

@implementation HSJKeyChainStore

- (instancetype)initWithService:(NSString *)service
{
    self = [super init];
    if (self) {
        self.keychain = [UICKeyChainStore keyChainStoreWithService:service];
    }
    
    return self;
}

//保存
- (void)setItemForKey:(id)item ForKey:(NSString *)key {
    if(key.length > 0) {
        self.keychain[key] = item;
    }
}

//移除
- (BOOL)removeItemForKey:(NSString *)key {
    if(key.length > 0) {
        return [self.keychain removeItemForKey:key];
    }
    return NO;
}

- (BOOL)removeAllItems {
    return [self.keychain removeAllItems];
}

//获取
- (id)itemForkey:(NSString*)key {
    if(key.length > 0) {
        return self.keychain[key];
    }
    
    return nil;
}

@end
