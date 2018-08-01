//
//  HSJPlanDetailController.m
//  hoommy
//
//  Created by lxz on 2018/7/13.
//Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanDetailController.h"
#import "HSJPlanDetailTopView.h"
#import "HSJPlanDetailRulerView.h"
#import "HSJPlanDetailAdvantageView.h"
#import "HSJPlanDetailInfoView.h"
#import "HSJPlanDetailViewModel.h"
#import "HSJRollOutController.h"
#import "HSJBuyViewController.h"
#import "HSJEarningCalculatorView.h"
#import "HSJSignInViewController.h"
#import "HSJDepositoryOpenTipView.h"

@interface HSJPlanDetailController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *navView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *navViewBottomLine;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) HSJPlanDetailTopView *topView;
@property (nonatomic, weak) HSJPlanDetailRulerView *rulerView;
@property (nonatomic, weak) HSJPlanDetailAdvantageView *advantageView;
@property (nonatomic, weak) HSJPlanDetailInfoView *infoView;

@property (nonatomic, strong) HSJPlanDetailViewModel *viewModel;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIView *bottomContentView;
@property (nonatomic, weak) UIButton *inBtn;
@end

@implementation HSJPlanDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    
    self.viewModel = [HSJPlanDetailViewModel new];
    
    [self setUI];
    
    [self getData];
    
    kWeakSelf
    self.viewModel.timerBlock = ^(void) {
        [weakSelf updateInBtnState];
    };
}

#pragma mark - UI

- (void)setUI {
    [self setupNavView];
    
    [self setupScrollView];
    
    [self setupBottomView];
}


- (void)setupNavView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HXBStatusBarAndNavigationBarHeight)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    self.navView = navView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HXBStatusBarHeight, kScreenWidth, 44)];
    titleLabel.font = kHXBFont_34;
    titleLabel.textColor = kHXBColor_564727_100;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HXBStatusBarHeight, 42, 44)];
    [backBtn setImage:[UIImage imageNamed:@"detail_back_dark"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.adjustsImageWhenHighlighted = NO;
    [navView addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIView *navViewBottomLine = [UIView new];
    navViewBottomLine.backgroundColor = kHXBColor_EEEEF5_100;
    navViewBottomLine.hidden = YES;
    [navView addSubview:navViewBottomLine];
    self.navViewBottomLine = navViewBottomLine;
    [navViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(navView);
        make.height.equalTo(@0.5);
    }];
}


- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view insertSubview:scrollView belowSubview:self.navView];
    
    HSJPlanDetailTopView *topView = [HSJPlanDetailTopView new];
    kWeakSelf
    topView.calBlock = ^{
        [weakSelf calClick];
    };
    [self.scrollView addSubview:topView];
    self.topView = topView;
    
    HSJPlanDetailRulerView *rulerView = [HSJPlanDetailRulerView new];
    [self.scrollView addSubview:rulerView];
    self.rulerView = rulerView;
    
    HSJPlanDetailAdvantageView *advantageView = [HSJPlanDetailAdvantageView new];;
    [self.scrollView addSubview:advantageView];
    self.advantageView = advantageView;
    
    HSJPlanDetailInfoView *infoView = [HSJPlanDetailInfoView new];
    [self.scrollView addSubview:infoView];
    self.infoView = infoView;

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(scrollView);
        make.width.equalTo(@kScreenWidth);
    }];
    
    [rulerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(topView);
    }];
    
    [advantageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rulerView.mas_bottom);
        make.left.right.equalTo(topView);
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(advantageView.mas_bottom).offset(kScrAdaptationW(10));
        make.left.right.equalTo(topView);
    }];
    
    [self.view layoutIfNeeded];
    scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(infoView.frame) + 80 + HXBBottomAdditionHeight);
}

- (void)setupBottomView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *bottomContentView = [UIView new];
    [bottomView addSubview:bottomContentView];
    self.bottomContentView = bottomContentView;
    
    UIView *sepLine = [UIView new];
    sepLine.backgroundColor = kHXBColor_ECECEC_100;
    [bottomView addSubview:sepLine];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(64 + HXBBottomAdditionHeight));
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.equalTo(@1);
    }];
    
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.equalTo(@64);
    }];
}

- (void)updateBottomView {
    [self.bottomContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.viewModel.planModel.hasBuy) {
        [self setupBuyBottomView];
    } else {
        [self setupUnBuyBottomView];
    }
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.infoView.frame) + 80 + HXBBottomAdditionHeight);
    
    [self updateInBtnState];
}

- (void)updateInBtnState {
    [self.inBtn setTitle:self.viewModel.inText forState:UIControlStateNormal];
    [self.inBtn setTitleColor:self.viewModel.inTextColor forState:UIControlStateNormal];
    [self.inBtn setBackgroundImage:self.viewModel.inBackgroundImage forState:UIControlStateNormal];
    self.inBtn.enabled = self.viewModel.inEnabled;
}

- (void)setupUnBuyBottomView {
    UIButton *calBtn = [UIButton new];
    calBtn.adjustsImageWhenHighlighted = NO;
    [calBtn setImage:[UIImage imageNamed:@"detail_cal"] forState:UIControlStateNormal];
    [calBtn addTarget:self action:@selector(calClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomContentView addSubview:calBtn];
    
    
    UIButton *inBtn = [UIButton new];
    [inBtn setTitle:@"转入" forState:UIControlStateNormal];
    inBtn.titleLabel.font = kHXBFont_32;
    inBtn.adjustsImageWhenHighlighted = NO;
    [inBtn addTarget:self action:@selector(inClick) forControlEvents:UIControlEventTouchUpInside];
    self.inBtn = inBtn;
    
    [self.bottomContentView addSubview:inBtn];
    
    [calBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.centerY.equalTo(self.bottomContentView);
        make.width.height.equalTo(@kScrAdaptationW(35));
    }];
    
    [inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@kScrAdaptationW(-15));
        make.centerY.equalTo(self.bottomContentView);
        make.height.equalTo(@kScrAdaptationW(41));
        make.left.equalTo(calBtn.mas_right).offset(15);
    }];
}

- (void)setupBuyBottomView {
    UIButton *outBtn = [UIButton new];
    [outBtn setTitle:@"转出" forState:UIControlStateNormal];
    [outBtn setTitleColor:kHXBColor_FF7055_100 forState:UIControlStateNormal];
    [outBtn setBackgroundImage:[UIImage imageNamed:@"plandetail_btn_empty_bg"] forState:UIControlStateNormal];
    outBtn.titleLabel.font = kHXBFont_32;
    outBtn.adjustsImageWhenHighlighted = NO;
    [outBtn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomContentView addSubview:outBtn];
    
    UIButton *inBtn = [UIButton new];
    [inBtn setTitle:@"转入" forState:UIControlStateNormal];
    [inBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inBtn.backgroundColor = kHXBColor_FF7055_100;
    inBtn.layer.cornerRadius = 2;
    inBtn.layer.masksToBounds = YES;
    inBtn.titleLabel.font = kHXBFont_32;
    inBtn.adjustsImageWhenHighlighted = NO;
    [inBtn addTarget:self action:@selector(inClick) forControlEvents:UIControlEventTouchUpInside];
    self.inBtn = inBtn;
    
    [self.bottomContentView addSubview:inBtn];
    
    [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.height.equalTo(@kScrAdaptationW(41));
        make.centerY.equalTo(self.bottomContentView);
    }];
    
    [inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@kScrAdaptationW(-15));
        make.centerY.height.equalTo(outBtn);
        make.left.equalTo(outBtn.mas_right).offset(15);
        make.width.equalTo(outBtn);
    }];
}

#pragma mark - Network
- (void)getData {
    kWeakSelf
    [self.viewModel getDataWithId:self.planId resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf setData];
        }
    }];
}

- (void)setData {
    self.titleLabel.text = self.viewModel.planModel.name;
    self.topView.viewModel = self.viewModel;
    self.rulerView.viewModel = self.viewModel;
    self.advantageView.viewModel = self.viewModel;
    
    [self updateBottomView];
}

#pragma mark - Delegate Internal

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 30) {
        self.navView.backgroundColor = [UIColor whiteColor];
        self.navViewBottomLine.hidden = NO;
    } else {
        offsetY = MIN(0, offsetY);
        self.navView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:offsetY / 30];
        self.navViewBottomLine.hidden = YES;
    }
}

#pragma mark - Action
- (void)inClick {
    if (self.viewModel.hasBuy) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailHasBuyInClick];
    } else {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailUnBuyInClick];
    }
    
    [self toRollOut];
}

- (void)outClick {
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailHasBuyOutClick];
    
    if (KeyChain.isLogin) {
        HSJRollOutController *vc = [HSJRollOutController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
    }
}

- (void)calClick {
    if (self.viewModel.hasBuy) {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailHasBuyCalculatorClick];
    } else {
        [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailUnBuyCalculatorClick];
    }
    
    kWeakSelf
    [HSJEarningCalculatorView showWithInterest:self.viewModel.interest buyBlock:^(NSString *value) {
        [weakSelf toRollOut];
    }];
}

- (void)leftBackBtnClick {
    [super leftBackBtnClick];
    [HXBUmengManagar HXB_clickEventWithEnevtId:kHSHUmeng_DetailBackClick];
}

- (void)toRollOut {
    if (KeyChain.isLogin) {
        kWeakSelf
        [self.viewModel downLoadUserInfo:YES resultBlock:^(HXBUserInfoModel *userInfoModel, NSError *erro) {
            if (userInfoModel.userInfo.isCreateEscrowAcc == NO) {
                [HSJDepositoryOpenTipView show];
            } else if ([userInfoModel.userInfo.riskType isEqualToString:@"立即评测"]) {
                [weakSelf.viewModel riskTypeAssementFrom:weakSelf];
            } else {
                HSJBuyViewController *vc = [HSJBuyViewController new];
                vc.planId = weakSelf.planId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHXBNotification_ShowLoginVC object:nil];
    }
}

@end
