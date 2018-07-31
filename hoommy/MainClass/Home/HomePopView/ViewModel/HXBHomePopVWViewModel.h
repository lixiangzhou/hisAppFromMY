//
//  HXBHomePopVWViewModel.h
//  hoomxb
//
//  Created by hxb on 2017/12/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
@class HXBHomePopVWModel;

@interface HXBHomePopVWViewModel : HSJBaseViewModel

@property (nonatomic,strong)HXBHomePopVWModel *homePopModel;

- (void)homePopViewRequestSuccessBlock: (void(^)(BOOL isSuccess))successDateBlock;

@end
