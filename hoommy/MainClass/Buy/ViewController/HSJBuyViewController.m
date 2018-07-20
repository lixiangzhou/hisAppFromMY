//
//  HSJBuyViewController.m
//  hoommy
//
//  Created by caihongji on 2018/7/18.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJBuyViewController.h"
#import "HSJBuyFootView.h"
#import "HSJBuyHeadView.h"
#import "HSJBuySectionHeadView.h"
#import "HSJBuyTableViewCell.h"
#import "HSJBuyViewModel.h"

@interface HSJBuyViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HSJBuyFootView *footView;
@property (nonatomic, strong) HSJBuyHeadView *headView;

@property (nonatomic, strong) HSJBuyViewModel *viewModel;

@end

@implementation HSJBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupData {
    
}

- (void)setupUI {
    self.title = @"转入";
    self.isShowSplitLine = YES;
    self.view.backgroundColor = kHXBBackgroundColor;
    
    [self.tableView registerClass:[HSJBuyTableViewCell class] forCellReuseIdentifier:@"HSJBuyTableViewCell"];
    [self.tableView registerClass:[HSJBuySectionHeadView class] forHeaderFooterViewReuseIdentifier:@"HSJBuySectionHeadView"];
    [self.safeAreaView addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.safeAreaView);
    }];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.sectionFooterHeight = 0.1;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedRowHeight = kScrAdaptationH(48);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (HSJBuyHeadView *)headView {
    if(!_headView) {
        _headView = [[HSJBuyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH(155.5))];
    }
    return _headView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HSJBuySectionHeadView *sectionView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSJBuySectionHeadView"];
    sectionView.title = @"支付方式";
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScrAdaptationH(51);
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
