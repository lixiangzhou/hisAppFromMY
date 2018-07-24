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
#import "HSJUnLogin.h"
@interface HSJHomeHeaderView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *titleCycleScrollView;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UIButton *titleCycleRightBtn;

@property (nonatomic, strong) HSJUnLogin *unLoginView;

@property (nonatomic, strong) UIView *segmentLineView;

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
    [self addSubview:self.unLoginView];
    [self addSubview:self.segmentLineView];
    [self.titleCycleScrollView addSubview:self.titleCycleRightBtn];
    [self.titleCycleRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleCycleScrollView);
        make.width.height.offset(kScrAdaptationH750(32));
        make.right.equalTo(self.titleCycleScrollView.mas_right).offset(-kScrAdaptationW750(30));
    }];
    [self.unLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleCycleScrollView.mas_bottom).offset(kScrAdaptationH750(32));
        make.height.offset(kScrAdaptationH750(93));
    }];
    [self.segmentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.unLoginView.mas_bottom).offset(kScrAdaptationH750(32));
        make.height.offset(kScrAdaptationH750(20));
    }];
    
}

- (void)updateUI {
    if (KeyChain.isLogin) {
        self.unLoginView.hidden = YES;
        self.segmentLineView.hidden = YES;
    } else {
        self.unLoginView.hidden = NO;
        self.segmentLineView.hidden = NO;
    }
}

- (void)setupBannerView {
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.showPageControl = NO;
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

- (void)setHomeModel:(HSJHomeModel *)homeModel {
    _homeModel = homeModel;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (BannerModel *bannerModel in homeModel.bannerList) {
        [imageArray addObject:bannerModel.image];
    }
    self.bannerView.imageURLStringsGroup = imageArray;
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == self.bannerView) {
        if (self.bannerDidSelectItemAtIndex) {
            self.bannerDidSelectItemAtIndex(index);
        }
    }
}

- (UIButton *)titleCycleRightBtn {
    if (!_titleCycleRightBtn) {
        _titleCycleRightBtn = [[UIButton alloc] init];
        [_titleCycleRightBtn setImage:[UIImage imageNamed:@"Home_rightBtn"] forState:(UIControlStateNormal)];
    }
    return _titleCycleRightBtn;
}

- (HSJUnLogin *)unLoginView {
    if (!_unLoginView) {
        _unLoginView = [[HSJUnLogin alloc] init];
    }
    return _unLoginView;
}

- (UIView *)segmentLineView {
    if (!_segmentLineView) {
        _segmentLineView = [[UIView alloc] init];
        _segmentLineView.backgroundColor = kHXBBackgroundColor;
    }
    return _segmentLineView;
}

@end
