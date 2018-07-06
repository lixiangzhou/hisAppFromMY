//
//  TBScrollView.m
//  TBClient
//
//  Created by douj on 12-11-12.
//
//

#import "HSJPageScrollView.h"

#define IF_TABLEVIEW_BACKVIEW_OFFY          (30)
#define IF_SCROLLVIEW_BACKVIEW_OFFY         (30)

@interface HSJPageScrollView()

@property (nonatomic, retain) NSMutableSet* viewSet;
@property (nonatomic, assign) BOOL isShowFooter;
//@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@end

@implementation HSJPageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCanJumpAnimation = YES;
    }
    return self;
}

- (void)initView {
    int height = self.bounds.size.height;
    if(self.isShowFooter){
        height -= 30;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleTopMargin
    |UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    _scrollView.backgroundColor = self.backgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    backView.backgroundColor = [UIColor clearColor];
    _backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_big_logo.png"]];
    _backGroundView.frame = CGRectMake((backView.bounds.size.width - _backGroundView.bounds.size.width)/2, (backView.bounds.size.height - _backGroundView.bounds.size.height)/2-IF_SCROLLVIEW_BACKVIEW_OFFY, _backGroundView.bounds.size.width, _backGroundView.bounds.size.height);
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.frame = CGRectMake((backView.bounds.size.width - 200)/2, (backView.bounds.size.height - 100)/2-IF_SCROLLVIEW_BACKVIEW_OFFY, 200, 100);
    [self.refreshBtn addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setImage:[UIImage imageNamed:@"load_failed_bg.png"] forState:UIControlStateNormal];
    self.refreshBtn.hidden = YES;
    self.backGroundView.hidden = YES;
    [backView addSubview:_backGroundView];
    [backView addSubview:_refreshBtn];
    [_scrollView addSubview:backView];
    [_scrollView sendSubviewToBack:backView];
    
    // _scrollView.delaysContentTouches = NO;
    [self addSubview:_scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    _pageControl = [[UIPageControl alloc] initWithFrame:rect];
    _pageControl.userInteractionEnabled = NO;
    if(self.isShowFooter){
        [self addSubview:_pageControl];
    }
    //        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _curPage = 0;
    self.viewSet = [[NSMutableSet alloc] init];
    [self reloadData];
}

- (void)setDataource:(id<HSJPageScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}


- (void)doRefresh
{
    if ([_delegate respondsToSelector:@selector(didRefresh)]) {
        [_delegate didRefresh];
    }
}


- (void)showRefresh:(BOOL)isShow
{
    self.refreshBtn.hidden = !isShow;
    self.backGroundView.hidden = isShow;
}


- (void)showLogo:(BOOL)isShow
{
    self.backGroundView.hidden = !isShow;
    if (isShow && !self.isShowEmptyLogo)
    {
        UIImage *logo = [UIImage imageNamed:@"icon_big_logo.png"];
        self.backGroundView.frame = CGRectMake((self.bounds.size.width - logo.size.width)/2, (self.bounds.size.height - logo.size.height)/2 - IF_SCROLLVIEW_BACKVIEW_OFFY , logo.size.width, logo.size.height);
        self.backGroundView.image = logo;
    }
    else
    {
        self.isShowEmptyLogo = NO;
    }
    self.refreshBtn.hidden = YES;
}


- (void)showEmptyLogo:(BOOL)isShow
{
    self.backGroundView.hidden = !isShow;
    if (isShow) {
        UIImage *logo = [UIImage imageNamed:@"tableview_empty_bg.png"];
        self.backGroundView.frame = CGRectMake((self.bounds.size.width - logo.size.width)/2, (self.bounds.size.height - logo.size.height)/2 - IF_SCROLLVIEW_BACKVIEW_OFFY , logo.size.width, logo.size.height);
        self.backGroundView.image = logo;
    }
    self.refreshBtn.hidden = YES;
}


- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _curPage = 0;
    //CGRect rect = _scrollView.bounds;
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _totalPages, 0);
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.viewSet removeAllObjects];
    }
    
    UIView* currentView =[_datasource pageAtIndex:_curPage];
    [self addView:currentView index:(int)_curPage];
    _scrollView.contentOffset = CGPointMake( currentView.frame.size.width * _curPage, 0);
//    if ([_delegate respondsToSelector:@selector(moveAtIndex:)]) {
//        [_delegate moveAtIndex:_curPage];
//    }

    
    if (_curPage-1>=0) {
        UIView* view =[_datasource pageAtIndex:_curPage-1];
        [self addView:view index:(int)(_curPage-1)];
    }
    if (_curPage+1<_totalPages) {
        UIView* view =[_datasource pageAtIndex:_curPage+1];
        
        [self addView:view index:(int)(_curPage+1)];
    }
//    if(!_singleTap){
//        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                            action:@selector(handleTap:)];
//        _singleTap.numberOfTapsRequired = 1;
//        [self addGestureRecognizer:_singleTap];
//    }
}

-(void)addView:(UIView*)v index:(int)index
{
    if (!v) {
        return;
    }
    v.userInteractionEnabled = YES;
    int height = _scrollView.bounds.size.height;
    CGRect rect = CGRectMake(v.frame.size.width * index, v.frame.origin.y, v.bounds.size.width, height);
    v.frame = rect;
    if(![self.viewSet containsObject:v]){
        [self.viewSet addObject:v];
        [_scrollView addSubview:v];
    }
}

- (void)jumpToView:(NSInteger)index{
    if(index == _curPage){
        return;
    }
    if(index == -1){
        index = 0;
    }
    _curPage = index;
    UIView* currentView =[_datasource pageAtIndex:_curPage];
    [self addView:currentView index:(int)_curPage];
    [_scrollView setContentOffset:CGPointMake( currentView.frame.size.width * _curPage, 0) animated:self.isCanJumpAnimation];
    if (_delegate && [_delegate respondsToSelector:@selector(jumpAtIndex:)]) {
        [_delegate jumpAtIndex:_curPage];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if ([_delegate respondsToSelector:@selector(scrollDidScroll)]) {
        [_delegate scrollDidScroll];
    }

    NSInteger page = 0;
    CGFloat pageWidth = aScrollView.bounds.size.width;
    CGFloat halfWidth = pageWidth/2;
    page = (aScrollView.contentOffset.x +halfWidth) / pageWidth;
    if (page<0) {
        return;
    }
    if (page == _curPage) {
        return;
    }
    else if(page >= [self.datasource numberOfPages]){
        return;
    }
    
    //往下翻一张
    if(page >_curPage) {
        _curPage = page;
        //预加载
        if (_curPage+1 < _totalPages) {
            UIView* currentView =[_datasource pageAtIndex:_curPage+1];
            [self addView:currentView index:(int)_curPage+1];
        }
    }
    //往上
    else
    {
        _curPage = page;
        if (_curPage-1>=0 ) {
            UIView* currentView =[_datasource pageAtIndex:_curPage-1];
            [self addView:currentView index:(int)_curPage-1];
        }
    }
    BOOL bHasCurrentView = NO;
    for (UIView* view in aScrollView.subviews) {
        if (view.frame.origin.x ==view.frame.size.width * _curPage) {
            bHasCurrentView =YES;
            break;
        }
    }
    if (bHasCurrentView == NO) {
        UIView* currentView =[_datasource pageAtIndex:_curPage];
        [self addView:currentView index:(int)_curPage];
    }
    if ([_delegate respondsToSelector:@selector(moveAtIndex:)]) {
        [_delegate moveAtIndex:_curPage];
    }
  

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    if ([_delegate respondsToSelector:@selector(onEndDecelerating:)]) {
        [_delegate onEndDecelerating:_curPage];
        _pageControl.currentPage = _curPage;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(_totalPages > 0){
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _totalPages, 0);
        _scrollView.frame = self.bounds;
        [self initView];
        [self loadData];
        
    }
}
@end
