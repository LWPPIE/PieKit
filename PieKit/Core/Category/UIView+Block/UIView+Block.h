//
//  UIView+Block.h
//  cinderella
//
//  Created by Heller on 15/7/10.
//  Copyright (c) 2015年 Laka inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ViewTouchUpInsideBlock)(UIView *sender);

@interface UIView (Block)

- (UITapGestureRecognizer *)addClickBlock:(ViewTouchUpInsideBlock)block;

/**
 *  设置UIButton绑定用户信息
 *
 *  @param userData 任意对象
 */
- (void)setUserData:(id)userData;

/**
 *  返回按钮关联的用户信息
 *
 *  @return 按钮关联的用户信息，默认为空
 */
- (id)getUserData;

@end
