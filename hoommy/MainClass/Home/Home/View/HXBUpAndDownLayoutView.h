//
//  HXBUpAndDownLayoutView.h
//  hoomxb
//
//  Created by HXB-C on 2018/7/4.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBUpAndDownLayoutView : UIView

/**
 图片名称
 */
@property (nonatomic, copy) NSString *imageName;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) void(^clickActionBlock)(void);

@end
