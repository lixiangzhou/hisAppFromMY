//
//  TBScrollView.h
//  TBClient
//
//  Created by douj on 12-11-12.
//
//

#import <UIKit/UIKit.h>

@protocol HSJPageScrollViewDelegate;
@protocol HSJPageScrollViewDatasource;

@interface HSJPageScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _totalPages;
    NSInteger _curPage;
}
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) int offX;
@property (nonatomic,assign) int offY;
@property (nonatomic,assign)IBOutlet  id<HSJPageScrollViewDatasource> datasource;
@property (nonatomic,assign) IBOutlet id<HSJPageScrollViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIButton *refreshBtn;

@property (nonatomic,assign) BOOL isShowEmptyLogo; //是否显示裂变为空logo
@property (nonatomic, assign) BOOL isCanJumpAnimation;

- (void)reloadData;
- (void)jumpToView:(NSInteger)index;

/**
 * @brief   设置是否显示刷新按钮
 */
- (void)showRefresh:(BOOL)isShow;

/**
 * @brief   设置是否显示logo
 */
- (void)showLogo:(BOOL)isShow;

/**
 * @brief   设置是否显示数据为空logo
 */
- (void)showEmptyLogo:(BOOL)isShow;

@end

@protocol HSJPageScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(HSJPageScrollView *)csView atIndex:(NSInteger)index;
- (void)moveAtIndex:(NSInteger)index;
- (void)onEndDecelerating:(NSInteger)index;
- (void)jumpAtIndex:(NSInteger)index;
- (void)didRefresh;
- (void)scrollDidScroll;
@end

@protocol HSJPageScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;
@end

