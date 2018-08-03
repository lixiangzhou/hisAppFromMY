//
//  HXBWKWebViewProgressView.m
//  hoomxb
//
//  Created by HXB-C on 2017/11/24.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBWKWebViewProgressView.h"

@interface HXBWKWebViewProgressView ()

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration;

@end

@implementation HXBWKWebViewProgressView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        _barAnimationDuration = 0.5f;
    }
    return self;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}


#pragma mark - UI

- (void)setUI {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _progressBarView.backgroundColor = COR1;
    [self addSubview:_progressBarView];
}

#pragma mark - Action


#pragma mark - Setter / Getter / Lazy
- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    UIView *progressBarView = _progressBarView;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = progressBarView.frame;
        frame.size.width = progress * kScreenWidth;
        progressBarView.frame = frame;
        NSLog(@"进度%lf",progressBarView.width);
    } completion:^(BOOL finished) {
        if (progress >= 1.0) {
            if (self.webViewLoadSuccessBlock) {
                self.webViewLoadSuccessBlock();
            }
            //完成加载之后需要将进度条重置为0
            progressBarView.width = 0;
        }
    }];
    
}

#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
