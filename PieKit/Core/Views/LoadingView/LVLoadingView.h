//
//  LVLoadingView.h
//  Live
//
//  Created by 熙文 张 on 16/3/29.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAnimatedImageView;

typedef NS_ENUM(NSUInteger, LVHUDMaskType) {
    LVHUDMaskTypeNone = 1,  // default mask type, allow user interactions while HUD is displayed
    LVHUDMaskTypeClear,     // don't allow user interactions
};

/**
 *  数据列表第一初始化加载动画
 */
@interface LVLoadingView : UIView
{
    BOOL                    _starting;
}

@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) BOOL                isClearColor;
@property (nonatomic, assign) NSTimeInterval      startTime;
@property (nonatomic, assign) NSTimeInterval      endTime;


/**
 *  添加 LoadingView 到 view 上，没有运行加载动画
 *
 *  @param view  要添加到的view
 *  @param frame LoadingView的frame
 *
 *  @return 返回生成的LoadingView
 */
+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view frame:(CGRect)frame;

+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view;

+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view frame:(CGRect)bounds coverHeader:(BOOL)coverHeader;

+ (LVLoadingView *)findLoadingView:(UIView*)view;

/**
 *  开始加载动画
 *
 *  @param view 要开始的对应的view的加载动画
 */
+ (void)startAnimationTo:(UIView *)view;

/**
 *  隐藏 LoadingView，确保加载动画展示超过200ms后消失
 *  @param view  LSYLoadingView 的父view
 */
+ (void)hideLoadingViewForView:(UIView *)view;


/**
 立刻隐藏加载动画
 @param view
 */
+ (void)hideLoadingViewImmediatelyForView:(UIView *)view;

@end
