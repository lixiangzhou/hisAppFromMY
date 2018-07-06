//
//  HSJTopFragmentNavgationView.m
//  BaichengVisa_v121
//
//  Created by caihongji on 16/4/28.
//  Copyright © 2016年 Beijing Byecity International Travel CO., Ltd. All rights reserved.
//

#import "HSJTopFragmentNavgationView.h"

#define TOOLBAR_BACKGROUND_COLOR UIColorFromRGB(0xffffff)
#define TOOLBAR_SELFONT_COLOR UIColorFromRGB(0x7644c9)
#define TOOLBAR_FONT_COLOR UIColorFromRGB(0x444444)
#define TOOLBAR_SINGLE_LINE_COLOR UIColorFromRGB(0xe9e9e9)
#define TOOLBAR_SEL_LINE_COLOR UIColorFromRGB(0x7644c9)

@interface HSJTopFragmentNavgationView()

@property (nonatomic, assign) int baseTag;
@property (nonatomic, strong) UIView* bottomLineImv;
@property(nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* selLineImv;
@property (nonatomic, strong) NSMutableArray* itemViewList;
@property (nonatomic, strong) NSArray* titleList;
@property (nonatomic, strong) UIView* rightTopView;

@property (nonatomic, assign) CGFloat topLineHeight;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, assign) CGFloat selLineHeight;
@property (nonatomic, assign) CGFloat rightTopViewWidth;
@property (nonatomic, strong) UIView* topLineImv;

@end

@implementation HSJTopFragmentNavgationView

- (void)awakeFromNib{
    [super awakeFromNib];

    [self initView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    _isShowMoreBtn = YES;
    _baseTag = 100;
    self.fontSize = 15;
    self.isCanScroll = YES;
    self.fontColor = TOOLBAR_FONT_COLOR;
    self.fontSelColor = TOOLBAR_SELFONT_COLOR;
    self.selLineColor = TOOLBAR_SEL_LINE_COLOR;
    self.bottomLineColor = TOOLBAR_SINGLE_LINE_COLOR;
    
    self.bottomLineHeight = 0.5;
    self.topLineHeight = 0.5;
    self.selLineHeight = 2;
    self.rightTopViewWidth = 34;
    self.leftDis = 12;
    self.itemDis = 10;
    
    CGFloat y = self.height-self.bottomLineHeight;
    self.bottomLineImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.width, self.bottomLineHeight)];
    self.bottomLineImv.hidden = YES;
    self.bottomLineImv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    self.bottomLineImv.backgroundColor = self.bottomLineColor;
    [self addSubview:self.bottomLineImv];
    
    y = 0;
    self.topLineImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.width, self.topLineHeight)];
    self.topLineImv.hidden = YES;
    self.isShowTopLine = YES;
    self.topLineImv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    self.topLineImv.backgroundColor = self.bottomLineColor;
    [self addSubview:self.topLineImv];
    
}

- (void)updateTopBar{
//    [self setNeedsLayout];
    self.curIndex = -1;
    [self buildToolBar];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self buildToolBar];
}

- (void)buildToolBar{
    if([self.protoDelegate respondsToSelector:@selector(getFontSize)]){
        self.fontSize = [self.protoDelegate getFontSize];
    }
    
    if([self.protoDelegate respondsToSelector:@selector(getTitleList)]){
        self.bottomLineImv.hidden = NO;
        self.topLineImv.hidden = !self.isShowTopLine;
        if(self.scrollView){
            [self.scrollView removeFromSuperview];
            [self.rightTopView removeFromSuperview];
        }
        self.titleList = [self.protoDelegate getTitleList];
        if(self.titleList.count == 0){
            return;
        }
        self.itemViewList = [NSMutableArray array];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-self.bottomLineHeight-self.topLineHeight)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.alwaysBounceHorizontal = NO;
        //    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.scrollView];
        
        int y = self.scrollView.height-self.selLineHeight;
        self.selLineImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 0, self.selLineHeight)];
        [self.scrollView addSubview:self.selLineImv];
        self.selLineImv.backgroundColor = self.selLineColor;
        //
        if(self.isCanScroll){
            self.rightTopView = [self buildRightTopView];
            if(self.rightTopView){
                [self addSubview:self.rightTopView];
            }
        }
        
        int itemW = self.width/self.titleList.count;
        int x = 0;
        int itemH = self.height-self.bottomLineHeight;
        int index = 0;
        for(NSString* title in self.titleList){
            if(self.isCanScroll){
                int titleW = [title caleFontWidhSize:kHXBFont_PINGFANGSC_REGULAR(self.fontSize) forViewHeight:itemH];
                itemW = titleW+2*self.leftDis;
            }
            CGRect rect = CGRectMake(x, 0, itemW, itemH);
            UIView* itemView = [self createItemView:rect itemTitle:title itemIndex:index];
            [self.scrollView addSubview:itemView];
            [self.itemViewList addObject:itemView];
            index++;
            if(self.isCanScroll){
                x += itemW+self.itemDis;
            }
            else{
                x += itemW;
            }
        }
        if(self.isCanScroll){
            self.scrollView.contentSize = CGSizeMake(x+self.rightTopViewWidth, 0);
        }
        
        int jumpToIndex = 0;
        if(self.curIndex > -1){
            jumpToIndex = self.curIndex;
            self.curIndex = -1;
        }
        [self setCurSelection:jumpToIndex];
        
        if (self.isShowMoreBtn == NO) {
            self.rightTopViewWidth = 0;
            [self.rightTopView removeFromSuperview];
        }
        else{
            self.rightTopViewWidth = 34;
        }

        self.topLineImv.backgroundColor = self.bottomLineColor;
        self.bottomLineImv.backgroundColor = self.bottomLineColor;
    }
}

- (UIView*)buildRightTopView{
    int x = self.width-self.rightTopViewWidth;
    UIView* topView= [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.rightTopViewWidth, self.height-self.bottomLineHeight)];
    topView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-12, 0, 12, self.bounds.size.height)];
	shadowImageView.image = [UIImage imageNamed:@"icon_04"];
	[topView addSubview:shadowImageView];
	
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = topView.bounds;
    [topView addSubview:button];
    [button addTarget:self action:@selector(rightViewClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"navagtionbar_icon_03"] forState:UIControlStateNormal];
//    int count = 3;
//    int circelH = 4;
//    int circelDis = 3;
//    int circelViewW = circelH*3+(count-1)*circelDis;
//    UIView* circelView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, circelViewW, circelH+2)];
//    [topView addSubview:circelView];
//    circelView.userInteractionEnabled = NO;
//    x = 0;
//    for (int i =0; i<3; i++) {
//        UIImageView *  imgView=[[UIImageView alloc] initWithFrame:CGRectMake( x, 0, circelH, circelH)];
//        imgView.userInteractionEnabled = NO;
//        [circelView addSubview:imgView];
//        imgView.layer.borderWidth = 0.5;
//        imgView.layer.cornerRadius = circelH/2;
//        imgView.layer.borderColor = [UIColor grayColor].CGColor;
////        imgView.image=[UIImage imageNamed:@"carousel"];
//        x += circelH+circelDis;
//    }
//    CGPoint center = CGPointMake(topView.width/2, topView.height/2);
//    circelView.center = center;
    return topView;
}

- (UIView*)createItemView:(CGRect)frame itemTitle:(NSString*)title itemIndex:(int)index{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    int width = frame.size.width;
    int height = frame.size.height;
    int x = 0;
    int y = 0;
    
    CGRect rect = CGRectMake(x, y, width, height);
    UIButton* itemBt = [[UIButton alloc] initWithFrame:rect];
    [itemBt setTitleColor:self.fontColor forState:UIControlStateNormal];
    itemBt.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR(self.fontSize);
    itemBt.backgroundColor = [UIColor clearColor];
    [itemBt setTitle:title forState:UIControlStateNormal];
    itemBt.tag = _baseTag+index;
    [itemBt addTarget:self action:@selector(itemBtAct:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:itemBt];
    
    return view;
}

- (void)setCurSelection:(NSInteger)index{
    if(_curIndex == index){
        return;
    }
    if(self.isCanScroll){
        UIView* view = [self.itemViewList safeObjectAtIndex:index];
        CGFloat old_off = self.scrollView.contentOffset.x;
        CGFloat new_off = -1;
        
        CGFloat frameW = self.frame.size.width-self.rightTopViewWidth;
        
        if(view.frame.origin.x < old_off){
            new_off = view.frame.origin.x;
        }
        else if(view.frame.origin.x+view.frame.size.width>old_off+frameW){
            new_off = old_off+(view.frame.origin.x+view.frame.size.width)-(old_off+frameW);
        }
        if(new_off > -1){

            self.scrollView.contentOffset = CGPointMake(new_off, 0);
        }
    }
    if(_curIndex == -1){
        _curIndex = 0;
    }
    [self changeFocus:index animate:YES];
}

- (void)changeFocus:(int)index animate:(BOOL)animate{
    
    if (!animate) {
        UIView* view = [self.itemViewList safeObjectAtIndex:_curIndex];
        UIButton* button = (UIButton*)[view viewWithTag:_baseTag+_curIndex];
        [button setTitleColor:self.fontColor forState:UIControlStateNormal];
        
        view = [_itemViewList safeObjectAtIndex:index];
        button = (UIButton*)[view viewWithTag:_baseTag+index];
        
        [button setTitleColor:self.fontSelColor forState:UIControlStateNormal];
        
        UIImageView* imgV = self.selLineImv;
        NSString* titleStr = [self.titleList safeObjectAtIndex:index];
        int textW = [titleStr caleFontWidhSize:kHXBFont_PINGFANGSC_REGULAR(self.fontSize) forViewHeight:view.height];
        
        int offx = (view.width-textW)/4;
        if(!self.isCanScroll){
            offx = 0;
        }
        imgV.left = view.left+offx;
        imgV.width = view.width-2*offx;
        self.curIndex = index;
    }
    else{
        __weak typeof (self) viewBlock = self;
        int preIndex = self.curIndex;
        [UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             UIView* view = [viewBlock.itemViewList safeObjectAtIndex:index];
             //CGRect rect = view.frame;
             UIImageView* imgV = viewBlock.selLineImv;
             NSString* titleStr = [viewBlock.titleList safeObjectAtIndex:index];
             int textW = [titleStr caleFontWidhSize:kHXBFont_PINGFANGSC_REGULAR(viewBlock.fontSize) forViewHeight:view.height];
             int offx = (view.width-textW)/4;
             if(!viewBlock.isCanScroll){
                 offx = 0;
             }
             imgV.left = view.left+offx;
             imgV.width = view.width-2*offx;
             viewBlock.curIndex = index;
             
         } completion:^(BOOL finished) {
             UIView* view = [viewBlock.itemViewList safeObjectAtIndex:preIndex];
             UIButton* button = (UIButton*)[view viewWithTag:viewBlock.baseTag+preIndex];
             [button setTitleColor:viewBlock.fontColor forState:UIControlStateNormal];
            
             view = [viewBlock.itemViewList safeObjectAtIndex:index];
             button = (UIButton*)[view viewWithTag:viewBlock.baseTag+index];
             [button setTitleColor:viewBlock.fontSelColor forState:UIControlStateNormal];
         }];
    }

}

- (void)itemBtAct:(UIButton*)button{
    int index = (int)(button.tag - _baseTag);
    [self setCurSelection:index];
    if([self.protoDelegate respondsToSelector:@selector(itemClick:)]){
        [self.protoDelegate itemClick:index];
    }
}

- (void)rightViewClickAct:(UIButton*)button{
    if([self.protoDelegate respondsToSelector:@selector(rightButtonClickAct)]){
        [self.protoDelegate rightButtonClickAct];
    }
}

- (NSString *)getCurSectctionTitle:(NSInteger)index {
    return [self.titleList safeObjectAtIndex:index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
