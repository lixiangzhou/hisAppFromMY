//
//  HXBXYAlertViewController.m
//  hoomxb
//
//  Created by HXB on 2017/8/25.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBXYAlertViewController.h"
#import "HXB_XYTools.h"
#import "Animatr.h"
@interface HXBXYAlertViewController ()
@property (nonatomic,strong) Animatr *animatr;
@property (nonatomic,copy) NSString *titleAlert;
@property (nonatomic,assign) int force;
@property (nonatomic,copy) NSString *massage;
@property (nonatomic,copy) NSString *leftButtonMassage;
@property (nonatomic,copy) NSString *rightButtonMassage;
@property (nonatomic, assign) CGFloat messageHeight;
@property (nonatomic, assign) BOOL isScrolled;
/**
 Title
 */
@property (nonatomic,strong) UILabel *mainTitle;

/**
 massageTextView
 */
@property (nonatomic,strong) UITextView *massageTextView;

/**
 leftButton
 */
@property (nonatomic,strong) UIButton *leftButton;
/**
 rightButton
 */
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *containerView;


@end

@implementation HXBXYAlertViewController

- (instancetype) init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.animatr;
        self.isAutomaticDismiss = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      Massage:(NSString *)massage
                        force:(int)force
         andLeftButtonMassage:(NSString *)leftButtonMassage
        andRightButtonMassage:(NSString *)rightButtonMassage {
    self = [[HXBXYAlertViewController alloc]init];
    self.titleAlert = title;
    self.massage = massage;
    self.force = force;
    CGFloat heightMax = kScreenWidth == 320 ? kScrAdaptationH(95) : kScrAdaptationH(90);
    _messageHeight = ceil([[HXB_XYTools shareHandle] heightWithString:massage labelFont:kHXBFont_PINGFANGSC_REGULAR(15) Width:kScrAdaptationW(275)] + kHXBFont_PINGFANGSC_REGULAR(15).lineHeight);
    if (_messageHeight > heightMax) {
        self.isScrolled = YES;
    } else {
        self.isScrolled = NO;
    }
    _messageHeight = _messageHeight > heightMax ? heightMax : _messageHeight;
    self.leftButtonMassage = leftButtonMassage;
    self.rightButtonMassage = rightButtonMassage;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPAnimater];
    [self setUPViews];
}

- (void)setUPAnimater{
    [self.animatr presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        toView.center = [UIApplication sharedApplication].keyWindow.center;
        toView.bounds = CGRectMake(0, 0, kScrAdaptationW(295), kScrAdaptationH(110)+_messageHeight);
        self.animatr.isAccomplishAnima = YES;
    }];
    [self.animatr dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
        [UIView animateWithDuration:0 animations:^{
            
        } completion:^(BOOL finished) {
            self.animatr.isAccomplishAnima = YES;
        }];
    }];
    [self.animatr setupContainerViewWithBlock:^(UIView *containerView) {
        containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        UIButton *button = [[UIButton alloc]init];
        [containerView insertSubview:button atIndex:0];
        button.frame = containerView.bounds;
        [button addTarget:self action:@selector(clickContainerView:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)clickContainerView:(UITapGestureRecognizer *)clickContainerView {
    
}

// 转场动画
- (Animatr *)animatr {
    if (!_animatr) {
        _animatr = [Animatr animatrWithModalPresentationStyle:UIModalPresentationCustom];
    }
    return _animatr;
}

- (void)setUPViews{
    self.view.layer.cornerRadius = kScrAdaptationW(5);
    self.view.layer.masksToBounds = YES;
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.mainTitle];
    [self.view addSubview:self.massageTextView];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [self setUPViewsFrame];
}

- (void)setUPViewsFrame {
    kWeakSelf
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.height.offset(kScrAdaptationH(110)+_messageHeight);
        make.width.offset(weakSelf.view.width);
        make.center.equalTo(weakSelf.view);
    }];
    
    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(kScrAdaptationH(10));
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.offset(kScrAdaptationH(35));
    }];
    
    [self.massageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mainTitle.mas_bottom);
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW(10));
        make.right.equalTo(weakSelf.view).offset(kScrAdaptationW(-10));
        make.height.offset(_messageHeight);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(kScrAdaptationW(20));
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-kScrAdaptationH(20));
        make.width.offset(kScrAdaptationW(115));
        make.height.offset(kScrAdaptationH(35));
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(kScrAdaptationW(-20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.width.offset(kScrAdaptationW(115));
        make.height.offset(kScrAdaptationH(35));
    }];
    
    [self displayData];
}

- (void)displayData {
    self.mainTitle.text = self.titleAlert;
    self.massageTextView.text = self.massage;
    
    if (_force == 1) { // 如果强制。只展示右边按钮
        self.leftButton.hidden = YES;
        [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kScrAdaptationW(20));
            make.right.equalTo(self.view).offset(kScrAdaptationW(-20));
        }];
    } else {
        if (_isHIddenLeftBtn||!self.leftButtonMassage||(self.leftButtonMassage&&[self.leftButtonMassage isEqualToString:@""])) {
            self.leftButton.hidden = YES;
            self.rightButton.layer.cornerRadius = kScrAdaptationW(0);
            self.rightButton.layer.masksToBounds = YES;
            [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(kScrAdaptationW(0));
                make.right.equalTo(self.view).offset(kScrAdaptationW(5));
                make.height.offset(kScrAdaptationH(40));
                make.bottom.equalTo(self.view).offset(kScrAdaptationW(0));
            }];
        } else {
            self.leftButton.hidden = NO;
            [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view).offset(kScrAdaptationW(-20));
                make.width.offset(kScrAdaptationW(115));
                make.height.offset(kScrAdaptationH(35));
            }];
        }
    }
    
    if (_isCenterShow) {
        self.massageTextView.textAlignment = NSTextAlignmentCenter;
    } else {
        self.massageTextView.textAlignment = NSTextAlignmentLeft;
    }
    
    if (self.titleAlert.length > 0) {
        self.mainTitle.hidden = NO;
        [self.massageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kScrAdaptationH(45));
        }];
    } else {
        self.mainTitle.hidden = YES;
        [self.massageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kScrAdaptationH(27.5));
            
        }];
    }

    if (_isScrolled == NO) {
        [_massageTextView setUserInteractionEnabled:NO];
    } else {
        [_massageTextView setUserInteractionEnabled:YES];
    }
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [[UILabel alloc]init];
        _mainTitle.font = kHXBFont_PINGFANGSC_REGULAR(17);
        _mainTitle.textColor = [UIColor blackColor];
        _mainTitle.backgroundColor = [UIColor whiteColor];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}

- (UITextView *)massageTextView {
    if (!_massageTextView) {
        _massageTextView = [[UITextView alloc]init];
        _massageTextView.font = kHXBFont_PINGFANGSC_REGULAR(15);
        _massageTextView.textColor = kHXBColor_Grey_Font0_2;
        _massageTextView.backgroundColor = [UIColor whiteColor];
        _massageTextView.textAlignment = NSTextAlignmentLeft;
        _massageTextView.editable = NO;
    }
    return _massageTextView;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        _rightButton.layer.cornerRadius = kScrAdaptationW(4);
        _rightButton.layer.masksToBounds = YES;
        _rightButton.backgroundColor = COR29;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:self.rightButtonMassage forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    }
    return _rightButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        _leftButton.layer.cornerRadius = kScrAdaptationW(4);
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.borderWidth =  0.5;
        _leftButton.layer.borderColor = COR29.CGColor;
        _leftButton.backgroundColor = [UIColor whiteColor];
        [_leftButton setTitleColor:COR29 forState:UIControlStateNormal];
        [_leftButton setTitle:self.leftButtonMassage forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(14);
    }
    return _leftButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (void)clickLeftButton:(UIButton *)button {
    if (self.isAutomaticDismiss) {
        kWeakSelf
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.clickXYLeftButtonBlock) {
                weakSelf.clickXYLeftButtonBlock();
            }
        }];
    }
    else {
        if (self.clickXYLeftButtonBlock) {
            self.clickXYLeftButtonBlock();
        }
    }
    
}
- (void)clickRightButton: (UIButton *)button {
    if (self.isAutomaticDismiss) {
        kWeakSelf
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.clickXYRightButtonBlock) {
                weakSelf.clickXYRightButtonBlock();
            }
        }];
    }
    else {
        if (self.clickXYRightButtonBlock) {
            self.clickXYRightButtonBlock();
        }
    }
    
}


@end
