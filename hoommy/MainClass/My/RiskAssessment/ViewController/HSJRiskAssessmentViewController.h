//
//  HSJRiskAssessmentViewController.h
//  hoommy
//
//  Created by HXB-C on 2018/7/9.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HXBBaseWKWebViewController.h"

@interface HSJRiskAssessmentViewController : HXBBaseWKWebViewController
@property (nonatomic,copy) void(^popBlock)(NSString *type);
@end
