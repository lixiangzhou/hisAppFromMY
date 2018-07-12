//
//  HSJGesturePasswordController.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGesturePasswordController.h"
#import "NSString+HXBPhonNumber.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"


@interface HSJGesturePasswordController () <CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;
@end

@implementation HSJGesturePasswordController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    
    ((HXBBaseNavigationController *)self.navigationController).enableFullScreenGesture = NO;
    
    self.type = HSJGesturePasswordTypeSetting;
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
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    lockView.arrow = NO;
    lockView.centerY += 15;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.font = kHXBFont_PINGFANGSC_REGULAR(15);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
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
    self.isWhiteColourGradientNavigationBar = YES;
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    
    [self.lockView setType:CircleViewTypeSetting];
    [self.msgLabel showNormalMsg:gestureTextConnectLess];
}

/// 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
}
#pragma mark - Action

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = gesture;
    
    // 看是否存在第一个密码
    if ([gestureOne length] > CircleSetCountLeast) {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (equal) {
        NSLog(@"登陆成功！");
    } else {
        [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错了，还可输入%@次", KeyChain.gesturePwdCount]];
    }
}

@end
