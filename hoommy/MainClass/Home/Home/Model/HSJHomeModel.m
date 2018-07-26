//
//  HSJHomeModel.m
//  hoommy
//
//  Created by HXB-C on 2018/7/23.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeModel.h"

@implementation HSJHomeModel

+ (Class)dataList_class {
    return [HSJHomePlanModel class];
}

+ (Class)bannerList_class {
    return [BannerModel class];
}

+ (Class)articleList_class {
   return [HSJHomeArtileModel class];
}

@end
