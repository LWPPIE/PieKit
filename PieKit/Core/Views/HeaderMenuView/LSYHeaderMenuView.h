//
//  LSYHeaderMenuView.h
//  TTClub
//
//  Created by RoyLei on 15/7/16.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYZoomableLabel.h"

#define LSYHeaderMenuViewTitleSize              16
#define LSYHeaderMenuViewTitleLargeSize         17
#define LSYHeaderMenuViewTitleLargeFontSize     [UIFont boldSystemFontOfSize:LSYHeaderMenuViewTitleLargeSize]
#define LSYHeaderMenuViewTitleNormalFontSize    [UIFont boldSystemFontOfSize:LSYHeaderMenuViewTitleSize]

extern NSInteger const LSYHeaderMenuViewDefaultHeight;

typedef void (^LSYHeaderMenuViewPressed)(id sender, NSInteger index);
typedef void (^LSYHeaderMenuViewWillToIndex)(NSInteger toIndex, CGFloat percent);

@interface LSYTitleButton : UIControl

@property (nonatomic, readonly) LSYZoomableLabel *titleLabel;

@end

@interface LSYHeaderMenuView : UIView

@property (nonatomic, readonly) NSMutableArray <LSYTitleButton *> *buttons;
@property (nonatomic, readonly) CGFloat         buttonWidth;
@property (nonatomic, readonly) UIView          *sliderLine;
@property (nonatomic, readonly) LSYTitleButton  *selectButn;
@property (nonatomic, readonly) UIScrollView    *contentView;

@property (nonatomic, assign  ) NSUInteger      selectedIndex;

@property (nonatomic, weak    ) UIScrollView    *contentScrollView;

@property (nonatomic, strong  ) UIColor *titleNormalColor;
@property (nonatomic, strong  ) UIColor *titleSelectedColor;
@property (nonatomic, assign  ) CGFloat  scaleRate;

@property (nonatomic, strong  ) UIFont *titleNormalFont;
@property (nonatomic, strong  ) UIFont *titleSelectedFont;

@property (nonatomic, assign  ) CGFloat lineMinWidth; // Default 66
@property (nonatomic, assign  ) CGFloat lineBottomMargin;//Default is 10
@property (nonatomic, assign  ) BOOL    isEnabled;
@property (nonatomic, assign  ) BOOL    sliderLineFollowScrollView;
@property (nonatomic, assign  ) BOOL    fitSliderLineWidth;

@property (nonatomic, strong  ) NSMutableArray <NSString *>*titles;

/**
 *  按钮之间的空隙
 */
@property (nonatomic, assign  ) NSInteger buttonMargin;

@property (nonatomic, copy) LSYHeaderMenuViewPressed menuPressedButtonBlock;
@property (nonatomic, copy) LSYHeaderMenuViewWillToIndex menuWillToIndexBlock;

- (void)setMenuPressedButtonBlock:(LSYHeaderMenuViewPressed)menuPressedButtonBlock;
- (void)setMenuWillToIndexBlock:(LSYHeaderMenuViewWillToIndex)menuWillToIndexBlock;

/**
 *  注：使用此方法不需要设置frame, 高度使用 LSYHeaderMenuViewDefaultHeight
 */
- (id)initWithTitles:(NSArray *)titles;

/**
 生成TitleButton

 @param title 要显示的Title
 @return LSYTitleButton
 */
- (LSYTitleButton *)makeButtonWithTilte:(NSString *)title;

/**
 后续添加栏目

 @param titles 要添加的标题数组
 */
- (void)addButtonsWithTitles:(NSArray<NSString *> *)titles;

/**
 *  用户点击横向切换View
 *
 *  @param index      指定index
 *  @param scrollView 要切换的scrollView
 */
- (void)selectAnimationWithIndex:(NSInteger)index
                  withScrollView:(UIScrollView *)scrollView;

/**
 *  在UIScrollViewDelegate 方法scrollViewDidScroll中使用
 */
- (void)setSliderLinePositionWithScrollView:(UIScrollView *)scrollView;

- (void)setSliderPosition;

/**
 *  根据滚动位置，设置标题颜色以及放缩文字大小
 *
 *  @param positionX    Slider滚动的位置
 */
- (void)setSliderLinePositionX:(CGFloat)positionX
                   withPercent:(CGFloat)scalePercent
                withScrollView:(UIScrollView *)scrollView;
@end
