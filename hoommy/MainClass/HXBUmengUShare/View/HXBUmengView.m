//
//  HXBUmengView.m
//  hoomxb
//
//  Created by HXB-C on 2017/11/13.
//Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HXBUmengView.h"
#import "JXLayoutButton.h"
@interface HXBUmengView ()

@end

@implementation HXBUmengView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - UI

- (void)setUI {
    [self setupSharItem];
}

- (void)setupSharItem {
    
    NSArray *sharingPlatform = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)];
    NSArray *iconNameArr = @[@"wechat",@"frined"];
    NSArray *nameArr = @[@"微信",@"朋友圈"];
    
    int lineCount = 2;//每行的个数
    CGFloat itemHeight = kScrAdaptationH(74);
    CGFloat itemWith = kScrAdaptationW750(100);
    CGFloat leftSpacing = kScrAdaptationW750(175);
    CGFloat itemSpacing = (kScreenWidth - 2 * leftSpacing - lineCount * itemWith)/ (lineCount - 1);
    CGFloat midSpacing = kScrAdaptationH(15);
    UIFont *shareBtnTitleFount = kHXBFont_PINGFANGSC_REGULAR(14);
    
    CGFloat x = leftSpacing;
    for (int i = 0; i < sharingPlatform.count; i++) {
        JXLayoutButton *shareItemBtn = [JXLayoutButton buttonWithType:UIButtonTypeCustom];
        shareItemBtn.frame = CGRectMake(x, 0, itemWith,itemHeight);
        shareItemBtn.titleLabel.font = shareBtnTitleFount;
        [shareItemBtn setTitleColor:COR10 forState:(UIControlStateNormal)];
        
        shareItemBtn.layoutStyle = JXLayoutButtonStyleUpImageDownTitle;
        shareItemBtn.midSpacing = midSpacing;
        [self addSubview:shareItemBtn];
        [shareItemBtn setTitle:nameArr[i] forState:(UIControlStateNormal)];
        shareItemBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *sharetype = sharingPlatform[i];
        shareItemBtn.tag = sharetype.intValue;
        if([[UMSocialManager defaultManager] isInstall:shareItemBtn.tag]) {
            [shareItemBtn addTarget:self action:@selector(shareWithType:) forControlEvents:(UIControlEventTouchUpInside)];
            [shareItemBtn setImage:[UIImage imageNamed:iconNameArr[i]] forState:(UIControlStateNormal)];
            [shareItemBtn setImage:[UIImage imageNamed:iconNameArr[i]] forState:(UIControlStateHighlighted)];
        } else {
            [shareItemBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_useless",iconNameArr[i]]] forState:(UIControlStateNormal)];
            [shareItemBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_useless",iconNameArr[i]]] forState:(UIControlStateHighlighted)];
        }
        x += itemWith+itemSpacing;
    }
}

#pragma mark - Action
- (void)shareWithType:(UIButton *)btn {
    if (self.shareWebPageToPlatformType) {
        self.shareWebPageToPlatformType(btn.tag);
    }
}

#pragma mark - Setter / Getter / Lazy


#pragma mark - Helper


#pragma mark - Other


#pragma mark - Public

@end
