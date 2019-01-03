//
//  ReminderHUD.h
//  TTClub
//
//  Created by RoyLei on 14/12/3.
//  Copyright (c) 2014年 RoyLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYPopupBaseView.h"

@interface ReminderHUD : LSYPopupBaseView

@property (weak,   nonatomic) UIView *outContainerView; /**< 显示容器View，不为空时offsetMinY生效，否则offsetMinY不生效 */
@property (assign, nonatomic) CGFloat offsetMinY;    /**< 0默认显示在中心位置，offsetMinY标示中心偏移量 */

/**
 HUD文字提示(延迟消失)单例
 */
+ (ReminderHUD *)topTextShareView;

/**
 *  自定义文字提示，手动调用 disappea类方法消失弹框
 *
 *  @param text  提示文字
 *  @param time  延迟消失时间
 */
+ (void)showReminderText:(NSString *)text delayTime:(double)time;

/**
 *  自定义文字提示，手动调用 disappear类方法消失弹框
 *
 *  @param text       提示文字
 *  @param inView     要显示在的容器View
 *  @param offsetMinY 0默认显示在中心位置，offsetMinY标示中心偏移量
 *  @param time       延迟消失时间
 */
+ (void)showReminderText:(NSString *)text
                  inView:(UIView *)inView
              offsetMinY:(CGFloat)offsetMinY
                showTime:(double)time;

/**
 *  使用默认运行中状态，自定义文字提示，手动调用 disappea类方法消失弹框
 *
 *  @param text  提示文字
 */
+ (void)showRunningText:(NSString *)text;

/**
 *  自定义图片文字提示，手动调用 disappea类方法消失弹框
 *
 *  @param image  自定义图片
 *  @param status 当前状态文字
 */
+ (void)showImage:(UIImage *)image status:(NSString*)status;

/**
 *  提示进度展示
 *
 *  @param progress 当前进度
 *  @param status   当前状态文字
 */
+ (void)showProgress:(CGFloat)progress status:(NSString*)status;

/**
 *  隐藏当前提示
 */
+ (void)disappear;

/**
 *  隐藏当前提示加完成执行Block
 */
+ (void)disappearWithCompleteBlock:(void (^)(void))complete;

/**
 *  自定义图片文字提示，延迟消失
 *
 *  @param image 自定义图片
 *  @param time  延迟消失时间
 *  @param text  提示文字
 */
+ (void)showImage:(UIImage *)image delayTime:(double)time text:(NSString*)text;

/**
 *  使用默认成功状态图片，自定义文字提示，延迟消失
 *
 *  @param time  延迟消失时间
 *  @param text  提示文字
 */
+ (void)showSuccessText:(NSString *)text delayTime:(double)time;

/**
 *  使用默认失败状态图片，自定义文字提示，延迟消失
 *
 *  @param time  延迟消失时间
 *  @param text  提示文字
 */
+ (void)showFailureText:(NSString *)text delayTime:(double)time;


@end
