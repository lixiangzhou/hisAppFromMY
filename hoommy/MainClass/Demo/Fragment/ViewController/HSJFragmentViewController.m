//
//  HSJFragmentViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJFragmentViewController.h"
#import "HSJTopFragmentNavgationView.h"
#import "HSJPageScrollView.h"
#import "HSJListViewController.h"

@interface HSJFragmentViewController ()<HSJPageScrollViewDelegate, HSJPageScrollViewDatasource, HSJTopFragmentNavgationViewProto>

@property (nonatomic, strong) HSJTopFragmentNavgationView *topFragmentNavgationView;
@property (nonatomic, strong) HSJPageScrollView* pageScrollView;
@property (nonatomic, strong) NSArray* pageDatasourceList;
@property (nonatomic, strong) NSArray* topFragmentDatasourceList;
@end

@implementation HSJFragmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"滑动页面";
    //安装UI
    [self setUpUI];
    
    //添加约束
    [self addConstraints];
    
    //加载数据
    self.topFragmentDatasourceList = @[@"计划", @"散标", @"债转"];
    self.pageDatasourceList = @[[[HSJListViewController alloc] init], [[HSJListViewController alloc] init], [[HSJListViewController alloc] init]];
    [self.pageScrollView reloadData];
}

- (void)setUpUI {
    [self.view addSubview:self.topFragmentNavgationView];
    [self.view addSubview:self.pageScrollView];
}

- (void)addConstraints {
    [self.topFragmentNavgationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.contentViewLeft);
        make.right.equalTo(self.view).offset(-self.contentViewRight);
        make.top.equalTo(self.view).offset(self.contentViewTop);
        make.height.mas_equalTo(kScrAdaptationH(44));
    }];
    
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFragmentNavgationView.mas_bottom);
        make.left.right.equalTo(self.topFragmentNavgationView);
        make.bottom.equalTo(self.view).offset(-self.contentViewBottomNoTabbar);
    }];
}

- (HSJTopFragmentNavgationView *)topFragmentNavgationView {
    
    if(!_topFragmentNavgationView) {
        _topFragmentNavgationView = [[HSJTopFragmentNavgationView alloc] initWithFrame:CGRectZero];
        _topFragmentNavgationView.protoDelegate = self;
        _topFragmentNavgationView.isCanScroll = NO;
    }
    
    return _topFragmentNavgationView;
}

- (HSJPageScrollView *)pageScrollView {
    if(!_pageScrollView) {
        _pageScrollView = [[HSJPageScrollView alloc] init];
        _pageScrollView.delegate = self;
        _pageScrollView.datasource = self;
        _pageScrollView.backgroundColor = [UIColor greenColor];
    }
    
    return _pageScrollView;
}

#pragma mark 协议实现

- (NSArray *)getTitleList {
    return self.topFragmentDatasourceList;
}

- (void)itemClick:(NSInteger)index {
    [self.pageScrollView jumpToView:index];
}

- (NSInteger)numberOfPages {
    return self.pageDatasourceList.count;
}

- (void)moveAtIndex:(NSInteger)index { 
    [self.topFragmentNavgationView setCurSelection:index];
}

- (UIView *)pageAtIndex:(NSInteger)index {
    HSJListViewController* vc = [self.pageDatasourceList safeObjectAtIndex:index];
    if(index == 1){
        vc.view.backgroundColor = [UIColor redColor];
    }
    return vc.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
