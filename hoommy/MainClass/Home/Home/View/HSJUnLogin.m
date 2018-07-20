//
//  HSJUnLogin.m
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJUnLogin.h"

@interface HSJUnLogin()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HSJUnLogin

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.top.bottom.equalTo(self);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captcha"]];
    }
    return _imageView;
}

@end
