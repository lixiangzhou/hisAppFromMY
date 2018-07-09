//
//  HXBBindPhoneVCViewModel.h
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBBindPhoneCellModel.h"

typedef enum : NSUInteger {
    HXBBindPhoneStepFirst, //第一步
    HXBBindPhoneStepSecond,
    HXBBindPhoneStepThird,
} HXBBindPhoneStepType;

@interface HXBBindPhoneVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) NSArray* cellDataList;

- (void)buildCellDataList:(HXBBindPhoneStepType)bindPhoneStepType;

@end
