//
//  UIViewController+LSYExtension.h
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(LSYExtension)

/**
 *  状态栏需要透明显示
 */
@property (nonatomic, assign) BOOL lv_showNavgationBar;

/**
 *  状态栏是否需要隐藏
 */
@property (nonatomic, assign, getter=lv_isNavigationBarBackgroundHidden) BOOL lv_navigationBarBackgroundHidden;

- (void)setLv_navigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated;

- (void)setLv_navbarBackimageViewAlpha:(CGFloat)alpha;

@end
