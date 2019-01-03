//
//  LSYShowAnimation.h
//  13Helper
//
//  Created by TTClub RoyLei on 14/11/25.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYShowAnimation : NSObject

/**
 *  @brief  显示 View 类似 IOS7下 UIAlertView 出现效果
 *
 *  @param view       要显示的 View
 *  @param bgView     背景 View
 *  @param completion 动画完成执行的 Block
 */
+ (void)showViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion;

//showViewWithAnimation 对应的隐藏动画
+ (void)hideViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion;

/**
 *  @brief  从底部弹出 View 类似IOS7 下弹出 UIActionSheet 的效果
 *
 *  @param view       要显示的 View
 *  @param bgView     背景 View
 *  @param fromValue  起始位置
 *  @param toValue    结束位置
 *  @param isBounce   是否加弹跳效果
 *  @param completion 动画完成执行的 Block
 */
+ (void)popupView:(UIView *)view
   backgroundView:(UIView *)bgView
     fromPosition:(NSInteger)fromValue
       toPosition:(NSInteger)toValue
         isBounce:(BOOL)isBounce
       completion:(void (^)(BOOL))completion;

//popupView 对应的隐藏动画
+ (void)disapearPopupView:(UIView *)view
           backgroundView:(UIView *)bgView
             fromPosition:(NSInteger)fromValue
               toPosition:(NSInteger)toValue
               completion:(void (^)(BOOL))completion;
@end
