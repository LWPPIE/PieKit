//
//  LVHUD.h
//  Live
//
//  Created by RoyLei on 16/7/22.
//  Copyright © 2016年 Heller. All rights reserved.
//
#import "LVLoadingView.h"

@interface LVHUD : NSObject

@property (nonatomic, retain) UIView *loginView;

+ (void)showLoding:(UIView *)view;

+ (void)dismissLoding:(UIView *)view;

#pragma mark - Top Alert HUD

/*! @brief 遮盖住statusBar 显示用户提示的HUD。2秒后会自动隐藏
 *
 *  @param msg 显示的字符串
 */
+ (void)showAlertMessage:(NSString *)msg;

/**
 *  遮盖住navbar显示用户提示的HUD。1秒后会自动隐藏
 *
 *  @param msg 显示的字符串
 */
+ (void)showNavBarAlertMessage:(NSString *)msg;
@end
