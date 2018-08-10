//
//  HXBBaseViewController.m
//  hoomxb
//
//  Created by HXB on 2017/4/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBaseViewController.h"
#import <WebKit/WebKit.h>
#import "HXBBaseTabBarController.h"
#import "HXBBaseNavigationController.h"
#import "HSJNoDataOrNetViewController.h"

@interface HXBBaseViewController () <UIGestureRecognizerDelegate> {
    BOOL _isInitNavBar;
}

///使navBar 透明
@property (nonatomic,assign) BOOL isTransparentNavigationBar;
///其它各种颜色的视图
@property (nonatomic,strong) UIImageView *navgationBarImageView;
//当前颜色视图
@property (nonatomic, strong) UIView* curNavColorView;
//分割线
@property (nonatomic,strong) UIImageView *splitLineImv;
//无数据视图
@property (nonatomic, strong) HSJNoDataOrNetViewController *noDataOrNetVC;
@end

@implementation HXBBaseViewController

#pragma mark - 基类方法重写

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self buildPreloadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.safeAreaView.backgroundColor = [UIColor clearColor];
    if(self.navigationController) {
        self.isWhiteColourGradientNavigationBar = YES;
    }
}

- (UIImageView *)splitLineImv {
    if(!_splitLineImv) {
        _splitLineImv = [[UIImageView alloc] init];
        _splitLineImv.backgroundColor = kHXBColor_EEEEF5_100;
        _splitLineImv.hidden = YES;
    }
    
    return _splitLineImv;
}

- (void)buildPreloadView {
    _safeAreaView = [[UIView alloc] init];
    [self.view addSubview:_safeAreaView];
    [self.view sendSubviewToBack:_safeAreaView];
    [self.view addSubview:self.splitLineImv];
    
    self.noDataOrNetVC = [[HSJNoDataOrNetViewController alloc] init];
    [self.view addSubview:self.noDataOrNetVC.view];
    self.noDataOrNetVC.view.hidden = YES;
    
    //
    if(self.iswithTabbarInPage) {
        [_safeAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentViewInsetWithTabbar);
        }];
    }
    else {
        [_safeAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentViewInsetNoTabbar);
        }];
    }
    //
    [self.splitLineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HXBStatusBarAndNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    //
    [self.noDataOrNetVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.splitLineImv.mas_bottom);
        make.left.right.bottom.equalTo(self.safeAreaView);
    }];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    HXBBaseNavigationController *navVC = (HXBBaseNavigationController *)self.navigationController;
    if(navVC) {
        if(parent) {
            navVC.rightGestureAction = RightSliderGestureNull;
        }
        else{
            navVC.rightGestureAction = RightSliderGestureStart;
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];

    if(!parent) {
        HXBBaseNavigationController *navVC = (HXBBaseNavigationController *)[HXBRootVCManager manager].mainTabbarVC.selectedViewController;
        navVC.rightGestureAction = RightSliderGestureEnd;
        [self sliderBackAction];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    //设置电池栏的颜色
    [super viewWillAppear:animated];
    
    if(self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        
        //适配iphoneX上的tabbar
        if(HXBIPhoneX) {
            int height = self.tabBarController.tabBar.height;
            if(height != 83){
                self.tabBarController.tabBar.hidden = YES;
                self.tabBarController.tabBar.height = 83;
            }
        }
        
        if(!self.leftBackBtn || !self.leftBackBtn.superview) {
            [self setupLeftBackBtn];
        }
        
        //全屏控制
        if(self.isFullScreenShow) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
            self.navigationItem.title = nil;
            if(!_isInitNavBar) {
                self.isTransparentNavigationBar = YES;
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor clearColor],NSBackgroundColorAttributeName:[UIColor clearColor]};
            }
        }
    }
    
    _isInitNavBar = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.navigationController) {
        //滑动返回控制
        if(self.isDisableSliderBack){
            ((HXBBaseNavigationController*)self.navigationController).enableFullScreenGesture = NO;
        }
        
        if(((HXBBaseNavigationController*)self.navigationController).rightGestureAction != RightSliderGestureStart) {
            [self reLoadWhenViewAppear];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.navigationController) {
        //全屏控制
        if(self.isFullScreenShow) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.navigationController) {
        //滑动返回控制
        if(self.isDisableSliderBack){
            ((HXBBaseNavigationController*)self.navigationController).enableFullScreenGesture = YES;
        }
    }
}

- (CGFloat)contentViewTop {
    if(self.isFullScreenShow) {
        return 0;
    }
    return [super contentViewTop];
}


#pragma mark - 自定义返回视图

- (void)setupLeftBackBtn
{
    if(self.navigationController.viewControllers.count <= 1) {
        return;
    }
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    if(self.isFullScreenShow) {
        [leftBackBtn setImage:nil forState:UIControlStateNormal];
        [leftBackBtn setImage:nil forState:UIControlStateHighlighted];
    }
    else {
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
        [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateHighlighted];
    }

    [leftBackBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if (@available(iOS 11.0, *)) {
        leftBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else {
        spaceItem.width = -15;
    }
    
    self.navigationItem.leftBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:leftBackBtn]];
}

- (void)leftBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsShowSplitLine:(BOOL)isShowSplitLine {
    _isShowSplitLine = isShowSplitLine;
    
    self.splitLineImv.hidden = !isShowSplitLine;
    if(self.isShowSplitLine) {
        [self.view bringSubviewToFront:self.splitLineImv];
    }
}

- (void)setIsShowNonetView:(BOOL)isShowNonetView {
    _isShowNonetView = isShowNonetView;
    
    self.noDataOrNetVC.view.hidden = !isShowNonetView;
    if(isShowNonetView) {
        self.noDataOrNetVC.isNoNetWork = YES;
        [self.view bringSubviewToFront:self.noDataOrNetVC.view];
    }
}

- (void)setIsShowNodataView:(BOOL)isShowNodataView {
    _isShowNodataView = isShowNodataView;
    
    self.noDataOrNetVC.view.hidden = !isShowNodataView;
    if(isShowNodataView) {
        self.noDataOrNetVC.isNoNetWork = NO;
        [self.view bringSubviewToFront:self.noDataOrNetVC.view];
    }
}

#pragma mark - 导航bar的颜色设置方法

///透明naveBar
- (void)setIsTransparentNavigationBar:(BOOL)isTransparentNavigationBar {
    _isTransparentNavigationBar = isTransparentNavigationBar;
    if (isTransparentNavigationBar) {
        if(self.curNavColorView){
            [self.curNavColorView removeFromSuperview];
            self.curNavColorView = nil;
        }
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}
- (void)setIsWhiteColourGradientNavigationBar:(BOOL)isWhiteColourGradientNavigationBar {
    _isWhiteColourGradientNavigationBar = isWhiteColourGradientNavigationBar;
    if (isWhiteColourGradientNavigationBar) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kHXBColor_333333_100, NSFontAttributeName: kHXBFont_PINGFANGSC_REGULAR(17)};
        
        self.isTransparentNavigationBar = YES;
        self.navgationBarImageView.backgroundColor = [UIColor whiteColor];
//        self.navgationBarImageView.image = [UIImage imageNamed:@"top"];
        [self.view bringSubviewToFront: self.navgationBarImageView];
    }
}

- (void)setIsRedColourGradientNavigationBar:(BOOL)isRedColourGradientNavigationBar {
    _isRedColourGradientNavigationBar = isRedColourGradientNavigationBar;
    if (isRedColourGradientNavigationBar) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:kHXBFont_PINGFANGSC_REGULAR(17)};
        self.isTransparentNavigationBar = YES;
        self.navgationBarImageView.backgroundColor = [UIColor redColor];
//        self.navgationBarImageView.image = [UIImage imageNamed:@""];
        [self.view bringSubviewToFront: self.navgationBarImageView];
    }
}

- (UIImageView *)navgationBarImageView {
    if (!_navgationBarImageView) {
        _navgationBarImageView = [[UIImageView alloc]init];
        _navgationBarImageView.frame = CGRectMake(0, 0, kScreenWidth, HXBStatusBarAndNavigationBarHeight);
    }
    
    if(!_navgationBarImageView.superview) {
        [self.view addSubview:_navgationBarImageView];
        [self.view bringSubviewToFront:_navgationBarImageView];
        self.curNavColorView = _navgationBarImageView;
    }
    
    return _navgationBarImageView;
}

- (HSJNoDataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [HSJNoDataView new];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

#pragma mark - Other
///白色的电池栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark 子类中可以重写以下方法完成相应的功能

/**
 替代viewDidAppear方法，子类如果需要重新加载页面，只需重写这个方法就可以
 注意：这个方法处理了滑动返回时的种种情况，要将所有的重新加载操作，放在这个方法里
 */
- (void)reLoadWhenViewAppear {
    
}

/**
 当滑动返回上一个页面时回调这个方法
 
 */
- (void)sliderBackAction {
    
}
@end
