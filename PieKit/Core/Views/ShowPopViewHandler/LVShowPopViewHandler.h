//
//  LSYShowPopViewHandler.h
//  TTClub
//
//  Created by RoyLei on 16/3/12.
//  Copyright © 2016年 TTClub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LVReminderTextView.h"

typedef NS_ENUM(NSInteger, LVShowPopViewType) {
    LVShowPopViewTypeMiddle = 0,
    LVShowPopViewTypeTop = 1,
    LVShowPopViewTypeBottom = 2,
    LVShowPopViewTypeNormalBottom = 3,
};

@interface LVShowPopViewHandler : NSObject

@property (strong, nonatomic, readonly) UIControl *backgroundView;
@property (weak,   nonatomic, readonly) UIView    *containerView;/**<必须先设置containerView*/
@property (weak,   nonatomic, readonly) UIView    *popContentView;

@property (assign, nonatomic) BOOL useBlurBackground;

@property (copy, nonatomic) LVNoParamsTypeBlock backgroundViewPressedBlock;
@property (copy, nonatomic) LVNoParamsTypeBlock viewDidDisappearPressedBlock;

- (void)setBackgroundViewPressedBlock:(LVNoParamsTypeBlock)backgroundViewPressedBlock;
- (void)setViewDidDisappearPressedBlock:(LVNoParamsTypeBlock)viewDidDisappearPressedBlock;

/**
 *  显示弹出框，自定义显示的容器，containerView可以是WINDOW
 *
 *  @param contentView   自定义的中间显示的弹出框
 *  @param containerView 最底层的容器
 *  @param useBlurBackground 使用模糊效果
 *  @param popType       弹出位置
 *
 *  @return LSYShowPopViewHandler 对象
 */
+ (instancetype)showContentView:(UIView *)contentView
                inContainerView:(UIView *)containerView
              useBlurBackground:(BOOL)useBlurBackground
                        popType:(LVShowPopViewType)popType;

/**
 *  中间提示信息文字
 *
 *  @param text 文字
 *  @param time 显示时间
 */
+ (void)showReminderText:(NSString *)text displayTime:(NSTimeInterval)time;

/**
 *  添加键盘通知
 */
- (void)addKeyboardNotify;

/**
 *  消失动画
 */
- (void)dissmiss;

- (void)dissmissWithCompletion:(LVNoParamsTypeBlock)completion;

@end
