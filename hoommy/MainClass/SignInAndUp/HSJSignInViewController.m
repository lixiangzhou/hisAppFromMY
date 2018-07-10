//
//  HSJSignInViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/9.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignInViewController.h"
#import "HXBCustomTextField.h"
@interface HSJSignInViewController ()

@property (nonatomic, strong) HXBCustomTextField *phoneTextField;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation HSJSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.nextButton];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(kScrAdaptationW(15));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(15));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(kScrAdaptationH(10));
        make.height.offset(kScrAdaptationH(41));
    }];
}

- (void)nextButtonClick {
    NSLog(@"%s",__func__);
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
    }
    return _phoneTextField;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_nextButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _nextButton.layer.borderWidth = 1;
        _nextButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _nextButton;
}

@end
