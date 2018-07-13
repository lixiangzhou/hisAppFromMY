//
//  HXBAccountAlterLoginPasswordViewModel.h
//  hoomxb
//
//  Created by caihongji on 2018/3/1.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"

@interface HXBAccountAlterLoginPasswordViewModel : HSJBaseViewModel

- (void)mobifyPassword_LoginRequest_requestWithOldPwd: (NSString *)oldPassword
                                            andNewPwd: (NSString *)newPassword
                                      andSuccessBlock: (void(^)())successDateBlock
                                      andFailureBlock: (void(^)(NSError *error))failureBlock;
@end
