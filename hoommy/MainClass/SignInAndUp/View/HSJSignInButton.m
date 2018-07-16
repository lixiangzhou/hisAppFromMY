//
//  HSJSignInButton.m
//  hoommy
//
//  Created by HXB-C on 2018/7/12.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJSignInButton.h"

@interface HSJSignInButton () {
    BOOL _enabled;
}
@end
@implementation HSJSignInButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHXBColor_FF7055_40;
        self.enabled = NO;
        self.layer.cornerRadius = kScrAdaptationW(4);
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = kHXBColor_FF7055_100;
    } else {
        self.backgroundColor = kHXBColor_FF7055_40;
    }
}

@end
