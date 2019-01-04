//
//  LSYNLineView.h
//  13Helper
//
//  Created by TTClub RoyLei on 14/11/25.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYNLineView : UIImageView

/**
 *  @brief  贴图显示一像素灰色线段，实际是两像素，一像素透明，一像素特定灰色
 *
 *  @param isVertical       是否是一像素竖线
 *  @param isFirstOpaque    是否第一像素不透明
 */
- (id)initGrayLineWithFrame:(CGRect)frame
                   vertical:(BOOL)isVertical
         isFirstPixelOpaque:(BOOL)isFirstOpaque;


/**
 *  @brief  贴图显示一像素指定颜色线段，实际是两像素，一像素透明，一像素指定颜色
 *
 *  @param isVertical       是否是一像素竖线
 *  @param isFirstOpaque    是否第一像素不透明
 *  @param color            一像素线颜色
 */
- (id)initWithFrame:(CGRect)frame
           vertical:(BOOL)isVertical
 isFirstPixelOpaque:(BOOL)isFirstOpaque
          lineColor:(UIColor *)color;
@end
