//
//  HSJPlanDetailViewModel.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailViewModel.h"
#import "TimerWeakTarget.h"
#import "HXBGeneralAlertVC.h"
#import "HSJRiskAssessmentViewController.h"
#import "HXBNsTimerManager.h"

@interface HSJPlanDetailViewModel ()
//@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) long long diffTime;
@property (nonatomic, assign) BOOL needCountDown;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) HXBNsTimerManager *timerManager;
@end

@implementation HSJPlanDetailViewModel

- (void)getDataWithId:(NSString *)planId resultBlock:(void (^)(BOOL))resultBlock {
    kWeakSelf
    if (KeyChain.isLogin) {
        __block BOOL loadedUserInfo = NO;
        __block BOOL loadedPlanInfo = NO;
        
        __block HSJPlanModel *planModel = nil;
        
        [self downLoadUserInfo:YES resultBlock:^(HXBUserInfoModel *userInfoModel, NSError *erro) {
            loadedUserInfo = YES;
            weakSelf.userInfoModel = userInfoModel;
            if (userInfoModel) {
                weakSelf.hasBuy = [userInfoModel.userInfo.hasEverInvestStepUp isEqualToString:@"1"];
            } else {
                weakSelf.hasBuy = NO;
            }
            if (loadedUserInfo && loadedPlanInfo) {
                weakSelf.planModel = planModel;
                resultBlock(planModel != nil);
            }
        }];
        
        [self getDataWithId:planId showHug:YES resultBlock:^(id responseData, NSError *erro) {
            loadedPlanInfo = YES;
            planModel = responseData;
            
            if (loadedUserInfo && loadedPlanInfo) {
                weakSelf.planModel = planModel;
                resultBlock(responseData != nil);
            }
        }];
        
    } else {
        [self getDataWithId:planId showHug:YES resultBlock:^(id responseData, NSError *erro) {
            weakSelf.hasBuy = NO;
            weakSelf.planModel = responseData;
            resultBlock(responseData != nil);
        }];
    }
    
}

#pragma mark - Helper
- (void)setPlanModel:(HSJPlanModel *)planModel {
    _planModel = planModel;
    
    if (planModel == nil) {
        return;
    }
    
    self.interestString = [NSString stringWithFormat:@"%@%%", planModel.expectedRate];//[self getInterestString];
    self.lockString = [self getLockString];
    self.startDateString = [self getStartDateString];
    self.endLockDateString = [self getEndLockDateString];
    self.interest = [self getInterestValue];
    
    [self setInState];
}

- (void)setInState {
    self.inTextColor = [UIColor whiteColor];
    self.inEnabled = NO;
    if (self.planModel.unifyStatus.integerValue < 6) {
        self.diffTime = self.planModel.diffTime.longLongValue * 0.001;
        [self startTimer];
    }
    
    self.inTextColor = [UIColor whiteColor];
    self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_disable_bg"];
    self.inEnabled = NO;
    switch (self.planModel.unifyStatus.integerValue) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        {
            if (self.needCountDown) {
                self.inText = [NSString stringWithFormat:@"%02lld:%02lld后开售", self.diffTime / 60, self.diffTime % 60];
            } else {
                NSDate *date = [[HXBBaseHandDate sharedHandleDate] returnDateWithOBJ:self.planModel.beginSellingTime  andDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateStr = @(date.timeIntervalSince1970).description;
                self.inText = [[HXBBaseHandDate sharedHandleDate] stringFromDate:dateStr andDateFormat:@"MM-dd开售"];
            }
        }
            break;
        case 6:
            self.inText = @"转入";
            self.inEnabled = YES;
            self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_normal_bg"];
            self.inEnabled = YES;
            break;
        case 7:
        case 8:
        case 9:
        case 10:
            self.inText = @"销售结束";
            break;
    }
}

- (NSString *)getInterestString {
    if (self.planModel.extraInterestRate.doubleValue != 0) {
        return [NSString stringWithFormat:@"%@%%+%@%%", self.planModel.baseInterestRate, self.planModel.extraInterestRate];
    } else {
        return [NSString stringWithFormat:@"%@%%", self.planModel.baseInterestRate];
    }
}

- (double)getInterestValue {
    return (self.planModel.baseInterestRate.doubleValue + self.planModel.extraInterestRate.doubleValue) * 0.01;
}

- (NSString *)getLockString {
    if (self.planModel.lockPeriod.length) {
        return [NSString stringWithFormat:@"%@个月", self.planModel.lockPeriod];
    }
    
    if (self.planModel.lockDays) {
        return [NSString stringWithFormat:@"%d天", self.planModel.lockDays];
    }
    
    return  @"--";
}

- (NSString *)getStartDateString {
    NSString *dateString = [self.planModel.financeEndTime componentsSeparatedByString:@" "].firstObject;
    NSArray *ymd = [dateString componentsSeparatedByString:@"-"];
    NSString *month = ymd[1];
    NSString *day = ymd[2];
    return [NSString stringWithFormat:@"%zd.%zd", [month integerValue], [day integerValue]];
}

- (NSString *)getEndLockDateString {
    NSString *dateString = [self.planModel.endLockingTime componentsSeparatedByString:@" "].firstObject;
    NSArray *ymd = [dateString componentsSeparatedByString:@"-"];
    NSString *month = ymd[1];
    NSString *day = ymd[2];
    return [NSString stringWithFormat:@"%zd.%zd", [month integerValue], [day integerValue]];
}

#pragma mark - Action
//- (void)timerAction {
//    if (self.needCountDown) {
//        self.inText = [NSString stringWithFormat:@"%02lld:%02lld后开售", self.diffTime / 60, self.diffTime % 60];
//        self.inTextColor = [UIColor whiteColor];
//        self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_disable_bg"];
//        self.inEnabled = NO;
//        self.diffTime -= 1;
//    } else if (self.diffTime < 0) {
//        self.inText = @"转入";
//        self.inTextColor = [UIColor whiteColor];
//        self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_normal_bg"];
//        self.inEnabled = YES;
//        [self stopTimer];
//    } else {    // XX-XX 后开售时，也要倒计时
//        self.diffTime -= 1;
//    }
//
//    if (self.timerBlock) {
//        self.timerBlock();
//    }
//}

#pragma mark - Timer
- (void)startTimer {
//    [self stopTimer];
    
    if (self.diffTime > 0) {
//        self.timer = [TimerWeakTarget scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        self.timerManager = [HXBNsTimerManager createTimer:1 startSeconds:0 countDownTime:NO notifyCall:^(NSString *times) {
            long temp = self.diffTime - times.doubleValue;
            if(temp < 0) {
                self.inText = @"转入";
                self.inTextColor = [UIColor whiteColor];
                self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_normal_bg"];
                self.inEnabled = YES;
                
                [self.timerManager stopTimer];
            } else if (temp < 3600) {
                self.inText = [NSString stringWithFormat:@"%02lld:%02lld后开售", temp / 60, temp % 60];
                self.inTextColor = [UIColor whiteColor];
                self.inBackgroundImage = [UIImage imageNamed:@"plandetail_btn_disable_bg"];
                self.inEnabled = NO;
            }
            
            if (self.timerBlock) {
                self.timerBlock();
            }
           
//            if(timerBlock) {
//                weakSelf.timerContent = [weakSelf makeTimerContent:times.intValue];
//                timerBlock();
//            }
        }];
        [self.timerManager startTimer];
    }
}

#pragma mark - Getter
- (BOOL)needCountDown {
    return self.diffTime >= 0 && self.diffTime <= 3600;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"mm:ss后开售";
    }
    return _dateFormatter;
}

- (void)dealloc
{
    [self.timerManager stopTimer];
}
@end
