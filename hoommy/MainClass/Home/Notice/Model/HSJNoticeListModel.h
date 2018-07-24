//
//  HSJNoticeListModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/24.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"

@interface HSJNoticeListModel : HSJBaseModel

/**
 ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 title
 */
@property (nonatomic, copy) NSString *title;
/**
 content
 */
@property (nonatomic, copy) NSString *content;
/**
 updateTime
 */
@property (nonatomic, copy) NSString *updateTime;
/**
 date
 */
@property (nonatomic, copy) NSString *date;

@end
