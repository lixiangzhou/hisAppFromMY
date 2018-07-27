//
//  HSJNoDataOrNetViewController.m
//  hoommy
//
//  Created by caihongji on 2018/7/26.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJNoDataOrNetViewController.h"

@interface HSJNoDataOrNetViewController ()
@property (nonatomic, strong) UIImageView *topImv;
@property (nonatomic, strong) UILabel *prompLb;
@end

@implementation HSJNoDataOrNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topImv = [[UIImageView alloc] init];
    [self.view addSubview:self.topImv];
    
    self.prompLb = [[UILabel alloc] init];
    self.prompLb.font = kHXBFont_36;
    self.prompLb.textColor = kHXBColor_666666_100;
    self.prompLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.prompLb];
}

- (void)setupConstraints {
    [self.topImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kScrAdaptationH(100));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScrAdaptationW(145));
        make.height.mas_equalTo(kScrAdaptationH(141));
    }];
    
    [self.prompLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImv.mas_bottom).offset(kScrAdaptationH(60));
        make.left.right.equalTo(self.view);
    }];
}

- (void)setIsNoNetWork:(BOOL)isNoNetWork {
    _isNoNetWork = isNoNetWork;
    
    if(isNoNetWork) {
        self.topImv.image = [UIImage imageNamed:@"no_network"];
        self.prompLb.text = @"暂无网络";
        self.view.userInteractionEnabled = YES;
    }
    else {
        self.topImv.image = [UIImage imageNamed:@"no_data"];
        self.prompLb.text = @"暂无数据";
        self.view.userInteractionEnabled = NO;
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
