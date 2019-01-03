//
//  UIButton+Helper.h
//  Live
//
//  Created by Heller on 16/3/11.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Helper)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

/**
 小红点View
 */
- (UIView *)lv_customBadge;

/**
 *  是否显示按钮上的小红点
 *
 *  @param display YES：显示
 */
- (void)lv_displayRedPoint:(BOOL)display;

/**
 *  快速构造UIButton
 *
 *  @param normalImg    默认图片
 *  @param highlightImg 高亮图片
 *  @param selectedImg 选中图片
 *  @param title        标题
 *
 *  @return UIButton实例对象
 */
+ (UIButton *)createButton:(UIImage *)normalImg
              highlightImg:(UIImage *)highlightImg
               selectedImg:(UIImage *)selectedImg
                     title:(NSString *)title;

/**
 *  custom  up image down title button
 *
 *  @param margin up space from down
 */
- (void)lv_setUpImageAndDownTitleByMargin:(CGFloat)margin;



/**
 返回按钮
 */
+ (instancetype)lk_BackButton;

@end


