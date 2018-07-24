//
//  HSJHomeModel.h
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseModel.h"
#import "HSJPlanModel.h"
#import "BannerModel.h"
@interface HSJHomeModel : HSJBaseModel

@property (nonatomic, strong) NSArray<HSJPlanModel *> *dataList;

@property (nonatomic, strong) NSArray<BannerModel *> *bannerList;

@property (nonatomic, assign) double end;

@property (nonatomic, assign) double updateTime;

@end
