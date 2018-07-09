//
//  HSJBankListModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/6.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJBankListModel : HSJBaseModel

/**
 name
 */
@property (nonatomic, copy) NSString *name;

/**
 single
 */
@property (nonatomic, copy) NSString *single;

/**
 day
 */
@property (nonatomic, copy) NSString *day;

/**
 bankCode
 */
@property (nonatomic, copy) NSString *bankCode;

/**
 对限额字符串处理
 */
@property (nonatomic, copy) NSString *quota;

@end
