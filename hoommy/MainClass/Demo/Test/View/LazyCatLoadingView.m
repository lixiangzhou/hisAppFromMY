//
//  LazyCatLoadingView.m
//  HSFrameProject
//
//  Created by caihongji on 2018/4/24.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "LazyCatLoadingView.h"
#import "HXBNsTimerManager.h"

@interface LazyCatLoadingView()
@property (nonatomic, strong) HXBNsTimerManager* timerManager;
@property (nonatomic, strong) UIView* progressView;
@property (nonatomic, strong) UIImageView* selectPointView;
@property (nonatomic, strong) NSMutableArray* processViewList;

@property (nonatomic, assign) int curSelectIndex;
@property (nonatomic, assign) int pointNumber;

@end

@implementation LazyCatLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (HXBNsTimerManager *)timerManager {
    if(!_timerManager) {
        _timerManager = [HXBNsTimerManager createTimer:1 startSeconds:3600 countDownTime:NO notifyCall:^(NSString *times) {
            
        }];
    }
    
    return _timerManager;
}

- (UIView *)progressView {
    if(!_progressView) {
        CGFloat left = 20;
        CGFloat top = 20;
        CGFloat height = 60;
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(left, top, self.width-2*left, height)];
        int pointNumber = 6;
        self.pointNumber = pointNumber;
        if(pointNumber > 1) {
            CGFloat circleX = 0;
            CGFloat circleWidth = 10;
            CGFloat circleHeiht = 10;
            CGFloat circelY = (self.height-circleHeiht)/2;
            CGFloat distance = (self.width-pointNumber*circleWidth)/(pointNumber-1);
            for(int i=0; i<pointNumber; i++) {
                CGRect rect = CGRectMake(circleX, circelY, circleWidth, circleHeiht);
                UIView *pointView = [self buildCirclePoint:rect];
                [_progressView addSubview:pointView];
                [self.processViewList addObject:pointView];
                if(0 == i){
                    self.selectPointView = [self buildCirclePoint:rect];
                    [_progressView addSubview:self.selectPointView];
                }
                circleX += distance;
            }
        }
    }
    return _progressView;
}

- (UIImageView *)buildCirclePoint:(CGRect)rect {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
    imgV.backgroundColor = [UIColor whiteColor];
    imgV.layer.cornerRadius = rect.size.width/2;
    imgV.layer.masksToBounds = YES;
    
    return imgV;
}

- (void)setupUI {
    self.progressView = nil;
    self.curSelectIndex = 0;
    self.processViewList = [NSMutableArray array];
    
    [self addSubview:self.progressView];
    [self startAnimation];
}

- (void)startAnimation {
    UIView* preProcessView = [self.processViewList safeObjectAtIndex:self.curSelectIndex-1];
    if(self.curSelectIndex >= self.pointNumber) {
        self.curSelectIndex = 0;
    }
    UIView* curProcessView =[self.processViewList safeObjectAtIndex:self.curSelectIndex];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect;
        if(preProcessView){
            rect = preProcessView.frame;
            rect.size.width -= 10;
            rect.size.height-= 10;
            rect.origin.x += 5;
            rect.origin.y += 5;
            preProcessView.frame = rect;
            preProcessView.layer.cornerRadius = rect.size.width/2;
        }
        rect = curProcessView.frame;
        rect.size.width += 10;
        rect.size.height += 10;
        rect.origin.x -= 5;
        rect.origin.y -= 5;
        curProcessView.frame = rect;
        curProcessView.layer.cornerRadius = rect.size.width/2;
    } completion:^(BOOL finished) {
        self.curSelectIndex++;
        [self startAnimation];
    }];
}

- (CGRect)getChangeRect {
    int mid = self.pointNumber/2;
    if(self.curSelectIndex+1 >= self.pointNumber) {
        UIView* processView = (UIView*)[self.processViewList safeObjectAtIndex:0];
        self.selectPointView.frame = processView.frame;
        self.curSelectIndex = 0;
    }
    UIView* processView = [self.processViewList safeObjectAtIndex:self.curSelectIndex+1];
    CGRect rect = processView.frame;
    if(self.curSelectIndex <= mid) {
        rect.size.width += 6;
        rect.size.height += 6;
        rect.origin.x -= 3;
        rect.origin.y -= 3;
    }
    else{
        rect.size.width -= 6;
        rect.size.height -= 6;
        rect.origin.x += 3;
        rect.origin.y += 3;
    }
    return rect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
