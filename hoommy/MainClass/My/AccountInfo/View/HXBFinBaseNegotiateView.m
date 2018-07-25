//
//  HXBFinBaseNegotiateView.m
//  hoomxb
//
//  Created by HXB on 2017/7/17.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBFinBaseNegotiateView.h"
@interface HXBFinBaseNegotiateView ()
///点击了协议
@property (nonatomic,copy) void(^clickNegotiateBlock)();
///点击了对勾
@property (nonatomic,copy)void(^clickCheckMarkBlock)(BOOL isSelected);
///服务协议的Image
@property (nonatomic,strong) UIImageView *negotiateImageView;
///服务协议image后的背景视图
@property (nonatomic,strong) UIButton *negotiateImageViewBackgroundButton;
///服务协议image后的大背景视图(选框和label)
@property (nonatomic,strong) UIButton *negotiateImageViewBackgroundButton_large;
///服务协议
@property (nonatomic,strong) UILabel *negotiateLabel;
///服务协议 button
@property (nonatomic,strong) UIButton *planNegotiateButton;
@property (nonatomic,strong) UIButton *reticuleNegotiateButton;

@end
@implementation HXBFinBaseNegotiateView
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUP];
    }
    return self;
}
- (void)setUP {
    [self creatViews];
    [self setUPViews];
    [self setUPViewsFrame];
}

- (void)creatViews {
    self.negotiateImageViewBackgroundButton = [[UIButton alloc] init];
    self.negotiateImageViewBackgroundButton_large = [[UIButton alloc] init];
    self.negotiateImageView = [[UIImageView alloc]init];
    self.planNegotiateButton = [[UIButton alloc]init];
    self.reticuleNegotiateButton = [[UIButton alloc]init];
    self.negotiateLabel = [[UILabel alloc]init];
    //协议
    [self addSubview:self.negotiateImageViewBackgroundButton_large];
    [self addSubview:self.negotiateImageViewBackgroundButton];
    [self.negotiateImageViewBackgroundButton addSubview:self.negotiateImageView];
    [self addSubview:self.negotiateLabel];
    [self addSubview:self.planNegotiateButton];
    [self addSubview:self.reticuleNegotiateButton];
}

- (void)setUPViewsFrame {
    kWeakSelf
    //协议
    [self.negotiateImageViewBackgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(kScrAdaptationW750(30));
        make.height.width.equalTo(@(kScrAdaptationW750(28)));
    }];
    [self.negotiateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.negotiateImageViewBackgroundButton);
        make.height.width.equalTo(@(kScrAdaptationW750(28)));
    }];
    [self.negotiateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.negotiateImageViewBackgroundButton.mas_right).offset(kScrAdaptationW750(10));
        make.height.equalTo(@(kScrAdaptationH750(26)));
        make.centerY.equalTo(weakSelf);
    }];
    //协议
    [self.negotiateImageViewBackgroundButton_large mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf.negotiateLabel.mas_right);
        make.height.equalTo(@(kScrAdaptationW750(28)));
    }];
    
    [self.planNegotiateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.negotiateLabel.mas_right).offset(0);
        make.height.bottom.equalTo(weakSelf.negotiateLabel);
    }];
    [self.reticuleNegotiateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.planNegotiateButton.mas_right).offset(0);
        make.height.bottom.equalTo(weakSelf.negotiateLabel);
    }];
    
    self.negotiateImageViewBackgroundButton.backgroundColor = [UIColor whiteColor];
    self.negotiateImageViewBackgroundButton.layer.borderColor = kHXBColor_Blue040610.CGColor;
    self.negotiateImageViewBackgroundButton.layer.borderWidth = kXYBorderWidth;
    self.negotiateImageViewBackgroundButton.layer.cornerRadius = kScrAdaptationH750(6);
    self.negotiateImageViewBackgroundButton.layer.masksToBounds = YES;
    self.negotiateImageView.image = [UIImage imageNamed:@"duigou"];
    self.negotiateLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
    self.planNegotiateButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
    self.reticuleNegotiateButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(24);
    self.negotiateLabel.textColor = kHXBColor_Font0_6;
}

- (void)setUPViews {
    [self.planNegotiateButton setTitleColor:kHXBColor_Blue040610 forState:UIControlStateNormal];
    [self.reticuleNegotiateButton setTitleColor:kHXBColor_Blue040610 forState:UIControlStateNormal];
    [self.planNegotiateButton addTarget:self action:@selector(clickNegotiateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.reticuleNegotiateButton addTarget:self action:@selector(clickNegotiateButton1:) forControlEvents:UIControlEventTouchUpInside];
    self.negotiateLabel.text = @"我已阅读并同意";///@"我已阅读并同意";
    
    [self.negotiateImageViewBackgroundButton addTarget:self action:@selector(clickNegotiateImageViewBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.negotiateImageViewBackgroundButton_large addTarget:self action:@selector(clickNegotiateLargeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNegotiateLargeButton:(UIButton *)button {
    [self clickNegotiateImageViewBackgroundButton:self.negotiateImageViewBackgroundButton];
}

- (void)clickNegotiateImageViewBackgroundButton: (UIButton *)button {
    button.selected = !button.selected;
//    self.negotiateImageView.hidden = button.selected;
    if ([_type isEqualToString:@"riskDelegate"]) {
        if (button.selected) {
            self.negotiateImageView.image = [UIImage imageNamed:@"duigou"];
        } else {
            self.negotiateImageView.image = [UIImage imageNamed:@"Rectangle"];
        }
        if (self.clickCheckMarkBlock) {
            self.clickCheckMarkBlock(button.selected);
        }
    } else {
        if (button.selected) {
            self.negotiateImageView.image = [UIImage imageNamed:@"Rectangle"];
        } else {
            self.negotiateImageView.image = [UIImage imageNamed:@"duigou"];
        }
        if (self.clickCheckMarkBlock) {
            self.clickCheckMarkBlock(!button.selected);
        }
    }
}

- (void)setIsDefaultSelect:(BOOL)isDefaultSelect {
    _isDefaultSelect = isDefaultSelect;
    if ([_type isEqualToString:@"riskDelegate"]) {
        self.negotiateImageView.image = [UIImage imageNamed:@"Rectangle"];
        self.negotiateImageViewBackgroundButton.selected = NO;
    }
}

- (void)clickNegotiateButton: (UIButton *)button {
    if (self.block) {
        self.block(1);
    }
    if (self.clickNegotiateBlock) {
        self.clickNegotiateBlock();
    }
}
- (void)clickCheckMarkWithBlock:(void(^)(BOOL isSelected))clickCheckMarkBlock {
    self.clickCheckMarkBlock = clickCheckMarkBlock;
}

- (void)setNegotiateStr:(NSString *)negotiateStr {
    _negotiateStr = negotiateStr;
    if (![negotiateStr containsString:@"《》"] && ![_type isEqualToString:@"riskDelegate"]) {
        _negotiateStr = [NSString stringWithFormat:@"《%@》",negotiateStr];
    }
    [self.planNegotiateButton setTitle:_negotiateStr  forState: UIControlStateNormal];
    if ([_type isEqualToString:@"购买页"]) {
        NSArray *negotiateArray = [_negotiateStr componentsSeparatedByString:@"》,《"];
        NSLog(@"%@", negotiateArray);
        if (negotiateArray.count > 1) {
            [self.planNegotiateButton setTitle:[NSString stringWithFormat:@"%@》，", negotiateArray[0]]  forState: UIControlStateNormal];
            [self.reticuleNegotiateButton setTitle:[NSString stringWithFormat:@"《%@", negotiateArray[1]]  forState: UIControlStateNormal];
        }
    } else if ([_type isEqualToString:@"riskDelegate"]) {
        self.negotiateLabel.text = _negotiateStr;
        [self.planNegotiateButton setTitle:@""  forState: UIControlStateNormal];
        self.negotiateImageView.image = [UIImage imageNamed:@"Rectangle"];
    }
}

- (void)clickNegotiateWithBlock:(void (^)())clickNegotiateBlock {
    self.clickNegotiateBlock = clickNegotiateBlock;
}

- (void)clickNegotiateButton1:(UIButton *)button {
    if (self.block) {
        _block(2);
    }
}

@end
