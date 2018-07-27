//
//  HSJHomeModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"
#import "HSJHomePlanModel.h"
#import "BannerModel.h"
#import "HSJHomeArtileModel.h"
@interface HSJHomeModel : HSJBaseModel

@property (nonatomic, strong) NSArray<HSJHomePlanModel *> *dataList;

@property (nonatomic, strong) NSArray<BannerModel *> *bannerList;

@property (nonatomic, strong) NSArray<HSJHomeArtileModel *> *articleList;

@property (nonatomic, assign) double end;

@property (nonatomic, assign) double updateTime;

@end
