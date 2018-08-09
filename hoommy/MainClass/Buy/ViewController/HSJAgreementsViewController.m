//
//  HSJAgreementsViewController.m
//  hoommy
//
//  Created by caihongji on 2018/7/24.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJAgreementsViewController.h"
#import "HXBBaseWKWebViewController.h"

@interface HSJAgreementsViewController ()
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray* titleList;
@end

@implementation HSJAgreementsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
       self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupData {
    self.titleList = @[@"存钱罐服务协议", @"网络借贷协议书", @"投资范围", @"取消"];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    self.safeAreaView.backgroundColor = kHXBColor_000000_50;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    tapGesture.numberOfTapsRequired = 1;
//    [self.safeAreaView addGestureRecognizer:tapGesture];
    
    [self.safeAreaView addSubview:self.tableView];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.safeAreaView);
        make.left.right.equalTo(self.safeAreaView);
        make.height.mas_equalTo(kScrAdaptationH(220));
    }];
}

// 点击事件

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)createCell:(NSString*)title cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = kHXBFont_28;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = title;
    if(indexPath.row != self.titleList.count-1) {
        lable.textColor = kHXBFontColor_4C7BFE_100;
    }
    else {
        lable.textColor = kHXBFontColor_4C7BFE_100;
    }
    [cell.contentView addSubview:lable];
    
    UIImageView *lineImv = [[UIImageView alloc] init];
    lineImv.backgroundColor = kHXBColor_ECECEC_100;
    [cell.contentView addSubview:lineImv];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    [lineImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScrAdaptationH(55);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.titleList safeObjectAtIndex:indexPath.row];
    UITableViewCell *cell = [self createCell:title cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.titleList safeObjectAtIndex:indexPath.row];
    if([title isEqualToString:@"取消"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
        UINavigationController *navVC = [HXBRootVCManager manager].mainTabbarVC.selectedViewController;
        HXBBaseWKWebViewController *vc = [[HXBBaseWKWebViewController alloc] init];
        if([title isEqualToString:@"存钱罐服务协议"]) {
            vc.pageUrl = [NSString splicingH5hostWithURL:kHXB_Negotiate_ServePlanURL];
            vc.pageTitle = @"存钱罐服务协议";
        }
        else if([title isEqualToString:@"网络借贷协议书"]) {
            vc.pageUrl = [NSString splicingH5hostWithURL:kHXB_Agreement_Hint];
            vc.pageTitle = @"网络借贷协议书";
        }
        else if([title isEqualToString:@"投资范围"]) {
            vc.pageUrl = kHXBH5_BuyPlanRangeURL(self.planId);
            vc.pageTitle = @"投资范围";
        }
        
        if(vc.pageUrl) {
            [navVC pushViewController:vc animated:YES];
        }
    }
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
