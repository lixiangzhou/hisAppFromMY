
//
//  NYBannerView.m
//  NYBannerView
//
//  Created by 牛严 on 16/7/4.
//
//

#import "HXBBannerView.h"
#import "BannerModel.h"
#import "TYCyclePagerView.h"
#import "EllipsePageControl.h"
#import "HXBBannerCollectionViewCell.h"

#define kImageViewTitleLabelH 25
#define kBannercellID @"bannercellID"

@interface HXBBannerView ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *bannerView;
@property(nonatomic,strong) EllipsePageControl *bannerPageControl;

@end

@implementation HXBBannerView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bannerView];
        [self addSubview:self.bannerPageControl];
        [self setupUI];
    }
    return self;
}
#pragma mark - UI
- (void)setupUI {
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    [self.bannerPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(kScrAdaptationH(5));
        make.bottom.equalTo(self).offset(-kScrAdaptationH(10));
    }];
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.bannersModel.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HXBBannerCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:kBannercellID forIndex:index];
    cell.bannerModel = self.bannersModel[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) - kScrAdaptationW(45), kScrAdaptationH(160));
    layout.itemSpacing = kScrAdaptationW(15);
    layout.leftSpacing = (CGRectGetWidth(pageView.frame) - layout.itemSize.width - 2 * layout.itemSpacing) * 0.5;
    layout.layoutType = TYCyclePagerTransformLayoutNormal;
    layout.minimumScale = 0.9;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.bannerPageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

/**
 pagerView did selected item cell
 */
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.clickBannerImageBlock) {
        self.clickBannerImageBlock(self.bannersModel[index]);
    }
}

#pragma mark - Network


#pragma mark - Delegate Internal

#pragma mark -


#pragma mark - Delegate External

#pragma mark -


#pragma mark - Action


#pragma mark - Setter / Getter / Lazy

- (void)setBannersModel:(NSArray<BannerModel *> *)bannersModel {
    _bannersModel = bannersModel;
    self.bannerPageControl.numberOfPages = bannersModel.count;
    [self.bannerView reloadData];
}

- (TYCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[TYCyclePagerView alloc] initWithFrame:CGRectZero];
        _bannerView.isInfiniteLoop = YES;
        //设置自动的滚动时间0为不自动滚动
        _bannerView.autoScrollInterval = 0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.isInfiniteLoop = YES;
        // registerClass or registerNib
        [_bannerView registerClass:[HXBBannerCollectionViewCell class] forCellWithReuseIdentifier:kBannercellID];
    }
    return _bannerView;
}

- (EllipsePageControl *)bannerPageControl {
    if (!_bannerPageControl) {
        _bannerPageControl = [[EllipsePageControl alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScrAdaptationW(4))];
        _bannerPageControl.controlSpacing = kScrAdaptationW(4);
        _bannerPageControl.otherColor = kHXBColor_FFFFFF_50;
        _bannerPageControl.currentColor = kHXBColor_FFFFFF_100;
    }
    return _bannerPageControl;
}

@end
