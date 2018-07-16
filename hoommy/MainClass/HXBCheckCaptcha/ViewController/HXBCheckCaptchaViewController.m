//
//  HXBCheckCaptchaViewController.m
//  hoomxb
//
//  Created by HXB on 2017/6/2.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBCheckCaptchaViewController.h"
#import "HXBCheckCaptcha.h"
#import   "UIImageView+WebCache.h"
#import "SVGKit/SVGKImage.h"
#import "HXBCheckCaptchaViewModel.h"
#import "Animatr.h"

@interface HXBCheckCaptchaViewController ()
@property (nonatomic, strong) Animatr *animatrManager;
@property (nonatomic, strong) HXBCheckCaptcha *checkCaptcha;
@property (nonatomic, copy) void (^isCheckCaptchaSucceedBlock)(NSString *captcha);
@property (nonatomic, strong) HXBCheckCaptchaViewModel *viewModel;

@end

@implementation HXBCheckCaptchaViewController

- (Animatr *)animatrManager {
    if (!_animatrManager) {
        _animatrManager = [Animatr animatrWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animatrManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.animatrManager;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    kWeakSelf
    self.viewModel = [[HXBCheckCaptchaViewModel alloc] init];
    
    [self setUP];
    ///
    [self setUPAnimater];
}

- (void)setUPAnimater{
    __weak typeof (self)weakSelf = self;
    [self.animatrManager presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        weakSelf.animatrManager.isAccomplishAnima = YES;
    }];
    [self.animatrManager dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        [UIView animateWithDuration:0 animations:^{
            
        } completion:^(BOOL finished) {
            weakSelf.animatrManager.isAccomplishAnima = YES;
        }];
    }];
    [self.animatrManager setupContainerViewWithBlock:^(UIView *containerView) {
        containerView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.8];
        UIButton *button = [[UIButton alloc]init];
        [containerView insertSubview:button atIndex:0];
        button.frame = containerView.bounds;
        [button addTarget:self action:@selector(clickContainerView:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}
- (void)clickContainerView: (UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置
- (void) setUP {

    [self setUPSubView];//设置图层
    [self downCheckCaptcha];//请求图验
    [self clickTrueButtonEvent];//点击了确认按钮
    [self clickCheckCaptchaImageViewEvent];///点击了图验图片
}
- (void)setUPSubView {
    self.checkCaptcha = [[HXBCheckCaptcha alloc]init];
    [self.view addSubview:self.checkCaptcha];
//    [self.view addSubview:self.cancelBtn];
    self.view.backgroundColor = [UIColor clearColor];
    [self.checkCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
        make.height.offset(kScrAdaptationH750(440));
        make.width.offset(kScrAdaptationW(280));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kScrAdaptationH750(400));
    }];
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.checkCaptcha.mas_top);
//        make.right.equalTo(self.checkCaptcha.mas_right);
//        make.width.offset(kScrAdaptationW750(50));
//        make.height.offset(kScrAdaptationH750(95));
//    }];
}
///请求数据 图验图片
- (void)downCheckCaptcha {
    kWeakSelf
    [self.viewModel captchaRequestWithResultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.checkCaptcha.checkCaptchaImage = weakSelf.viewModel.captchaImage;
        }
    }];

}
///点击了确定按钮
- (void)clickTrueButtonEvent {
    kWeakSelf
    
    [self.checkCaptcha clickTrueButtonFunc:^(NSString *checkCaptChaStr) {
        //判断验证码是否正确
        [weakSelf.viewModel checkCaptchaRequestWithCaptcha:checkCaptChaStr resultBlock:^(BOOL isSuccess, BOOL needDownload) {
            if (isSuccess) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                if(weakSelf.isCheckCaptchaSucceedBlock) weakSelf.isCheckCaptchaSucceedBlock(checkCaptChaStr);
            } else {
                 weakSelf.checkCaptcha.isCorrect = NO;
                if (needDownload) {
                    [weakSelf downCheckCaptcha];
                }
            }
        }];
    }];
    
    self.checkCaptcha.cancelBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

///**
// 取消按钮的懒加载
// */
//- (UIButton *)cancelBtn
//{
//    if (!_cancelBtn) {
//        _cancelBtn = [[UIButton alloc] init];
//        //        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setImage:[SVGKImage imageNamed:@"close.svg"].UIImage forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _cancelBtn.backgroundColor = [UIColor clearColor];
//        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cancelBtn;
//}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

///点击了图验图片
- (void)clickCheckCaptchaImageViewEvent {
    kWeakSelf
    [self.checkCaptcha clickCheckCaptchaImageViewFunc:^{
        [weakSelf downCheckCaptcha];
    }];
}

///验证通过
- (void)checkCaptchaSucceedFunc:(void (^)(NSString *checkCaptcha))isCheckCaptchaSucceedBlock {
    self.isCheckCaptchaSucceedBlock = isCheckCaptchaSucceedBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
