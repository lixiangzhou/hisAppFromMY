//
//  HSJHomeArtileModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/24.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJHomeArtileModel : HSJBaseModel
/**
id
*/
@property (nonatomic, copy) NSString *ID;
/**
title
*/
@property (nonatomic, copy) NSString *title;
/**
 tag
*/
@property (nonatomic, copy) NSString *tag;

/**
 跳转的连接地址
 */
@property (nonatomic, copy) NSString *link;

@end
