//
//  HXBAgreementView.h
//  hoomxb
//
//  Created by HXB-C on 2017/8/4.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBAgreementView : UIView



/**
* 对应UILabel的text属性
*/
@property (readwrite, nonatomic, copy) id text;

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, assign) BOOL isAllowAllScreenClick;

@property (nonatomic, assign) BOOL hideAgreeBtn;

/**
 点击对号按钮回调的Block
 */
@property (nonatomic, copy) void (^agreeBtnBlock)(BOOL isSelceted);
/**
 对文本中跟withString相同的文字配置富文本，指定的文字为可点击链点！！！
 
 @param attrStr NSAttributedString源
 @param withString 需要设置的文本
 @param sameStringEnable 文本中所有与withAttString相同的文字是否同步设置属性，sameStringEnable=NO 时取文本中首次匹配的NSAttributedString
 @param linkAttributes 链点文本属性
 @param activeLinkAttributes 点击状态下的链点文本属性
 @param parameter 链点自定义参数
 @param clickLinkBlock 链点点击回调
 
 @return 返回新的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(void(^)())clickLinkBlock;


+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                       withDefaultAttributes:(NSDictionary*)defaultAttributes
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(void(^)(void))clickLinkBlock;
@end
