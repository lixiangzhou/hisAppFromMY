//
//  TAExampleDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-23.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAExampleDotView.h"

static CGFloat const kAnimateDuration = 1;

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
    self.backgroundColor = kHXBBackgroundColor;
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
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = kHXBColor_F55151_100;
        CGAffineTransform transform = CGAffineTransformMakeScale(2, 1);
        self.transform = transform;
    } completion:nil];
}

- (void)animateToDeactiveState
{
    self.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = kHXBBackgroundColor;
    } completion:nil];
}

@end
