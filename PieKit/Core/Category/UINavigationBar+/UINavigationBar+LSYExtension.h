//
//  UINavigationBar+LSYExtension.h
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

#define objc_getProperty(objc,key) [objc valueForKey:key]

@interface UINavigationBar(LSYExtension)

@property (nonatomic, assign) CGSize lv_size;

- (UIView * _Nullable)lv_backgroundView;
- (CGSize)lv_sizeThatFits:(CGSize)size;


@end
