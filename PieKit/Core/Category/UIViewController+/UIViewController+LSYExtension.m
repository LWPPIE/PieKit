//
//  UIViewController+LSYExtension.m
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "UIViewController+LSYExtension.h"
#import "UINavigationBar+LSYExtension.h"
#import "UINavigationBar+Custom.h"
#import "UINavigationController+LSYExtension.h"
#import "LSYNavigationBar.h"
#import <objc/runtime.h>

@implementation UIViewController(LSYExtension)

- (void)setLv_navigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden {
    
    CGFloat alpha = navigationBarBackgroundHidden ? 0 : 1;
    
    self.navigationController.lv_navigationBarBackgroundAlpha = alpha;
    
    if ([self.navigationController.navigationBar isKindOfClass:[LSYNavigationBar class]]) {
        LSYNavigationBar *lsyNavigationBar = (LSYNavigationBar *)self.navigationController.navigationBar;
        [lsyNavigationBar.lsyUnderlayView setAlpha:alpha];
    }
    
    objc_setAssociatedObject(self, @selector(lv_isNavigationBarBackgroundHidden), @(navigationBarBackgroundHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setLv_navigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setLv_navigationBarBackgroundHidden:navigationBarBackgroundHidden];
    }];
}

- (BOOL)lv_isNavigationBarBackgroundHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLv_showNavgationBar:(BOOL)showNavgationBar
{
    self.navigationController.navigationBarHidden = !showNavgationBar;
    objc_setAssociatedObject(self, @selector(lv_showNavgationBar), @(showNavgationBar), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)lv_showNavgationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLv_navbarBackimageViewAlpha:(CGFloat)alpha
{
    [[self.navigationController.navigationBar lv_findBackgroundImageView] setAlpha:alpha];
};

@end
