//
//  LSYRoundImageView.h
//  TTClub
//
//  Created by RoyLei on 15/6/1.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYAnimatedImageView.h"

/**
 *  LSYRoundImageView *roundImageView = [[LSYRoundImageView alloc] initWithFrame:frame];
 *  [roundImageView setRadius:20];
 *  [roundImageView setStrokeColor:UIColorWithHex(0xebebeb)];
 *  [roundImageView setRoundMarkColorNormal:UIColorWithHex(0xf4f4f4)];
 *  [roundImageView setRoundMarkColorHighlight:UIColorWithHex(0xebebeb)];
 */

@interface LSYRoundImageView : YYAnimatedImageView

@property (nonatomic, assign  ) NSInteger   radius; /**<先设置圆角半径*/
@property (nonatomic, copy    ) UIColor     *strokeColor; /**<再设置圆角内描边颜色*/
@property (nonatomic, copy    ) UIColor     *roundMarkColorNormal; /**<其次设置遮罩正常颜色*/
@property (nonatomic, copy    ) UIColor     *roundMarkColorHighlight;/**<最后设置遮罩高亮颜色*/

@property (nonatomic, readonly) UIImageView *roundMarkView;
@property (nonatomic, readonly) UIImageView *highlightRoundMarkView;

/**
 *  @brief  精选优秀新游戏点击后的阴影遮罩
 */
@property (nonatomic, readonly) UIView *bgMarkView;


/**
 *  @brief  设置遮罩高亮, 通常情况下在cell 点击后置高亮时调用
 *
 *  @param isHighlight 是否高亮状态
 */
- (void)setRoundMaskHighlight:(BOOL)isHighlight;

- (void)setRoundMaskHighlight:(BOOL)isHighlight animaiton:(BOOL)animation;

/**
 *  @brief  当Cover需要用Alpha值做动画时，需要建立两层 Cover,此时使用
 */
- (void)setDoubleMaskView;
@end
