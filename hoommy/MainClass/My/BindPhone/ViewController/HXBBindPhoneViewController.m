//
//  HXBBindPhoneViewController.m
//  hoomxb
//
//  Created by caihongji on 2018/7/5.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HXBBindPhoneViewController.h"
#import "HXBBindPhoneTableFootView.h"

@interface HXBBindPhoneViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) HXBBindPhoneTableFootView* footView;

@property (nonatomic, strong) HXBBindPhoneVCViewModel* viewModel;

@end

@implementation HXBBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    [self addConstraints];
}

- (void)setupData {
    self.isWhiteColourGradientNavigationBar = YES;
    self.title = @"绑定新手机号";
    
    self.viewModel = [[HXBBindPhoneVCViewModel alloc] init];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
}

- (void)addConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HXBStatusBarAndNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 48;
    }
    
    return _tableView;
}

- (HXBBindPhoneTableFootView *)footView {
    if(!_footView) {
        _footView = [[HXBBindPhoneTableFootView alloc] init];
    }
    
    return _footView;
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
