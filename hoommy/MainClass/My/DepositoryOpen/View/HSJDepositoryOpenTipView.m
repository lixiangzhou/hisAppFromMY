//
//  HSJDepositoryOpenTipView.m
//  hoommy
//
//  Created by lxz on 2018/7/24.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJDepositoryOpenTipView.h"
#import "HSJDepositoryOpenController.h"

@interface HSJDepositoryOpenTipView ()
@property (nonatomic, copy) void (^openBlock)(void);
@property (nonatomic, assign) BOOL isShowWithOpenBlock;
@end

@implementation HSJDepositoryOpenTipView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

+ (instancetype)shared {
    static HSJDepositoryOpenTipView *tipView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipView = [[HSJDepositoryOpenTipView alloc] initWithFrame:[HXBRootVCManager manager].mainTabbarVC.view.bounds];
    });
    return tipView;
}

#pragma mark - UI

- (void)setUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    UIView *contentView = [UIView new];
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"depository_tip_icon"]];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.numberOfLines = 2;
    promptLabel.font = kHXBFont_28;
    promptLabel.textColor = kHXBColor_666666_100;
    promptLabel.text = @"红小宝与恒丰银行完成存管对接\n用户资金有效隔离";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *openBtn = [UIButton new];
    [openBtn setTitle:@"立即开通恒丰银行存管账户" forState:UIControlStateNormal];
    openBtn.backgroundColor = [UIColor colorWithRed:227/255.0f green:191/255.0f blue:128/255.0f alpha:1];
    openBtn.titleLabel.font = kHXBFont_28;
    openBtn.layer.cornerRadius = 4;
    openBtn.layer.masksToBounds = YES;
    [openBtn addTarget:self action:@selector(openAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"depository_tip_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:iconView];
    [contentView addSubview:promptLabel];
    [contentView addSubview:openBtn];
    [self addSubview:closeBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(@kScrAdaptationW(-25));
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.top.equalTo(@kScrAdaptationW(10));
        make.left.equalTo(@kScrAdaptationW(6));
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(iconView.mas_bottom).offset(kScrAdaptationH(20));
    }];
    
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(18));
        make.right.equalTo(@kScrAdaptationW(-18));
        make.top.equalTo(promptLabel.mas_bottom).offset(kScrAdaptationH(20));
        make.height.offset(kScrAdaptationH(36));
        make.bottom.equalTo(@kScrAdaptationW(-30));
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(kScrAdaptationW(30));
        make.centerX.equalTo(self);
    }];
    
}

#pragma mark - Action
- (void)openAccountBtnClick {
    if (self.isShowWithOpenBlock) {
        if (self.openBlock) {
            self.openBlock();
        }
    } else {
        [[HXBRootVCManager manager].curNavigationVC pushViewController:[HSJDepositoryOpenController new] animated:YES];
        [self closeBtnClick];
    }
}

- (void)closeBtnClick {
    HSJDepositoryOpenTipView *tipView = [HSJDepositoryOpenTipView shared];
    
    tipView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        tipView.alpha = 0;
    } completion:^(BOOL finished) {
        [tipView removeFromSuperview];
    }];
}

#pragma mark - Public
+ (void)show {
    [self showWithOpenBlock:nil];
    [HSJDepositoryOpenTipView shared].isShowWithOpenBlock = NO;
}

+ (void)showWithOpenBlock:(void (^)(void))openBlock {
    HSJDepositoryOpenTipView *tipView = [HSJDepositoryOpenTipView shared];
    tipView.openBlock = openBlock;
    tipView.isShowWithOpenBlock = YES;
    
    [[HXBRootVCManager manager].mainTabbarVC.view addSubview:tipView];
    
    tipView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        tipView.alpha = 1;
    }];
}
@end
