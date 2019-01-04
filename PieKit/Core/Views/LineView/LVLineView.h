//
//  LVLineView.h
//  Live
//
//  Created by 熙文 张 on 16/3/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

typedef NS_ENUM(NSInteger, LVLineStyle) {
    LVLineVerticalStyle,        //垂直
    LVLineHorizontaStyle,       //水平
};

@interface LVLineView : UIView



/**
 * @brief 网格颜色，默认蓝色
 */
@property (nonatomic, strong) UIColor   *lineColor;



@property (nonatomic, assign) LVLineStyle style;

@end
