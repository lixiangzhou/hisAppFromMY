//
//  HSJSignInViewController.m
//  hoommy
//
//  Created by HXB-C on 2018/7/9.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignInViewController.h"
#import "HXBCustomTextField.h"
#import "HSJPasswordSigInViewController.h"
#import "SVGKImage.h"
#import "HSJSignUpViewController.h"
#import "HSJSignInViewModel.h"
@interface HSJSignInViewController ()

@property (nonatomic, strong) HXBCustomTextField *phoneTextField;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) HSJSignInViewModel *viewModel;

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

- (void)setupLeftBackBtn {
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    if(self.isFullScreenShow) {
        [leftBackBtn setImage:nil forState:UIControlStateNormal];
        [leftBackBtn setImage:nil forState:UIControlStateHighlighted];
    }
    else {
        [leftBackBtn setImage:[SVGKImage imageNamed:@"back.svg"].UIImage forState:UIControlStateNormal];
        [leftBackBtn setImage:[SVGKImage imageNamed:@"back.svg"].UIImage forState:UIControlStateHighlighted];
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

- (void)leftBackBtnClick {
    if (self.selectedIndexVC != nil) {
        [HXBRootVCManager manager].mainTabbarVC.selectedIndex = [self.selectedIndexVC integerValue];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick {
    kWeakSelf
    [self.viewModel checkExistMobile:self.phoneTextField.text resultBlock:^(BOOL isSuccess,NYBaseRequest *request) {
            if (isSuccess) {
                //进入登录页面
                HSJPasswordSigInViewController *passwordVC = [[HSJPasswordSigInViewController alloc] init];
                passwordVC.viewModel = weakSelf.viewModel;
                [self.navigationController pushViewController:passwordVC animated:YES];
            } else {
                //注册页面
                [self.navigationController pushViewController:[[HSJSignUpViewController alloc] init] animated:YES];
            }
    }];
    

}

- (HXBCustomTextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[HXBCustomTextField alloc] init];
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.isHidenLine = NO;
        _phoneTextField.limitStringLength = 11;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
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

- (HSJSignInViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HSJSignInViewModel alloc] init];
    }
    return _viewModel;
}
- (void)dealloc {
    
}

@end
