//
//  UIImageView+HxbSDWebImage.h
//  hoomxb
//
//  Created by HXB on 2017/4/14.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HxbSDWebImage)

/**
 * 设置这个属性后，将添加svg图片给self.Image
 */
@property (nonatomic,copy) NSString *svgImageString;



/**
 *  异步加载图片
 *
 *  @param urlStr    图片地址
 *  @param imageName 占位图片名字
 */
- (void)hxb_downloadImage:(NSString *)urlStr placeholder:(NSString *)imageName;

/**
 *  异步加载图片，监听下载进度、成功、失败
 *
 *  @param urlStr    图片地址
 *  @param imageName 占位图片名字
 *  @param downImageSuccessBlock   下载成功
 *  @param downImageFailedBlock    下载失败
 *  @param downImageProgressBlock  下载进度
 */
- (void)hxb_downloadImage:(NSString *)urlStr placeholder:(NSString *)imageName success:(void(^)(UIImage *image))downImageSuccessBlock failed:(void(^)(NSError *error))downImageFailedBlock progress:(void(^)(CGFloat progress))downImageProgressBlock;


/**
 * 本地图片切图
 * @param capImageName 图片的名字
 */
- (void)hxb_capImageWithName: (NSString *)capImageName;
/**
 *设置SVG图片
 */
- (void)hxb_SVGImageWihtName: (NSString *)svgImageName;

/**
 虚线分割线
 */
+ (UIImage *)imageWithLineWithImageView:(UIImageView *)imageView;
/**
 竖线分割线
 */
+ (UIImage *)imageWithVerticalLineWithImageView:(UIImageView *)imageView;
@end
