//
//  HXBBannerViewModel.h
//  hoomxb
//
//  Created by caihongji on 2018/2/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "BannerModel.h"
@interface HXBBannerViewModel : HSJBaseViewModel

@property (nonatomic, strong) BannerModel *model;

- (BOOL)isNeedShare;
- (void)share;

@end
