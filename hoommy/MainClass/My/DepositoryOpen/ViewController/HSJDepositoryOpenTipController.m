//
//  HSJDepositoryOpenTipController.m
//  hoommy
//
//  Created by lxz on 2018/7/9.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJDepositoryOpenTipController.h"
#import "HSJDepositoryOpenController.h"

@interface HSJDepositoryOpenTipController ()
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *promptLabel;
/**
 完成按钮
 */
@property (nonatomic, strong) UIButton *openBtn;
@end

@implementation HSJDepositoryOpenTipController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通恒丰银行存管账户";
    [self setUI];  
}

#pragma mark - UI

- (void)setUI {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.openBtn];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kScrAdaptationH(46) + 64);
        make.height.offset(kScrAdaptationH(216));
        make.width.offset(kScrAdaptationW(250));
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconView.mas_bottom).offset(kScrAdaptationH(40));
        make.width.equalTo(self.iconView.mas_width);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(20));
        make.right.equalTo(self.view).offset(kScrAdaptationW(-20));
        make.top.equalTo(self.promptLabel.mas_bottom).offset(kScrAdaptationH(40));
        make.height.offset(kScrAdaptationH(41));
    }];
}

#pragma mark - Action
- (void)openAccountBtnClick
{
//    [HXBUmengManagar HXB_clickEventWithEnevtId:kHXBUmeng_registSuccess_lead];
    HSJDepositoryOpenController *openVC = [[HSJDepositoryOpenController alloc] init];
    openVC.title = @"开通存管账户";
    [self.navigationController pushViewController:openVC animated:YES];
}

#pragma mark - Setter / Getter / Lazy
- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.numberOfLines = 0;
        _promptLabel.font = kHXBFont_PINGFANGSC_REGULAR(16);
        _promptLabel.textColor = kHXBColor_666666_100;
        _promptLabel.text = @"红小宝与恒丰银行完成存管对接\n用户资金有效隔离";
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open_depository_bank"]];
    }
    return _iconView;
}

- (UIButton *)openBtn
{
    if (!_openBtn) {
        _openBtn = [UIButton new];
        [_openBtn setTitle:@"立即开通恒丰银行存管账户" forState:UIControlStateNormal];
        _openBtn.backgroundColor = [UIColor colorWithRed:227/255.0f green:191/255.0f blue:128/255.0f alpha:1];
        [_openBtn addTarget:self action:@selector(openAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

@end
