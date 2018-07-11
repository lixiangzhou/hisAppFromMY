//
//  HSJGesturePasswordController.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGesturePasswordController.h"
#import "HXBLockLabel.h"
#import "HXBCircleView.h"
#import "HXBCircleViewConst.h"

typedef enum{
    HSJGesturePasswordButtonTagReset = 1,
    HSJGesturePasswordButtonTagManager,
    HSJGesturePasswordButtonTagForget
    
}HSJGesturePasswordButtonTag;

@interface HSJGesturePasswordController () <HXBCircleViewDelegate, UIGestureRecognizerDelegate>
/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;
/**
 *  提示Title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  提示Title
 */
@property (nonatomic, strong) UILabel *phoneLabel;
/**
 *  提示Label
 */
@property (nonatomic, strong) HXBLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) HXBCircleView *lockView;
@end

@implementation HSJGesturePasswordController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];  
}

#pragma mark - UI

- (void)setUI {
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

/// 界面相同部分生成器
- (void)setupSameUI
{
    // 解锁界面
    HXBCircleView *lockView = [[HXBCircleView alloc] init];
    lockView.delegate = self;
    lockView.arrow = NO;
    lockView.isDisplayTrajectory = YES;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    HXBLockLabel *msgLabel = [[HXBLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.resetBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(kScrAdaptationH(82) + HXBStatusBarAdditionHeight);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(kScrAdaptationH(-70));
        make.centerX.equalTo(self.view);
        make.height.offset(kScrAdaptationH(15));
        make.width.offset(kScrAdaptationW(74));
    }];
}

/// 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case HSJGesturePasswordTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case HSJGesturePasswordTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

/// 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    self.title = @"设置手势密码";
    self.isWhiteColourGradientNavigationBar = YES;
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(10));
    }];
    
    [self.lockView setType:CircleViewTypeSetting];
    
    self.titleLabel.text = gestureTextBeforeSet;
    [self.msgLabel showNormalMsg:gestureTextConnectLess];
}

/// 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    self.titleLabel.text = @"您好";
    [self.lockView setType:CircleViewTypeLogin];
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
//    phoneLabel.text = [KeyChain.mobile replaceStringWithStartLocation:3 lenght:4];
    phoneLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    phoneLabel.textColor = RGB(51, 51, 51);
    self.phoneLabel = phoneLabel;
    [self.view addSubview:self.phoneLabel];
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"账号密码登录" alignment:UIControlContentHorizontalAlignmentCenter tag:HSJGesturePasswordButtonTagManager];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(kScrAdaptationH(-70));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(16));
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(kScrAdaptationH(10));
    }];
    
}
#pragma mark - Action
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case HSJGesturePasswordButtonTagReset:
        {
            NSLog(@"点击了重设按钮");
            self.title = @"设置手势密码";
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextConnectLess];
            self.titleLabel.text = gestureTextBeforeSet;
            // 4.清除之前存储的密码
            [self.lockView resetGesturePassword];
        }
            break;
        case HSJGesturePasswordButtonTagManager:
        {
            NSLog(@"点击了账户密码登录");
//            [KeyChain signOut];
            [self.view removeFromSuperview];
//            [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
        }
            break;
        case HSJGesturePasswordButtonTagForget:
            NSLog(@"点击了登录其他账户按钮");
            
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = gesture;
    
    // 看是否存在第一个密码
    if ([gestureOne length] > CircleSetCountLeast) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    
    self.title = @"确认手势密码";
    self.titleLabel.text = gestureTextDrawAgain;
    [self.resetBtn setHidden:NO];
    
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
}

- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
//        KeyChain.gesturePwd = gesture;
//        KeyChain.gesturePwdCount = @"5";
//        [kUserDefaults setBool:YES forKey:kHXBGesturePWD];
//        [kUserDefaults synchronize];
        
        __block UIViewController *popToVC = nil;
        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[HxbMyAccountSecurityViewController class]]) {
//                popToVC = obj;
//                *stop = YES;
//            }
        }];
        
//        KeyChain.skipGesture = kHXBGesturePwdSkipeNO;
        
        if (popToVC && self.switchType == HSJAccountSecureSwitchTypeOn) {   // 从账户安全页进去的
            [self.navigationController popToViewController:popToVC animated:YES];
        } else if (self.switchType == HSJAccountSecureSwitchTypeChange) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {    // 启动的时候进去的
            if (self.dismissBlock) {
                self.dismissBlock(NO, NO, YES);
            }
        }
        
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(HXBCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
//            KeyChain.gesturePwdCount = @"5";
            if (self.dismissBlock) {
                self.dismissBlock(YES, YES, YES);
            }
        } else {
            NSLog(@"密码错误！");
//            int cout = [KeyChain.gesturePwdCount intValue];
//            cout--;
//            KeyChain.gesturePwdCount = [NSString stringWithFormat:@"%d",cout];
//            if (cout <= 0) {
//                HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"温馨提示" andSubTitle:@"很抱歉，您的手势密码五次输入错误" andLeftBtnName:@"取消" andRightBtnName:@"确定" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
//                alertVC.isCenterShow = YES;
//                [KeyChain removeGesture];
//                KeyChain.skipGesture = kHXBGesturePwdSkipeYES;
//                [KeyChain signOut];
//                alertVC.leftBtnBlock = ^{
//                    if (self.dismissBlock) {
//                        self.dismissBlock(NO, NO, YES);
//                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
//                };
//                alertVC.rightBtnBlock = ^{
//                    if (self.dismissBlock) {
//                        self.dismissBlock(NO, NO, NO);
//                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_RefreshHomeData object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:@{kHXBMY_VersionUpdateURL : @YES}];
//                };
//
//                [self presentViewController:alertVC animated:NO completion:nil];
//                return;
//            }
//            [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错了，还可输入%@次", KeyChain.gesturePwdCount]];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - Helper
- (void)checkAlertSkipSetting {
    if (self.type == HSJGesturePasswordTypeSetting && self.switchType == HSJAccountSecureSwitchTypeNone) {
        [self alertSkipSetting];
    }
}

- (void)alertSkipSetting {
//    // 忽略手势密码弹窗提示
//    BOOL appeared = KeyChain.skipGestureAlertAppeared;
//    if (appeared == NO) {
//        // 弹窗
//        HXBGeneralAlertVC *alertVC = [[HXBGeneralAlertVC alloc] initWithMessageTitle:@"设置手势密码" andSubTitle:@"为了您的账户安全，\n建议您设置手势密码" andLeftBtnName:@"跳过设置" andRightBtnName:@"开始设置" isHideCancelBtn:YES isClickedBackgroundDiss:NO];
//        alertVC.isCenterShow = YES;
//        alertVC.leftBtnBlock = ^{
//            KeyChain.skipGesture = kHXBGesturePwdSkipeYES;
//            [KeyChain removeGesture];
//            if (self.dismissBlock) {
//                self.dismissBlock(NO, NO, YES);
//            }
//            // 只出现一次弹窗
//            KeyChain.skipGestureAlertAppeared = YES;
//        };
//
//        [self presentViewController:alertVC animated:NO completion:nil];
//    }
}

- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    [btn setTitleColor:RGB(115, 173, 255) forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

#pragma mark - Lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(19);
        _titleLabel.textColor = rgba(51, 51, 51, 1.0);
    }
    return _titleLabel;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc] init];
        [_resetBtn setTitle:@"重新绘制" forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.titleLabel.font =kHXBFont_PINGFANGSC_REGULAR(15);
        _resetBtn.tag = HSJGesturePasswordButtonTagReset;
        [_resetBtn setHidden:YES];
        [_resetBtn setTitleColor:RGB(115, 173, 255) forState:UIControlStateNormal];
    }
    return _resetBtn;
}
@end
