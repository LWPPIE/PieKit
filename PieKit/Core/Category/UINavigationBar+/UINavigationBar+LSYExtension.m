//
//  UINavigationBar+LSYExtension.m
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "UINavigationBar+LSYExtension.h"
#import <objc/runtime.h>

@implementation UINavigationBar(LSYExtension)

- (CGSize)lv_sizeThatFits:(CGSize)size {
    CGSize newSize = [super sizeThatFits:size];
    return CGSizeMake(self.lv_size.width == 0.f ? newSize.width : self.lv_size.width, self.lv_size.height == 0.f ? newSize.height : self.lv_size.height);
}

- (void)setLv_size:(CGSize)size {
    objc_setAssociatedObject(self, @selector(size), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sizeToFit];
}

- (CGSize)lv_size {
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (UIView *)lv_backgroundView {
    return objc_getProperty(self, @"_backgroundView");
}

@end
