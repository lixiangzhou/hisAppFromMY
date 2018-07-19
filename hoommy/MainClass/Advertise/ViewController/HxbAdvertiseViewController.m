//
//  HxbAdvertiseViewController.m
//  hoomxb
//
//  Created by HXB-C on 2017/4/19.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "HxbAdvertiseViewController.h"
#import "HXBAdvertiseViewModel.h"
#import <UIImageView+WebCache.h>
#import "HXBRootVCManager.h"
//#import "HXBExtensionMethodTool.h"
#import "HXBAdvertiseManager.h"
#import "UIImage+HXBUtil.h"

@interface HxbAdvertiseViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) HXBAdvertiseViewModel *viewModel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HxbAdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[HXBAdvertiseViewModel alloc] init];
    
    [self setUI];
    
    [self getData];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.image = [UIImage getLauchImage];
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.topImageView];
}

- (void)getData {
    kWeakSelf
    [self.viewModel getSlash:^(BOOL isSuccess) {
        if (isSuccess) {
            [[SDWebImageManager sharedManager] loadImageWithURL:weakSelf.viewModel.imageUrl options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    CGFloat height = kScreenWidth / image.size.width * image.size.height;
                    weakSelf.topImageView.image = image;
                    weakSelf.topImageView.frame = CGRectMake(0, 0, kScreenWidth, height);
                }
            }];
        }
    }];
}

- (void)tapImage {
    if (self.viewModel.canToActivity == NO && self.topImageView.image != nil) {
        return;
    }
    self.topImageView.userInteractionEnabled = NO;
    [self invalidateTimer];
    
    kWeakSelf
    if ([HXBRootVCManager manager].gesturePwdVC) {
        [self.view removeFromSuperview];
        [[HXBRootVCManager manager] showGesturePwd];
        
        [HXBRootVCManager manager].gesturePwdVC.dismissBlock = ^(BOOL delay, BOOL toActivity, BOOL popRightNow) {
            if (delay) {
                /// 延时是为了避免突然出现其他界面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[HXBRootVCManager manager].gesturePwdVC.view removeFromSuperview];
                });
            } else {
                [[HXBRootVCManager manager].gesturePwdVC.view removeFromSuperview];
            }
            if (toActivity) {
                [weakSelf toActivity];
            }
            
            if (popRightNow) {
                [[HXBRootVCManager manager] popWindowsAtHomeAfterSlashOrGesturePwd];
            } else {
                [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
            }
        };
    } else {
        /// 延时是为了避免突然出现其他界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view removeFromSuperview];
        });
        [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
        [self toActivity];
    }
}

- (void)toActivity {
//    UINavigationController *nav = [HXBRootVCManager manager].mainTabbarVC.childViewControllers[0];
//    HXBBaseViewController *homeVC = (HXBBaseViewController *)nav.childViewControllers.firstObject;
//    [HXBExtensionMethodTool pushToViewControllerWithModel:self.viewModel.bannerModel andWithFromVC:homeVC];
}

- (void)dealloc {
    [self invalidateTimer];
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAdvertise) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)dismissAdvertise{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self invalidateTimer];
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _topImageView.userInteractionEnabled = YES;
        [_topImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)]];
    }
    return _topImageView;
}

@end
