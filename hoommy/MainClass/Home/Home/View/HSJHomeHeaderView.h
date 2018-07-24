//
//  HSJHomeHeaderView.h
//  hoommy
//
//  Created by HXB-C on 2018/7/19.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSJHomeModel.h"
@interface HSJHomeHeaderView : UIView

@property (nonatomic, strong) HSJHomeModel *homeModel;

@property (nonatomic, strong) void(^bannerDidSelectItemAtIndex)(NSInteger index);

- (void)updateUI;

@end
