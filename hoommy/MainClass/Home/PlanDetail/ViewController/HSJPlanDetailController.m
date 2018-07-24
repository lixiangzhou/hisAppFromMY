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

@interface HSJPlanDetailController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *navView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) HSJPlanDetailTopView *topView;
@property (nonatomic, weak) HSJPlanDetailRulerView *rulerView;
@property (nonatomic, weak) HSJPlanDetailAdvantageView *advantageView;
@property (nonatomic, weak) HSJPlanDetailInfoView *infoView;

@property (nonatomic, strong) HSJPlanDetailViewModel *viewModel;
@property (nonatomic, weak) UIView *bottomView;
@end

@implementation HSJPlanDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.isFullScreenShow = YES;
    [super viewDidLoad];
    
    self.viewModel = [HSJPlanDetailViewModel new];
    [self setUI];
    
    [self getData];
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
    titleLabel.text = @"钱生钱计划";
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
}


- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view insertSubview:scrollView belowSubview:self.navView];
    
    HSJPlanDetailTopView *topView = [HSJPlanDetailTopView new];
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
    
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(infoView.frame) + 100);
    
}

- (void)setupBottomView {
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *sepLine = [UIView new];
    sepLine.backgroundColor = self.scrollView.backgroundColor;
    [bottomView addSubview:sepLine];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-HXBTabbarSafeBottomMargin));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@kScrAdaptationW(64));
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.equalTo(@1);
    }];
}

- (void)updateBottomView {
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.viewModel.planModel.hasBuy) {
        [self setupBuyBottomView];
    } else {
        [self setupUnBuyBottomView];
    }
}

- (void)setupUnBuyBottomView {
    UIButton *calBtn = [UIButton new];
    calBtn.adjustsImageWhenHighlighted = NO;
    [calBtn setImage:[UIImage imageNamed:@"detail_cal"] forState:UIControlStateNormal];
    [calBtn addTarget:self action:@selector(calClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:calBtn];
    
    UIButton *inBtn = [UIButton new];
    [inBtn setTitle:@"转入" forState:UIControlStateNormal];
    [inBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inBtn.backgroundColor = kHXBColor_FF7055_100;
    inBtn.layer.cornerRadius = 2;
    inBtn.layer.masksToBounds = YES;
    inBtn.titleLabel.font = kHXBFont_32;
    [inBtn addTarget:self action:@selector(inClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:inBtn];
    
    [calBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.centerY.equalTo(self.bottomView);
        make.width.height.equalTo(@kScrAdaptationW(35));
    }];
    
    [inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@kScrAdaptationW(-15));
        make.centerY.height.equalTo(calBtn);
        make.left.equalTo(calBtn.mas_right).offset(15);
    }];
}

- (void)setupBuyBottomView {
    UIButton *outBtn = [UIButton new];
    [outBtn setTitle:@"转出" forState:UIControlStateNormal];
    [outBtn setTitleColor:kHXBColor_FF7055_100 forState:UIControlStateNormal];
    outBtn.layer.cornerRadius = 2;
    outBtn.layer.borderColor = kHXBColor_FF7055_100.CGColor;
    outBtn.layer.borderWidth = 0.5;
    outBtn.layer.masksToBounds = YES;
    outBtn.titleLabel.font = kHXBFont_32;
    [outBtn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:outBtn];
    
    UIButton *inBtn = [UIButton new];
    [inBtn setTitle:@"转入" forState:UIControlStateNormal];
    [inBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inBtn.backgroundColor = kHXBColor_FF7055_100;
    inBtn.layer.cornerRadius = 2;
    inBtn.layer.masksToBounds = YES;
    inBtn.titleLabel.font = kHXBFont_32;
    [inBtn addTarget:self action:@selector(inClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:inBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-HXBTabbarSafeBottomMargin));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@kScrAdaptationW(64));
    }];
    
    [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kScrAdaptationW(15));
        make.height.equalTo(@kScrAdaptationW(41));
        make.centerY.equalTo(self.bottomView);
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
    } else {
        offsetY = MIN(0, offsetY);
        self.navView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:offsetY / 30];
    }
}

#pragma mark - Delegate External

#pragma mark -


#pragma mark - Action
- (void)inClick {
    HSJBuyViewController *vc = [HSJBuyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)outClick {
    HSJRollOutController *vc = [HSJRollOutController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)calClick {
    
}

#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
