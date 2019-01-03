//
//  LKAlert.h
//  LKKit
//
//  Created by RoyLei on 2017/12/25.
//  Copyright © 2016年 LaKa. All rights reserved.
//

@interface LKAlert : NSObject

/**
 显示系统对话框，带一个按钮“确认”

 @param message 显示消息, 按钮是"确定"
 */
+ (void)showAlertViewTitle:(NSString *)message;

/**
 显示系统对话框带两个按钮“确认”、”取消“

 @param message 显示消息
 @param handler “确认”按钮点击事件回调
 */
+ (void)showAlertViewTitle:(NSString *)message
             confirmAction:(void (^)(UIAlertAction *action))handler;

/**
 显示系统对话框，带两个按钮“确认”、”取消“

 @param message 显示消息
 @param confirmHandler “确认”按钮点击事件回调
 @param cancleHandler  “取消”按钮点击事件回调
 */
+ (void)showAlertViewTitle:(NSString *)message
             confirmAction:(void (^)(UIAlertAction *action))confirmHandler
              cancleAction:(void (^)(UIAlertAction *action))cancleHandler;


/**
 显示带两个按钮对系统话框，按钮文本自定义

 @param title 提示标题
 @param message 显示消息
 @param leftButtonTitle 左边按钮名称
 @param rightButtonTitle 右边按钮名称
 @param leftButtonHandler 左边按钮事件
 @param rightButtonHandler 右边按钮事件
 */
+ (void)showAlertViewTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftButtonTitle
          rightButtonTitle:(NSString *)rightButtonTitle
          leftButtonAction:(void (^)(UIAlertAction *action))leftButtonHandler
         rightButtonAction:(void (^)(UIAlertAction *action))rightButtonHandler;

@end
