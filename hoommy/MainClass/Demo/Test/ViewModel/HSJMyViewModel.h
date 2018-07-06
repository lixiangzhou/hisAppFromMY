//
//  HSJMyViewModel.h
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/17.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBVersionUpdateModel.h"

@interface HSJMyViewModel : HSJBaseViewModel

@property (nonatomic, strong) HXBVersionUpdateModel* model;

- (void)getBaiduData;
@end
