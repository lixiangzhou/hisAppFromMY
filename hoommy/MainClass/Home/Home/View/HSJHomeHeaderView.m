//
//  HSJHomeHeaderView.m
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "HSJTitleCollectionViewCell.h"
@interface HSJHomeHeaderView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *titleCycleScrollView;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UIButton *titleCycleRightBtn;

@end

@implementation HSJHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FFFFFF_100;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setupBannerView];
    [self setupCycleScrollView];
    [self.titleCycleScrollView addSubview:self.titleCycleRightBtn];
    [self.titleCycleRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleCycleScrollView);
        make.width.height.offset(kScrAdaptationH750(32));
        make.right.equalTo(self.titleCycleScrollView.mas_right).offset(-kScrAdaptationW750(30));
    }];
}
- (void)setupBannerView {
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.showPageControl = NO;
    self.bannerView.imageURLStringsGroup = @[@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                             @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",];
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.top.equalTo(self).offset(kScrAdaptationW750(10));
        make.height.offset(kScrAdaptationH750(300));
    }];
}

- (void)setupCycleScrollView {
    self.titleCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH750(64)) delegate:self placeholderImage:[UIImage imageNamed:@"123213"]];
    self.titleCycleScrollView.autoScrollTimeInterval = 2.5;
    self.titleCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.titleCycleScrollView.showPageControl = NO;
    self.titleCycleScrollView.localizationImageNamesGroup = @[@"1111",@"455"];
    [self addSubview:self.titleCycleScrollView];
    [self.titleCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kScrAdaptationW750(30));
        make.right.equalTo(self).offset(-kScrAdaptationW750(30));
        make.top.equalTo(self.bannerView.mas_bottom).offset(kScrAdaptationH750(26));
        make.height.offset(kScrAdaptationH750(64));
    }];
}

// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if (view != self.titleCycleScrollView) {
        return nil;
    }
    return [HSJTitleCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    HSJTitleCollectionViewCell *myCell = (HSJTitleCollectionViewCell *)cell;
    myCell.imageName = @"home_message";
}


- (UIButton *)titleCycleRightBtn {
    if (!_titleCycleRightBtn) {
        _titleCycleRightBtn = [[UIButton alloc] init];
        [_titleCycleRightBtn setImage:[UIImage imageNamed:@"Home_rightBtn"] forState:(UIControlStateNormal)];
    }
    return _titleCycleRightBtn;
}

@end
