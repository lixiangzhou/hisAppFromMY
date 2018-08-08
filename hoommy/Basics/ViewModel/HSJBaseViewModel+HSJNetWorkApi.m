//
//  HSJBaseViewModel+HSJNetWorkApi.m
//  HSFrameProject
//
//  Created by caihongji on 2018/4/27.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBaseViewModel+HSJNetWorkApi.h"
#import "HSJDepositoryOpenTipView.h"
#import "HXBGeneralAlertVC.h"
#import "HSJRiskAssessmentViewController.h"

@implementation HSJBaseViewModel (HSJNetWorkApi)

@dynamic userInfoModel;
static const char HXBUserInfoModelKey = '\0';
- (void)setInnerUserInfoModel:(HXBUserInfoModel *)innerUserInfoModel {
    objc_setAssociatedObject(self, &HXBUserInfoModelKey, innerUserInfoModel, OBJC_ASSOCIATION_RETAIN);
}

- (HXBUserInfoModel *)innerUserInfoModel {
    return objc_getAssociatedObject(self, &HXBUserInfoModelKey);
}

- (void)checkVersionUpdate:(NetWorkResponseBlock)resultBlock {
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBMY_VersionUpdateURL;
        request.requestMethod = NYRequestMethodPost;
        request.showHud = YES;
        request.modelType = NSClassFromString(@"HXBVersionUpdateModel");
        request.requestArgument = @{
                                    @"versionCode" : version
                                    };
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

- (void)downLoadUserInfo:(BOOL)isShowHud resultBlock:(void(^)(HXBUserInfoModel *userInfoModel, NSError* erro))resultBlock {
    if(!KeyChain.isLogin) {
        return;
    }
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.showHud= isShowHud;
        request.hudDelegate = weakSelf;
        request.requestUrl = kHXBUser_UserInfoURL;
        request.requestMethod = NYRequestMethodGet;
        request.modelType = NSClassFromString(@"HXBUserInfoModel");
    } responseResult:^(id responseData, NSError *erro) {
        if (responseData) {
            self.innerUserInfoModel = responseData;
        }
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}

/**
 获取短信验证码和语音验证码
 
 @param requestBlock 请求配置的block
 @param resultBlock 请求结果回调的block
 */
- (void)verifyCodeRequestWithResultBlock:(void(^)(NYBaseRequest* request)) requestBlock resultBlock:(void(^)(id responseObject, NSError *error))resultBlock {
    NYBaseRequest *versionUpdateAPI = [[NYBaseRequest alloc] initWithDelegate:self];
    versionUpdateAPI.requestUrl = kHXBUser_smscodeURL;
    versionUpdateAPI.requestMethod = NYRequestMethodPost;
    if (requestBlock) {
        requestBlock(versionUpdateAPI);
    }
    [versionUpdateAPI loadData:^(NYBaseRequest *request, id responseObject) {
        if (resultBlock) {
            resultBlock(responseObject,nil);
        }
    } failure:^(NYBaseRequest *request, NSError *error) {
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}

- (void)getDataWithId:(NSString *)planId showHug:(BOOL)isShow resultBlock:(NetWorkResponseBlock)resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.modelType = NSClassFromString(@"HSJPlanModel");
        request.requestUrl = kHXBFinanc_PlanDetaileURL(planId.integerValue);
        request.showHud = isShow;
    } responseResult:^(id responseData, NSError *erro) {
        if(resultBlock) {
            resultBlock(responseData, erro);
        }
    }];
}


/**
登出

 @param isShowHud 是否显示loading
 @param resultBlock 结果回调
 */
- (void)userLogOut:(BOOL)isShowHud resultBlock:(NetWorkResponseBlock)resultBlock {
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_signOutURL;
        request.requestMethod = NYRequestMethodPost;
        request.showHud = isShowHud;
    } responseResult:^(id responseData, NSError *erro) {
        if(!erro) {
            NSString *ges = KeyChain.gesturePwd;
            [KeyChain signOut];
            KeyChain.gesturePwd = ges;
        }
        if(resultBlock) {
            resultBlock(resultBlock, erro);
        }
    }];
}

#pragma mark - 开户和风险评测
- (void)checkDepositoryAndRiskFromController:(UIViewController *)controller finishBlock:(void (^)(void))finishBlock {
    if (KeyChain.isLogin) {
        // 已开户并且做过风险评测就直接执行 finishBlock
        if (self.innerUserInfoModel.userInfo.isCreateEscrowAcc == YES && [self.innerUserInfoModel.userInfo.riskType isEqualToString:@"立即评测"] == NO) {
            if (finishBlock) {
                finishBlock();
            }
        } else {
            kWeakSelf
            [self downLoadUserInfo:YES resultBlock:^(HXBUserInfoModel *userInfoModel, NSError *erro) {
                if (userInfoModel.userInfo.isCreateEscrowAcc == NO) {
                    [HSJDepositoryOpenTipView show];
                } else if ([userInfoModel.userInfo.riskType isEqualToString:@"立即评测"]) {
                    [weakSelf riskTypeAssementFrom:controller resultBlock:nil];
                } else {
                    if (finishBlock) {
                        finishBlock();
                    }
                }
            }];
        }
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
    }
}

- (void)riskTypeAssementFrom:(UIViewController *)controller resultBlock:(void (^)(void))finishBlock {
    HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"" andSubTitle:@"您尚未进行风险评测，请评测后再进行出借" andLeftBtnName:@"我是保守型" andRightBtnName:@"立即评测" isHideCancelBtn:YES isClickedBackgroundDiss:YES];
    kWeakSelf
    [alertVC setLeftBtnBlock:^{
        [weakSelf setRiskTypeDefaultAndResultBlock:^{
            if (finishBlock) {
                finishBlock();
            }
        }];
    }];
    [alertVC setRightBtnBlock:^{
        HSJRiskAssessmentViewController *riskAssessmentVC = [[HSJRiskAssessmentViewController alloc] init];
        [controller.navigationController pushViewController:riskAssessmentVC animated:YES];
        __weak typeof(riskAssessmentVC) weakRiskAssessmentVC = riskAssessmentVC;
        riskAssessmentVC.popBlock = ^(NSString *type) {
            [weakRiskAssessmentVC.navigationController popToViewController:controller animated:YES];
        };
        if (finishBlock) {
            finishBlock();
        }
    }];
    
    [controller presentViewController:alertVC animated:NO completion:nil];
}

- (void)setRiskTypeDefaultAndResultBlock:(void (^)(void))finishBlock
{
    [self loadData:^(NYBaseRequest *request) {
        request.requestUrl = kHXBUser_riskModifyScoreURL;
        request.requestMethod = NYRequestMethodPost;
        request.requestArgument = @{@"score": @"0"};
    } responseResult:^(id responseData, NSError *erro) {
        if (!erro) {
            if (finishBlock) {
                finishBlock();
            }
        }
    }];
}
@end
