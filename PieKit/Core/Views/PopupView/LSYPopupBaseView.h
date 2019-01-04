//
//  LSYPopupBaseView.h
//  13Helper
//
//  Created by TTClub RoyLei on 14/12/3.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LSYPopupAnimationType_None   = 0,
    LSYPopupAnimationType_Bottom = 1,
    LSYPopupAnimationType_Middle = 2,
    
}LSYPopupAnimationType;

typedef void (^LSYPopupViewDisappear)(id sender);

@interface LSYPopupBaseView : UIView

@property (nonatomic, assign) LSYPopupAnimationType animationType;
@property (nonatomic, copy  ) LSYPopupViewDisappear disappearBlock;

@property (nonatomic, readonly) UIView *topView;        //要显示在顶层 View上
@property (nonatomic, strong  ) UIView *contentView;    //要显示的弹出框内容
@property (nonatomic, strong  ) UIView *containerView;  //内容容器
@property (nonatomic, assign  ) BOOL    useBlurEffect;

@property (nonatomic, assign  ) BOOL  isShowing;
@property (nonatomic, assign  ) BOOL  isAnimating;
@property (nonatomic, assign  ) BOOL  isDisappeared;

@property (nonatomic, readonly) UITapGestureRecognizer *singleTap; //点击非内容区域时 disappear HUD

/**
 *  展示弹出框，可选择动画展示view
 *
 *  @param animationType 选择view出现动画位置
 */
- (void)showPopupViewWithAnimation:(LSYPopupAnimationType)animationType;

/**
 *  隐藏弹出框
 */
- (void)disappear;

/**
 *  隐藏弹出框，但不移除
 */
- (void)disappearNoRemoveFromSuperView;

/**
 *  隐藏弹出框, 但不移除, 带完成回调block
 *
 *  @param complete 完成回调block
 */
- (void)disappearNoRemoveWithCompleteBlock:(void (^)(void))complete;

/**
 *  隐藏弹出框, 带完成回调block
 *
 *  @param complete 完成回调block
 */
- (void)disappearWithCompleteBlock:(void (^)(void))complete;
@end
