//
//  LVUIUtils.h
//  Live
//
//  Created by Laka on 16/3/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LVLineView.h"

@interface LVUIUtils : NSObject

/*! @brief 添加线条。保证始终为1px。
 *  @param style 线条样式，横线还是竖线
 *  @param lineColor 线条颜色。默认为 0xb2b2b2
 *  @return 返回LVLineView 对象
 */
+ (LVLineView *)addLineView:(UIView *)superview style:(LVLineStyle)style color:(UIColor *)lineColor;

/**
 *  金额逗号分割
 *
 *  @param text 金额
 *  @param currency 是否为货币
 *
 *  @return string
 */
+ (NSString *)countNumAndChangeformat:(NSString *)text isCurrency:(BOOL)currency;

/**
 *  生成用于拉伸的UIImage图 (2x1 Or 1*2)像素永久保存内存
 *
 *  @param isVertical      是否垂直拉伸
 *  @param isFirstOpaque   是否第一像素不透明
 *  @param highlightColor  显示的颜色
 *
 *  @return image
 */
+ (UIImage *)getLineImageWithIsVertical:(BOOL)isVertical
                     isFirstPixelOpaque:(BOOL)isFirstOpaque
                         highlightColor:(UIColor *)highlightColor;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInViewNotUseConstrains:(UIView *)parentView
                                                top:(BOOL)isTop
                                         leftMargin:(CGFloat)leftMargin
                                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                          lineWidth:(CGFloat)lineWidth
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                              color:(UIColor *)color
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *)addVerticalLineInView:(UIView *)parentView
                                     right:(BOOL)isRight
                                 topMargin:(CGFloat)topMargin
                              bottomMargin:(CGFloat)bottomMargin;

+ (__kindof UIView *) addVerticalLineInView:(UIView *)parentView
                                      right:(BOOL)isRight
                                      color:(UIColor *)color
                                  topMargin:(CGFloat)topMargin
                               bottomMargin:(CGFloat)bottomMargin;


/**
 添加虚线

 @param parentView
 @param leftMargin 左边的间隙
 @param rightMargin 右边的间隙
 */
+ (__kindof UIView *)addDashesLineInView:(UIView *)parentView
                                     top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;


/**
 添加虚线

 @param parentView 添加到哪一个View
 @param isRight 是否是右边
 @param topMargin 上边的间隙
 @param bottomMargin 下边的间隙
 */
+ (__kindof UIView *)addDashesLineInView:(UIView *)parentView
                                    right:(BOOL)isRight
                              topMargin:(CGFloat)topMargin
                            bottomMargin:(CGFloat)bottomMargin;

+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2;

/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView View
 *  @param frame   frame
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView atFrame:(CGRect)frame;

/**
 *  UIView提取Image
 *
 *  @param theView View
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView;

/**
 *  UIView提取Image
 *
 *  @param theView View
 *  @param scale   缩放值
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView scale:(CGFloat)scale;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param origImage    原始图片
 *  @param frame        YES:裁剪大小
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                               frame:(CGRect)frame
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param orig         原始图片
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param origImage    原始图片
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *  @param lineWidth    内框线宽
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
                     StrokeLineWidth:(CGFloat)lineWidth;

+ (UIImage *)clipImageWithRoundingCorners:(UIRectCorner)corners
                                  ForView:(UIView*)view
                             CornerRadius:(CGFloat)radius
                                    Color:(UIColor *)color
                              StrokeColor:(UIColor *)strokeColor
                                LineWidth:(CGFloat)lineWidth;

/**
 *  获取圆角蒙版Image 永久保存内存
 *
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param size         大小
 *  @param radius       圆角
 *  @param color        蒙版颜色
 *  @param strokeColor  内框颜色
 *
 *  @return Image
 */
+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                                  Size:(CGSize)size
                                Radius:(CGFloat)radius
                                 color:(UIColor *)color
                       withStrokeColor:(UIColor *)strokeColor;

/**
 *  获取纯色圆角Image
 *
 *  @param corners         圆角位置
 *  @param radius          圆角半径
 *  @param size            大小
 *  @param backgroundcolor 背景颜色
 *  @param strokeColor     描边颜色
 *  @param lineWidth       描边线段宽度
 */
+ (UIImage *)getImageWithRoundingCorners:(UIRectCorner)corners
                            cornerRadius:(CGFloat)radius
                                    size:(CGSize)size
                         backgroundcolor:(UIColor *)backgroundcolor
                             strokeColor:(UIColor *)strokeColor
                               lineWidth:(CGFloat)lineWidth;

/**
 *  @brief  生成 masklayer
 *
 *  @param corners 那几个圆角
 *  @param view    要设置的View
 *  @param radius  圆角半径
 *
 */
+ (CAShapeLayer *)makeShapelayerWithRoundingCorners:(UIRectCorner)corners
                                            forView:(UIView*)view
                                   withCornerRadius:(CGFloat)radius;

/**
 打开链接

 @param urlString 跳转到App 链接
 */
+ (void)openURLString:(NSString *)urlString;


/**
  翻倍动画

 @param imageView 需要做翻倍动画的ImageView
 @param toImage 目标图片
 @param duration 动画时间
 @param animations 动画执行
 @param completion 执行结束
 */
+ (void)doubleAnimaitonWithImageView:(UIImageView *)imageView
                             toImage:(UIImage *)toImage
                            duration:(NSTimeInterval)duration
                          animations:(void (^)(void))animations
                          completion:(void (^)(void))completion;

+ (void)doubleAnimaitonWithButton:(UIButton *)button
                             toImage:(UIImage *)toImage
                            duration:(NSTimeInterval)duration
                          animations:(void (^)(void))animations
                          completion:(void (^)(void))completion;
@end
