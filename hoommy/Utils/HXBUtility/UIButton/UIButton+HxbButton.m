//
//  UIButton+HxbButton.m
//  hoomxb
//
//  Created by HXB-C on 2017/4/19.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "UIButton+HxbButton.h"
#import "HXBColourGradientView.h"

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
static NSString *const kIsColourGradientView = @"isColourGradientView";

@implementation UIButton (HxbButton)
- (void)setIsColourGradientView:(BOOL)isColourGradientView {
    if(isColourGradientView) {
        HXBColourGradientView *view = [[HXBColourGradientView alloc]initWithFrame:self.frame];
        view.endPoint = CGPointMake(0, 41);
        [self addSubview:view];
    }
    objc_setAssociatedObject(self, &kIsColourGradientView, @(isColourGradientView), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isColourGradientView {
   return objc_getAssociatedObject(self, &kIsColourGradientView);
}


//快速创建
+ (instancetype)hxb_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor {
    
    UIButton *button = [[self alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [button sizeToFit];
    
    return button;
}
+(UIButton *)buttonWithImageName:(NSString *)imageName andHighlightImageName:(NSString *)hlImageName andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect{
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIColor *color = [[UIColor alloc]initWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+(UIButton *)buttonWithTitle:(NSString*)title andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect {
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.titleLabel.font = HXB_Text_Font(13);
    [button setTitleColor:[[UIColor alloc]initWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor alloc]initWithRed:0 green:114/255.0 blue:226/255.0 alpha:1] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

+(UIButton *)buttonWithTitle:(NSString*)title andFrameByCategory:(CGRect)rect {
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.titleLabel.font = HXB_Text_Font(14);
    button.layer.cornerRadius = rect.size.height/2.0f;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"grey1300.png"] forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:NO];
    [button setBackgroundImage:[UIImage imageNamed:@"blue1300.png"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    return button;
}

+(UIButton *)btnwithTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect{
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.titleLabel.font = kHXBFont_PINGFANGSC_REGULAR_750(32);
    button.layer.cornerRadius = kScrAdaptationW750(8);
    //    [button setImage:[UIImage imageNamed:@"button-blue03.png"] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"button-blue04.png"] forState:UIControlStateHighlighted];
    //    UILabel *titleLabel = [UILabel labelViewFrameByCategory:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.text = title;
    [button setBackgroundColor:COR29];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[[UIColor alloc]initWithRed:151/255.0f green:151/255.0f blue:151/255.0f alpha:1] forState:UIControlStateHighlighted];
    //[button addSubview:titleLabel];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//右边按钮的筛选／登录按钮
+(UIButton *)rightItemWithTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect {
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    [button setTitleColor:[[UIColor alloc]initWithRed:251/255.0f green:91/255.0f blue:91/255.0f alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor alloc]initWithRed:251/255.0f green:151/255.0f blue:151/255.0f alpha:1] forState:UIControlStateHighlighted];
    button.titleLabel.font = HXB_Text_Font(13);
    [button setTitle:title forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



//textfiled专用button
+(UIButton *)buttonWithTitle1:(NSString*)title andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect {
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.titleLabel.font = HXB_Text_Font(13);
    [button setTitleColor:[[UIColor alloc]initWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    return button;
}
//cell 专用对勾选择button
+(UIButton *)buttonWithImageName:(NSString *)imageName andSelectImageName:(NSString *)hlImageName andTarget:(id)target andAction:(SEL)action andFrameByCategory:(CGRect)rect{
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIColor *color = [[UIColor alloc]initWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}



@end
