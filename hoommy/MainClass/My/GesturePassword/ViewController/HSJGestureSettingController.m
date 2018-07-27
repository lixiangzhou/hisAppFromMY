//
//  HSJGestureSettingController.m
//  hoommy
//
//  Created by lxz on 2018/7/12.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJGestureSettingController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"

@interface HSJGestureSettingController () <CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, weak) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, weak) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, weak) PCCircleInfoView *infoView;

@property (nonatomic, weak) UIButton *resetBtn;
@end

@implementation HSJGestureSettingController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ((HXBBaseNavigationController *)self.navigationController).enableFullScreenGesture = NO;
    
    [self setUI];
}

#pragma mark - UI

- (void)setUI {
    self.title = @"设置手势密码";
    self.isWhiteColourGradientNavigationBar = YES;
    
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, 40, 40);
    infoView.centerX = kScreenW * 0.5;
    infoView.top = 120 + HXBStatusBarAdditionHeight;
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, infoView.bottom + 50, kScreenW, 20);
    msgLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    [msgLabel showNormalMsg:@"设置手势密码"];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    lockView.arrow = NO;
    lockView.type = CircleViewTypeSetting;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    
    UIButton *resetBtn = [UIButton new];
    [resetBtn setTitle:@"重新设置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:UIColorFromRGB(0x9295a2) forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.titleLabel.font = kHXBFont_28;
    resetBtn.hidden = YES;
    self.resetBtn = resetBtn;
    [self.view addSubview:resetBtn];
    
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel.mas_bottom).offset(7);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@300);
    }];
    
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-65);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Action
- (void)reset {
    self.resetBtn.hidden = YES;
    [self infoViewDeselectedSubviews];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

#pragma mark - CircleViewDelegate - Setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = gesture;
    
    // 看是否存在第一个密码
    if ([gestureOne length] > CircleSetCountLeast) {
        self.resetBtn.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    self.resetBtn.hidden = NO;
    [self.msgLabel showNormalMsg:@"再次设置手势密码"];
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    self.resetBtn.hidden = equal;
    if (equal) {
        KeyChain.gesturePwd = gesture;
        KeyChain.gesturePwdCount = 5;
        KeyChain.skipGesture = kHXBGesturePwdSkipeNO;
        
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];

        __block UIViewController *popToVC = nil;
        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"HxbAccountInfoViewController")]) {
                popToVC = obj;
                *stop = YES;
            }
        }];
        
        if (popToVC && self.switchType == HXBAccountSecureSwitchTypeOn) {   // 从账户安全页进去的
            [self.navigationController popToViewController:popToVC animated:YES];
        } else if (self.switchType == HXBAccountSecureSwitchTypeChange) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        self.resetBtn.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - Helper
- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

@end
