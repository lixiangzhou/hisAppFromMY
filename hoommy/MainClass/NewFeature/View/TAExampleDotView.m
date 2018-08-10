//
//  TAExampleDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-23.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAExampleDotView.h"

static CGFloat const kAnimateDuration = 1;

@interface TAExampleDotView()
@property (nonatomic, assign) CGRect originRect;
@end

@implementation TAExampleDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (void)initialization
{
    self.layer.masksToBounds = YES;
    self.backgroundColor = kHXBBackgroundColor;
    self.originRect = self.frame;
    self.layer.cornerRadius = self.frame.size.width * 0.5;
}


- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    CGRect tempRect = self.frame;
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = kHXBColor_C8C9CF_100;
        self.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y, self.originRect.size.width * 2, self.originRect.size.height);
        self.transform = CGAffineTransformIdentity;
        
        for (NSInteger i = 0; i < self.superview.subviews.count; i++) {
            UIView *v = self.superview.subviews[i];
            if ([v isEqual:self]) {
                continue;
            }
            
            if (v.x > self.x) {
                v.transform = CGAffineTransformMakeTranslation(self.originRect.size.width, 0);
            } else {
                
            }
        }
    } completion:nil];
}

- (void)animateToDeactiveState
{
    CGRect tempRect = self.frame;
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = kHXBColor_E3E4E7_100;
        self.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y, self.originRect.size.width, self.originRect.size.height);
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}

@end
