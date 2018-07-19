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
#import "HSJSignInButton.h"
#import "HSJSignInModel.h"
@interface HSJSignInViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HXBCustomTextField *phoneTextField;

@property (nonatomic, strong) HSJSignInButton *nextButton;

@property (nonatomic, strong) HSJSignInViewModel *viewModel;

@property (nonatomic, strong) UILabel *bottomTipLabel;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIImageView *leftLogo;

@property (nonatomic, strong) UIImageView *rightLogo;

@end

@implementation HSJSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)setupUI {
    self.isWhiteColourGradientNavigationBar = YES;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.bottomTipLabel];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.leftLogo];
    [self.view addSubview:self.rightLogo];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.top.equalTo(self.view).offset(kScrAdaptationH(30) + HXBStatusBarAndNavigationBarHeight);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kScrAdaptationH(55));
        make.left.equalTo(self.view).offset(kScrAdaptationW(25));
        make.right.equalTo(self.view).offset(-kScrAdaptationW(25));
        make.height.offset(kScrAdaptationH(40));
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(kScrAdaptationH(60));
        make.height.offset(kScrAdaptationH(41));
    }];
    
    [self.bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kScrAdaptationH(30));
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.offset(kScrAdaptationW(1));
        make.height.offset(kScrAdaptationH(18));
        make.bottom.equalTo(self.bottomTipLabel.mas_top).offset(-kScrAdaptationH(7));
    }];
    
    [self.leftLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScrAdaptationW(55));
        make.height.offset(kScrAdaptationH(18));
        make.right.equalTo(self.segmentView).offset(-kScrAdaptationW(10));
        make.centerY.equalTo(self.segmentView);
    }];
    
    [self.rightLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScrAdaptationW(73));
        make.height.offset(kScrAdaptationH(18));
        make.left.equalTo(self.segmentView).offset(kScrAdaptationW(10));
        make.centerY.equalTo(self.segmentView);
    }];
}

- (void)setupLeftBackBtn {
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    
    [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateHighlighted];
    
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
    [self.viewModel checkExistMobile:self.phoneTextField.text resultBlock:^(HSJSignInModel *responseData, NSError *erro) {
        if (responseData.exist) {
            //进入登录页面
            HSJPasswordSigInViewController *passwordVC = [[HSJPasswordSigInViewController alloc] init];
            passwordVC.viewModel = weakSelf.viewModel;
            [weakSelf.navigationController pushViewController:passwordVC animated:YES];
        } else {
            //注册页面
            HSJSignUpViewController *signupVC = [[HSJSignUpViewController alloc] init];
            signupVC.phoneNumber = self.phoneTextField.text;
            [weakSelf.navigationController pushViewController:signupVC animated:YES];
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
        _phoneTextField.isHiddenLeftImage = YES;
        _phoneTextField.isCleanAllBtn = NO;
        _phoneTextField.textColor = kHXBFontColor_555555_100;
        _phoneTextField.bottomLineEditingColor = kHXBSpacingColor_F5F5F9_100;
        _phoneTextField.bottomLineNormalColor = kHXBSpacingColor_F5F5F9_100;
        kWeakSelf
        _phoneTextField.block = ^(NSString *text1) {
            weakSelf.nextButton.enabled = text1.length;
        };
    }
    return _phoneTextField;
}

- (HSJSignInButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[HSJSignInButton alloc] init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    }
    return _nextButton;
}

- (HSJSignInViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HSJSignInViewModel alloc] init];
    }
    return _viewModel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"欢迎来到红小宝";
        _titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(30);
        _titleLabel.textColor = kHXBFontColor_505050_100;
    }
    return _titleLabel;
}

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] init];
        _bottomTipLabel.text = @"已接入恒丰银行资金存管";
        _bottomTipLabel.font = kHXBFont_PINGFANGSC_REGULAR(12);
        _bottomTipLabel.textColor = kHXBColor_CBCBCB_100;
    }
    return _bottomTipLabel;
}

- (UIView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[UIView alloc] init];
        _segmentView.backgroundColor = kHXBColor_D8D8D8_100;
    }
    return _segmentView;
}

- (UIImageView *)leftLogo {
    if (!_leftLogo) {
        _leftLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signInLogo"]];
        _leftLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftLogo;
}

- (UIImageView *)rightLogo {
    if (!_rightLogo) {
        _rightLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signInhflogo"]];
        _rightLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightLogo;
}
- (void)dealloc {
    
}

@end
