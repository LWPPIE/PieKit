//
//  UINavigationBar+Custom.h
//  Live
//
//  Created by RoyLei on 16/6/27.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LVNavEffectViewCustomStyle) {
    LVNavEffectViewCustomDefault = UIBlurEffectStyleExtraLight,//系统默认特效
    LVNavEffectViewCustomLight   = UIBlurEffectStyleLight,//系统白
    LVNavEffectViewCustomDark    = UIBlurEffectStyleDark,//系统黑
    LVNavEffectViewCustomClear//自定义, 清除特效, 即全透明
};

@interface UINavigationBar (LVCustom)

/*!
 @author SYFH
 
 @brief 隐藏导航栏的分割线
 
 @param isBottomLineHidden 是否隐藏
 
 @since 1.0
 */
- (void)lv_bottomLineHidden:(BOOL)isBottomLineHidden;

/*!
 @author SYFH
 
 @brief 设置导航栏的分割线的透明度
 
 @param alpha 透明度
 
 @since 1.0
 */
- (void)lv_bottomLineAlpha:(CGFloat)alpha;

- (void)lv_bottomLineColor:(UIColor *)color;


/*!
 @author SYFH
 
 @brief 自定义导航栏的半透明特效
 
 @param effectViewCustom 特效: 系统默认, 系统白, 系统黑
 
 @since 1.0
 */
- (void)lv_effectViewCustom:(LVNavEffectViewCustomStyle)effectViewCustom;

/*!
 @author SYFH
 
 @brief 设置导航栏的背景颜色
 
 @param backgroundColor 背景色, 支持透明度
 
 @since 1.0
 */
- (void)lv_NavBackgroundColor:(UIColor *)backgroundColor;

/*!
 @author SYFH
 
 @brief 还原默认值
 
 @since 1.0
 */
- (void)lv_NavReset;

/**
 找到navbar底图线段imageView

 */
- (UIImageView *)lv_findBottomLine;

/**
 查找背景View
 */
- (UIImageView *)lv_findBackgroundImageView;

/**
 背景容器View
 */
- (UIView *)lv_findBackgroundView;

/**
 添加NavBar 自定义颜色底部线段

 @param lineColor 线段颜色
 */
- (UIImageView *)lv_addBottomLine:(UIColor *)lineColor;

/**
 底部一线像素图片

 @param color 图片颜色
 */
+ (UIImage *)lv_bottomLineImageWithColor:(UIColor *)color;

@end
