//
//  AXHNewFeatureController.m
//  爱心汇
//
//  Created by kys-4 on 15/12/2.
//  Copyright © 2015年 kys-4. All rights reserved.
//

#import "AXHNewFeatureController.h"
#import "AXHNewFeatureCell.h"
#import "TAPageControl.h"
#import "TAExampleDotView.h"
#import "HXBRootVCManager.h"
#import "HXBAdvertiseManager.h"

@interface AXHNewFeatureController ()<TAPageControlDelegate>
@property (strong, nonatomic) TAPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageData;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation AXHNewFeatureController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 1; i <= 3; i++) {
        if (HXBIPhoneX) {
            [temp addObject:[NSString stringWithFormat:@"Welcome_%ld_x", (long)i]];
        } else {
            [temp addObject:[NSString stringWithFormat:@"Welcome_%ld", (long)i]];
        }
    }
    
    self.imageData =  temp;
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)setUI
{
    [self.collectionView registerClass:[AXHNewFeatureCell class] forCellWithReuseIdentifier:AXHNewFeatureCellID];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    CGFloat marginBottom = HXBIPhoneX ? 60 : 20;
    self.pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - marginBottom - 10, CGRectGetWidth(self.view.frame), 10)];
    self.pageControl.delegate = self;
    self.pageControl.numberOfPages = self.imageData.count;
    self.pageControl.dotViewClass = [TAExampleDotView class];
    self.pageControl.dotSize = CGSizeMake(6, 6);
    self.pageControl.spacingBetweenDots = 6;
    
    [self.view addSubview:self.pageControl];
    
    [self.view addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScrAdaptationH(120));
        make.height.offset(kScrAdaptationH(39));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.pageControl.mas_top).offset(HXBIPhoneX ? -50 : -30);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.pageControl.currentPage = page;
    self.startButton.hidden = page != self.imageData.count - 1;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXHNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AXHNewFeatureCellID forIndexPath:indexPath];
    NSString *imageName = self.imageData[indexPath.row];
    cell.image = [UIImage imageNamed:imageName];
    return cell;
}

#pragma mark - Lazy
- (UIButton *)startButton
{
    if (_startButton == nil) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitle:@"立即体验" forState:(UIControlStateNormal)];
        [_startButton setTitleColor:kHXBColor_FF7055_100 forState:(UIControlStateNormal)];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startButton.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(32);
        _startButton.layer.cornerRadius = 20;
        _startButton.layer.masksToBounds = YES;
        _startButton.layer.borderWidth = 0.5;
        _startButton.layer.borderColor = kHXBColor_FF7055_100.CGColor;
        _startButton.hidden = YES;
        
    }
    return _startButton;
}

#pragma mark - Action
- (void)start
{
    [[HXBRootVCManager manager] makeTabbarRootVC];
    
    if ([HXBAdvertiseManager shared].advertieseImage != nil) {
        [[HXBRootVCManager manager] showSlash];
    } else {
        if ([HXBRootVCManager manager].gesturePwdVC) {
            [[HXBRootVCManager manager] showGesturePwd];
            [HXBRootVCManager manager].gesturePwdVC.dismissBlock = ^(BOOL delay, BOOL toActivity, BOOL popRightNow) {
                [[HXBRootVCManager manager].gesturePwdVC.view removeFromSuperview];
                if (popRightNow) {
                    [[HXBRootVCManager manager] popWindowsAtHomeAfterSlashOrGesturePwd];
                } else {
                    [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
                }
            };
        } else {
            [HXBAdvertiseManager shared].couldPopAtHomeAfterSlashOrGesturePwd = YES;
        }
    }
}


@end
