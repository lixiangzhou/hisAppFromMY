//
//  HXBNoticeVCViewModel.h
//  hoomxb
//
//  Created by HXB-C on 2018/1/12.
//  Copyright © 2018年 hoomsun-miniX. All rights reserved.
//

#import "HSJBaseViewModel.h"
@class HXBNoticModel;
@interface HXBNoticeVCViewModel : HSJBaseViewModel

@property (nonatomic, strong) HXBNoticModel *noticModel;

/**
 公告
 
 @param isUPReloadData 是否为下拉加载
 @param callbackBlock 回调
 */
- (void)noticeRequestWithisUPReloadData:(BOOL)isUPReloadData andCallbackBlock: (void(^)(BOOL isSuccess))callbackBlock;

@end
