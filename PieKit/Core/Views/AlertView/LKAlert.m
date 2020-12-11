//
//  LKAlert.m
//  LKKit
//
//  Created by RoyLei on 2017/12/25.
//  Copyright © 2016年 LaKa. All rights reserved.
//

#import "LKAlert.h"

@implementation LKAlert

+ (UIViewController *)rootViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

+ (void)showAlertViewTitle:(NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message
                                                                              message:@""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:confirmAction];
    [[LKAlert rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertViewTitle:(NSString *)message
             confirmAction:(void (^)(UIAlertAction *action))handler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message
                                                                              message:@""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:confirmAction];
    [[LKAlert rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertViewTitle:(NSString *)message
             confirmAction:(void (^)(UIAlertAction *action))okHandler
              cancleAction:(void (^)(UIAlertAction *action))cancleHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message
                                                                              message:@""
                                                                       preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:cancleHandler];
    [alertController addAction:cancleAction];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:okHandler];
    [alertController addAction:confirmAction];
    
    [[LKAlert rootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertViewTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftButtonTitle
          rightButtonTitle:(NSString *)rightButtonTitle
          leftButtonAction:(void (^)(UIAlertAction *action))leftButtonHandler
         rightButtonAction:(void (^)(UIAlertAction *action))rightButtonHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftButtonTitle style:UIAlertActionStyleDefault handler:leftButtonHandler];
    [alertController addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightButtonTitle style:UIAlertActionStyleDefault handler:rightButtonHandler];
    [alertController addAction:rightAction];
    
    [[LKAlert rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
