//
//  HSJGlobalInfoManager.m
//  hoommy
//
//  Created by lxz on 2018/7/17.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGlobalInfoManager.h"

#define kGlobalInfoKey @"kGlobalInfoKey"

@interface HSJGlobalInfoManager ()
@property (nonatomic, assign) NSInteger retryCount;
@end

@implementation HSJGlobalInfoManager
+ (instancetype)shared {
    static HSJGlobalInfoManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HSJGlobalInfoManager new];
        manager.retryCount = 0;
    });
    return manager;
}

- (void)getData {
    [self getData:nil];
}

- (void)getData:(void (^)(HSJGlobalInfoModel *))resultBlock {
    if (self.infoModel) {
        resultBlock(self.infoModel);
        return;
    }
    kWeakSelf
    [self loadData:^(NYBaseRequest *request) {
        request.showHud = NO;
        request.hudShowContent = nil;
        
        request.requestUrl = kGlobal;
        request.modelType = [HSJGlobalInfoModel class];
    } responseResult:^(id responseData, NSError *erro) {
        self.infoModel = responseData;
        
        if (resultBlock) {
            self.retryCount = 0;
            resultBlock(responseData);
        } else {
            if (responseData == nil) {
                if (self.retryCount <= 3) {
                    self.retryCount += 1;
                    // 没有获取到数据就获取
                    [weakSelf getData:nil];
                }
            }
        }
        
    }];
}

- (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:date];
}

@end
