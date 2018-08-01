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
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(kScrAdaptationW750(30), kScrAdaptationH750(10), kScreenWidth - 2 * kScrAdaptationW750(30) , kScrAdaptationH750(300)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.showPageControl = NO;
    self.bannerView.autoScrollTimeInterval = 3;
    [self addSubview:self.bannerView];
}

- (void)setupCycleScrollView {
    self.titleCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScrAdaptationH750(64)) delegate:self placeholderImage:[UIImage imageNamed:@"123213"]];
    self.titleCycleScrollView.autoScrollTimeInterval = 2.5;
    self.titleCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.titleCycleScrollView.showPageControl = NO;
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
//    NSMutableArray *imageArray = [NSMutableArray array];
//    for (BannerModel *bannerModel in homeModel.bannerList) {
//        [imageArray addObject:bannerModel.image];
//    }
//    self.bannerView.imageURLStringsGroup = imageArray;
    self.bannerView.localizationImageNamesGroup = homeModel.bannerList;
    if (homeModel.articleList.count) {
        self.titleCycleScrollView.hidden = NO;
        self.titleCycleScrollView.localizationImageNamesGroup = homeModel.articleList;
    } else {
        self.titleCycleScrollView.hidden = YES;
    }
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
