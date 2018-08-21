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
#import "HSJHomeBannerCell.h"
#import "EllipsePageControl.h"

@interface HSJHomeHeaderView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *titleCycleScrollView;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) UIButton *titleCycleRightBtn;

@property(nonatomic,strong) EllipsePageControl *bannerPageControl;

@end

@implementation HSJHomeHeaderView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FFFFFF_100;
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entryBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)entryBackground:(NSNotification*)notify {
    self.titleCycleScrollView.autoScroll = NO;
    self.bannerView.autoScroll = NO;
}

- (void)becomeActive:(NSNotification*)notify {
    self.titleCycleScrollView.autoScroll = YES;
    self.bannerView.autoScroll = YES;
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
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(kScrAdaptationW750(30), kScrAdaptationH750(10), kScreenWidth - 2 * kScrAdaptationW750(30) , kScrAdaptationH750(300)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.showPageControl = NO;
    self.bannerView.autoScrollTimeInterval = 3;
    [self addSubview:self.bannerView];
    
    self.bannerPageControl = [[EllipsePageControl alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScrAdaptationW(4))];
    self.bannerPageControl.controlSpacing = kScrAdaptationW(4);
    self.bannerPageControl.otherColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.bannerPageControl.currentColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    [self addSubview:self.bannerPageControl];
    
    [self.bannerPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bannerView);
        make.height.offset(kScrAdaptationH(6));
        make.bottom.equalTo(self.bannerView).offset(-kScrAdaptationH(5));
    }];
    
    kWeakSelf
    self.bannerView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        weakSelf.bannerPageControl.currentPage = currentIndex;
    };
}

- (void)setupCycleScrollView {
    self.titleCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH750(64)) delegate:self placeholderImage:nil];
    self.titleCycleScrollView.autoScrollTimeInterval = 2.5;
    self.titleCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.titleCycleScrollView.showPageControl = NO;
    [self.titleCycleScrollView disableScrollGesture];
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

    self.bannerView.localizationImageNamesGroup = homeModel.bannerList;
    self.bannerPageControl.numberOfPages = homeModel.bannerList.count;
    
    if (homeModel.articleList.count) {
        self.titleCycleScrollView.hidden = NO;
    } else {
        self.titleCycleScrollView.hidden = YES;
    }
    self.titleCycleScrollView.localizationImageNamesGroup = homeModel.articleList;
}



// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if ([view isEqual:self.titleCycleScrollView]) {
        return [HSJTitleCollectionViewCell class];
    }
    return [HSJHomeBannerCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    if ([view isEqual:self.titleCycleScrollView]) {
        HSJTitleCollectionViewCell *myCell = (HSJTitleCollectionViewCell *)cell;
        myCell.imageName = self.homeModel.articleList[index].tag;
        myCell.titleStr = self.homeModel.articleList[index].title;
    } else {
        HSJHomeBannerCell *bannerCell = (HSJHomeBannerCell *)cell;
        bannerCell.image = self.homeModel.bannerList[index].image;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == self.bannerView) {
        if (self.bannerDidSelectItemAtIndex) {
            self.bannerDidSelectItemAtIndex(index);
        }
    } else if (cycleScrollView == self.titleCycleScrollView) {
        if (self.titleDidSelectItemAtIndex) {
            self.titleDidSelectItemAtIndex(index);
        }
    }
}




- (UIButton *)titleCycleRightBtn {
    if (!_titleCycleRightBtn) {
        _titleCycleRightBtn = [[UIButton alloc] init];
        [_titleCycleRightBtn setImage:[UIImage imageNamed:@"Home_rightBtn"] forState:(UIControlStateNormal)];
        _titleCycleRightBtn.enabled = NO;
    }
    return _titleCycleRightBtn;
}


@end
