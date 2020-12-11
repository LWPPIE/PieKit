//
//  UINavigationBar+Custom.m
//  Live
//
//  Created by RoyLei on 16/6/27.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "UINavigationBar+Custom.h"
#import <objc/runtime.h>
#import "LKMacros.h"
#import "UIImage+YYAdd.h"
#import "UIColor+YYAdd.h"
#import "Masonry.h"
#import <YYKit/NSObject+YYAddForKVO.h>

@implementation UINavigationBar(LVCustom)

static char LVCustomOverlayKey;
static char LVCustomBottomLineKey;

- (UIView *)lv_overlay {
    return objc_getAssociatedObject(self, &LVCustomOverlayKey);
}

- (void)setLv_overlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &LVCustomOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)lv_customBottomLine {
    return objc_getAssociatedObject(self, &LVCustomBottomLineKey);
}

- (void)setLv_customBottomLine:(UIImageView *)overlay {
    objc_setAssociatedObject(self, &LVCustomBottomLineKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lv_NavBackgroundColor:(UIColor *)backgroundColor {
    if (!self.lv_overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.lv_overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.lv_overlay.userInteractionEnabled = NO;
        self.lv_overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.lv_overlay atIndex:1];
    }
    self.lv_overlay.backgroundColor = backgroundColor;
}

- (void)lv_NavReset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.lv_overlay removeFromSuperview];
    self.lv_overlay = nil;
}

- (void)lv_bottomLineHidden:(BOOL)isBottomLineHidden {
    [self lv_findBottomLine].hidden = isBottomLineHidden;
}

- (void)lv_bottomLineAlpha:(CGFloat)alpha {
    [self lv_findBottomLine].alpha = alpha;
}

- (void)lv_bottomLineColor:(UIColor *)color
{
    UIImageView *imageView = [self lv_findBottomLine];
    [imageView setImage:[UIImage imageWithColor:color]];
}

- (void)lv_effectViewCustom:(LVNavEffectViewCustomStyle)effectViewCustom {

    if (effectViewCustom == LVNavEffectViewCustomDefault) {
        return;
    }
    
    NSString *barBackgroundClassString = IOS10 ? @"_UIBarBackground" : @"_UINavigationBarBackground";
    
    for (UIView *subview in self.subviews) {
        
        if ([subview isKindOfClass:NSClassFromString(barBackgroundClassString)]) {
            for (UIView *backdropView in subview.subviews) {
                
                if (effectViewCustom == LVNavEffectViewCustomClear) {
                    [self lv_deleteBackdropEffectViewWithView:backdropView];
                } else {
                    [self lv_deleteBackdropEffectViewWithView:backdropView];
                    
                    UIVisualEffectView *visualEffectView = [self lv_customVisualEffectViewWithStyle:effectViewCustom];
                    [backdropView addSubview:visualEffectView];
                }
            }
        }
    }
}

- (void)lv_deleteBackdropEffectViewWithView:(UIView *)view {
    
    [self lv_deleteBackdropEffectView:view];

    for (UIView *backdropEffectView in view.subviews) {
        [self lv_deleteBackdropEffectView:backdropEffectView];
    }
}

- (void)lv_deleteBackdropEffectView:(UIView *)backdropEffectView
{
    if ([backdropEffectView isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
        [backdropEffectView setHidden:YES];
        [backdropEffectView removeFromSuperview];
    }
}

- (UIVisualEffectView *)lv_customVisualEffectViewWithStyle:(LVNavEffectViewCustomStyle)effectViewCustom {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyle)effectViewCustom];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *contentVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    contentVisualEffectView.frame = visualEffectView.bounds;
    [visualEffectView.contentView addSubview:contentVisualEffectView];
    
    return visualEffectView;
}

- (UIImageView *)lv_findBottomLine {
    
    NSString *barBackgroundClassString = IOS10 ? @"_UIBarBackground" : @"_UINavigationBarBackground";

    for (UIView *subviwe in self.subviews) {
        if ([subviwe isKindOfClass:NSClassFromString(barBackgroundClassString)]) {
            for (UIView *imageView in subviwe.subviews) {
                if ([imageView isKindOfClass:NSClassFromString(@"UIImageView")] && imageView.bounds.size.height <= 1.0) {
                    return (UIImageView *)imageView;
                }
            }
        }
    }
    return nil;
}

- (UIImageView *)lv_findBackgroundImageView {
    
    NSString *barBackgroundClassString = IOS10 ? @"_UIBarBackground" : @"_UINavigationBarBackground";
    
    for (UIView *subviwe in self.subviews) {
        if ([subviwe isKindOfClass:NSClassFromString(barBackgroundClassString)]) {
            for (UIView *imageView in subviwe.subviews) {
                if ([imageView isKindOfClass:NSClassFromString(@"UIImageView")] && CGRectGetHeight(imageView.frame) > 1.0) {
                    return (UIImageView *)imageView;
                }
            }
        }
    }
    return nil;
}

- (UIImageView *)lv_findBackgroundView {
    
    NSString *barBackgroundClassString = IOS10 ? @"_UIBarBackground" : @"_UINavigationBarBackground";
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(barBackgroundClassString)]) {
            return (UIImageView *)subView;
        }
    }
    return nil;
}

- (UIImageView *)lv_addBottomLine:(UIColor *)lineColor
{
    if(IOS10) {
        
        [self lv_bottomLineColor:lineColor];
        return [self lv_findBottomLine];
        
    }else {
        
        [self lv_bottomLineHidden:YES];
        
        if(!self.lv_customBottomLine) {
            
            CGFloat height = 1.0/[UIScreen mainScreen].scale;
            self.lv_customBottomLine = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:lineColor]];
            [[self lv_findBackgroundView] addSubview:self.lv_customBottomLine];
            [self.lv_customBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo([self lv_findBackgroundView].mas_bottom);
                make.left.right.mas_equalTo([self lv_findBackgroundView]);
                make.height.mas_equalTo(height);
            }];
        }else {
            [self.lv_customBottomLine setImage:[UIImage imageWithColor:lineColor]];
        }
        
        return self.lv_customBottomLine;
    }
}

+ (UIImage *)lv_bottomLineImageWithColor:(UIColor *)color
{
    CGFloat height = 1.0/[UIScreen mainScreen].scale;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
