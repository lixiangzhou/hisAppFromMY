//
//  HxbMyAboutMeViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/5/8.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbMyAboutMeViewController.h"
#import "HXBVersionUpdateModel.h"//版本更新的model
#import "HXBAgreementView.h"
#import "HXBBottomLineTableViewCell.h"
#import "HXBCommonProblemViewController.h"//常见问题H5
#import "HXBAlertManager.h"
#import "HXBMiddlekey.h"
#import "UIImageView+HxbSDWebImage.h"
@interface HxbMyAboutMeViewController ()
<
UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HxbMyAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViewFrame];
}

- (void)setupSubViewFrame
{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(kScrAdaptationH(82) + HXBStatusBarAndNavigationBarHeight);
        make.centerX.equalTo(self.headerView);
        make.width.offset(kScrAdaptationW(100));
        make.height.offset(kScrAdaptationH(100));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(kScrAdaptationH(15));
    }];
}

#pragma TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.row) {
        case 0:
        {
            [HXBAlertManager callupWithphoneNumber:kServiceMobile andWithTitle:@"红小宝客服电话" Message:kServiceMobile];
        }
            break;
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScrAdaptationH750(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kScrAdaptationH750(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celledStr = @"celled";
    HXBBottomLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celledStr ];
    if (cell == nil) {
        cell = [[HXBBottomLineTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celledStr];
        cell.textLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        cell.textLabel.textColor = kHXBFontColor_2D2F46_100;
        cell.detailTextLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
        cell.detailTextLabel.textColor = kHXBFontColor_9295A2_100;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isLineRight = YES;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"红小宝客服";
            cell.detailTextLabel.text = kServiceMobile;
           
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"官方微信号";
            cell.detailTextLabel.text = @"红小宝hoomsun";
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"版本号";
            NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"v%@ ",version]];
            NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
            attachment.image = [UIImage imageNamed:@"icon_newVersion"];
            attachment.bounds = CGRectMake(0, -2, 31, 13);
            [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
            cell.detailTextLabel.attributedText = attr;
        }else{
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
  
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [HXBMiddlekey AdaptationiOS11WithTableView:_tableView];
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth , kScrAdaptationH(297) + HXBStatusBarAndNavigationBarHeight)];
        [_headerView addSubview:self.logoImageView];
        [_headerView addSubview:self.titleLabel];
    }
    return _headerView;
}
- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScrAdaptationW750(260), kScrAdaptationW750(260))];
        _logoImageView.image = [UIImage imageNamed:@"appLogo"];
    }
    return _logoImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _titleLabel.text = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _titleLabel.textColor = kHXBFontColor_2D2F46_100;
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    }
    return _titleLabel;
}

@end
