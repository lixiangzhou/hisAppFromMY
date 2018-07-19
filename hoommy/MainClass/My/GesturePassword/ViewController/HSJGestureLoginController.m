//
//  HSJGestureLoginController.m
//  hoommy
//
//  Created by lxz on 2018/7/12.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGestureLoginController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "NSString+HXBPhonNumber.h"
#import "NSDate+IDPExtension.h"
#import "HXBGeneralAlertVC.h"
#import "HXBAdvertiseManager.h"

@interface HSJGestureLoginController () <CircleViewDelegate>
/**
 *  提示Label
 */
@property (nonatomic, weak) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, weak) PCCircleView *lockView;

@property (nonatomic, weak) UIButton *btn;
@property (nonatomic, weak) UIButton *skipBtn;
@end

@implementation HSJGestureLoginController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    
    ((HXBBaseNavigationController *)self.navigationController).enableFullScreenGesture = NO;
    
    [self setUI];
}

#pragma mark - UI

- (void)setUI {
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.attributedText = [self getDateAttributeString];
    dateLabel.textColor = kHXBColor_333333_100;
    dateLabel.frame = CGRectMake(25, 64 + HXBStatusBarAdditionHeight, kScreenH - 50, 45);
    [self.view addSubview:dateLabel];
    
    UILabel *mobileLabel = [UILabel new];
    mobileLabel.text = [NSString stringWithFormat:@"欢迎回来 %@", [KeyChain.mobile replaceStringWithStartLocation:3 lenght:4]];
//    mobileLabel.text = @"欢迎回来 133****3213";
    mobileLabel.textColor = kHXBColor_333333_100;
    mobileLabel.font = kHXBFont_28;
    mobileLabel.frame = CGRectMake(dateLabel.x, dateLabel.bottom, kScreenH - 50, 20);
    [self.view addSubview:mobileLabel];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, mobileLabel.bottom + 40, kScreenW, 20);
    msgLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    lockView.arrow = NO;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    
    UIButton *btn = [UIButton new];
    
    [btn setTitleColor:UIColorFromRGB(0x9295a2) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = kHXBFont_28;
    self.btn = btn;
    [self.view addSubview:btn];
    
    switch (self.type) {
        case HSJGestureTypeLogin:
        {
            [msgLabel showNormalMsg:nil];
            lockView.type = CircleViewTypeLogin;
            
            btn.hidden = NO;
            [btn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        }
            break;
        case HSJGestureTypeSetting:
        {
            [msgLabel showNormalMsg:@"设置手势密码"];
            lockView.type = CircleViewTypeSetting;
            
            btn.hidden = YES;
            [btn setTitle:@"重新设置" forState:UIControlStateNormal];
            
            if (self.showSkip) {            
                UIButton *skipBtn = [UIButton new];
                [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
                [skipBtn setTitleColor:UIColorFromRGB(0x488CFF) forState:UIControlStateNormal];
                [skipBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
                skipBtn.titleLabel.font = kHXBFont_28;
                [skipBtn sizeToFit];
                [self.view addSubview:skipBtn];
                self.skipBtn = skipBtn;
                [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.centerX.equalTo(btn);
                }];
            }
        }
            break;
    }
    
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel.mas_bottom).offset(7);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@300);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-111);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Action
- (void)click {
    switch (self.type) {
        case HSJGestureTypeLogin:
            [KeyChain signOut];
            [self.view removeFromSuperview];
            [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
            break;
        case HSJGestureTypeSetting:
            self.btn.hidden = YES;
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            break;
    }
}

- (void)skip {
    KeyChain.skipGesture = kHXBGesturePwdSkipeYES;
    [KeyChain removeGesture];
    if (self.dismissBlock) {
        self.dismissBlock(NO, NO, YES);
    }
    // 只出现一次弹窗
    KeyChain.skipGestureAlertAppeared = YES;
}

#pragma mark - CircleViewDelegate - Setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    self.skipBtn.hidden = YES;
    
    NSString *gestureOne = gesture;
    
    // 看是否存在第一个密码
    if ([gestureOne length] > CircleSetCountLeast) {
        self.btn.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    self.skipBtn.hidden = YES;
    
    NSLog(@"获得第一个手势密码%@", gesture);
    self.btn.hidden = NO;
    [self.msgLabel showNormalMsg:@"再次设置手势密码"];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        
        KeyChain.gesturePwd = gesture;
        KeyChain.gesturePwdCount = 5;
        KeyChain.skipGesture = kHXBGesturePwdSkipeNO;
        
        if (self.dismissBlock) {
            self.dismissBlock(NO, NO, YES);
        }
    } else {
        self.btn.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - CircleViewDelegate - Login
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (equal) {
        NSLog(@"登陆成功！");
        KeyChain.gesturePwdCount = 5;
        if (self.dismissBlock) {
            self.dismissBlock(YES, YES, YES);
        }
    } else {
        KeyChain.gesturePwdCount -= 1;
        if (KeyChain.gesturePwdCount <= 0) {
            HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"温馨提示" andSubTitle:@"很抱歉，您的手势密码五次输入错误" andLeftBtnName:@"取消" andRightBtnName:@"确定" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
            alertVC.isCenterShow = YES;
            [KeyChain removeGesture];
            KeyChain.skipGesture = kHXBGesturePwdSkipeYES;
            [KeyChain signOut];
            
            kWeakSelf
            alertVC.leftBtnBlock = ^{
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock(NO, NO, YES);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
            };
            alertVC.rightBtnBlock = ^{
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock(NO, NO, NO);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:@{kHXBMY_VersionUpdateURL : @YES}];
            };
            
            [self presentViewController:alertVC animated:NO completion:nil];
        } else {
            [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错了，还可输入%zd次", KeyChain.gesturePwdCount]];
        }
    }
}

#pragma mark - Helper
- (NSAttributedString *)getDateAttributeString {
    NSDate *date = [NSDate new];
    
    NSString *month = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"][date.month - 1];
    NSString *weakday = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"][date.weekday - 1];
    
    NSMutableAttributedString *dateAttributeString = [NSMutableAttributedString new];
    [dateAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd", date.day] attributes:@{NSFontAttributeName: kHXBFont_64}]];
    [dateAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@. %@", month, weakday] attributes:@{NSFontAttributeName: kHXBFont_24}]];
    
    return dateAttributeString;
}

@end
