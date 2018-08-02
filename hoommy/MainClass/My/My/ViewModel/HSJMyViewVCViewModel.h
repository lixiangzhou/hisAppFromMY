//
//  HSJMyViewVCViewModel.h
//  hoommy
//
//  Created by caihongji on 2018/7/12.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel.h"
#import "HXBMyRequestAccountModel.h"

@interface HSJMyViewVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) HXBUserInfoModel *userInfoModel;
@property (nonatomic, strong) HXBMyRequestAccountModel *accountModel;

- (void)downLoadAccountInfo:(void (^)(BOOL isSuccess))completion;

@end
