//
//  LKDefaultImageView.h
//  LKNovelty
//
//  Created by RoyLei on 16/12/16.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+LKWebImage.h"
/**
 ContentModeCenter模式 显示默认图：default_icon_30，可以自己设置image
 */
@interface LKDefaultImageView : UIImageView

@property (strong, nonatomic, readonly) UIImageView *topImageView;
@property (strong, nonatomic, readonly) UIImageView *coverImageView;
@property (strong, nonatomic, readonly) UIImageView *bgMaskView;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 */
- (void)setImageFadeWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示高斯模糊效果图片
 
 @param imageURLStr image Url String
 */
- (void)setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示高斯模糊效果图片
 
 @param imageURLStr image Url String
 @param querySize   请求图片尺寸
 */
- (void)setImageFadeWithURLStr:(NSString *)imageURLStr querySize:(CGSize)querySize;

/**
 设置图片

 @param imageURL 图片的地址
 @param completion 图片下载成功的回调
 */
- (void)setImage:(NSString *)imageURL completion:(SDExternalCompletionBlock)completion;
/**
 生成渐变层初始化方法
 */
- (instancetype)initWithGradientFrame:(CGRect)frame;

@end
