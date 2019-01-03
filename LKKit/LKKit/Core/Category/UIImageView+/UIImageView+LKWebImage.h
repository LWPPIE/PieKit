//
//  UIImageView+LKWebImage.h
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView(LKWebImage)

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param querySize   显请求尺寸
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                        querySize:(CGSize)querySize;
                  
/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 @param querySize   显请求尺寸
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(UIImage *)placeholder
                        querySize:(CGSize)querySize;
/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 @param completion  完成回调block
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(UIImage *)placeholder
                       completion:(SDExternalCompletionBlock)completion;



/**
 增加过度效果显示图片
 
 @param imageURLStr 图片的地址
 @param placeholder 占位图
 @param supportAnimationImage 是否支持
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                 placeholderImage:(UIImage *)placeholder
            supportAnimationImage:(BOOL)supportAnimationImage;
/**
  增加过度效果显示图片

 @param imageURLStr 图片的地址
 @param placeholder 占位图
 @param querySize 请求图片的大小
 @param supportAnimationImage 是否支持动画的图片，如果为NO的话，就会取第一帧
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                 placeholderImage:(UIImage *)placeholder
                        querySize:(CGSize)querySize
            supportAnimationImage:(BOOL)supportAnimationImage
                        completed:(SDExternalCompletionBlock)completedBlock;

/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr image Url String
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                             placeholder:(UIImage *)placeholder;



/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr  image Url String
 @param compressSize 模糊前压缩尺寸
 @param placeholder  默认图
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                            compressSize:(CGSize)compressSize
                             placeholder:(UIImage *)placeholder;

/**
 获取网络图片后，做模糊处理再显示图片

 @param imageURLStr 图片地址Url
 @param compressSize 模糊前压缩尺寸
 @param placeholder 默认图片
 @param blurRadius 模糊半径
 @param color 模糊颜色
 @param saturationDeltaFactor 饱和度
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                            compressSize:(CGSize)compressSize
                            compressRate:(CGFloat)compressRate
                             placeholder:(UIImage *)placeholder
                              blurRadius:(CGFloat)blurRadius
                               tintColor:(UIColor *)color
                   saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

/**
 头像黑白化

 @param imageURLStr image Url
 @param placeholder 默认图
 */
- (void)lk_setBlackHeaderWithURLStr:(NSString *)imageURLStr
                        placeholder:(UIImage *)placeholder;

/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (UIImage *)lk_cornerRadiusWithImage:(UIImage *)image
                         cornerRadius:(CGFloat)cornerRadius
                       rectCornerType:(UIRectCorner)rectCornerType;

@end
