//
//  HXBBankCardListViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/6/28.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBBankCardListViewController.h"
#import "HXBBankCardListViewModel.h"
#import "HXBBankListCell.h"
#import "SVGKit/SVGKImage.h"
#import "HXBBankList.h"

@interface HXBBankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) HXBBankCardListViewModel *viewModel;
//@property (nonatomic, strong) NSMutableArray *bankListModels;

@end

@implementation HXBBankCardListViewController

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HXBStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight - HXBStatusBarAndNavigationBarHeight)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.isWhiteColourGradientNavigationBar = YES;
    self.title = @"银行卡列表";
    [self.view addSubview:self.mainTableView];
    self.viewModel = [[HXBBankCardListViewModel alloc] init];
    [self setupNavLeftBtn];
    [self loadData];
}


- (void)setupNavLeftBtn {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [button setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    kWeakSelf
    [self.viewModel bankCardListRequestWithResultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate和UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.bankListModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"bankCardList";
    HXBBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HXBBankListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.bankModel = self.viewModel.bankListModels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCardListBlock) {
        HXBBankList *bankModel  = self.viewModel.bankListModels[indexPath.row];
        self.bankCardListBlock(bankModel.bankCode,bankModel.name);
    }
//    [self back];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScrAdaptationH(70);
}
- (void)dealloc
{
    NSLog(@"被释放");
}
@end
