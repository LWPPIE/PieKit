//
//  LSYAlertView.h
//  ViewTest
//
//  Created by RoyLei on 14-6-30.
//  Copyright (c) 2014年 RoyLei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLSYAlertViewBackgroundImage             [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_bg"]
#define kLSYAlertViewOneButtonImage_Normal       [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_oneButn_normal"]
#define kLSYAlertViewOneButtonImage_Highlight    [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_oneButn_pressed"]
#define kLSYAlertViewLeftButtonImage_Normal      [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_leftButn_normal"]
#define kLSYAlertViewLeftButtonImage_Highlight   [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_leftButn_pressed"]
#define kLSYAlertViewRightButtonImage_Normal     [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_rightButn_normal"]
#define kLSYAlertViewRightButtonImage_Highlight  [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_rightButn_pressed"]
#define kLSYAlertViewMidButtonImage_Normal       [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_midButn_normal"]
#define kLSYAlertViewMidButtonImage_Highlight    [UIImage imageNamed:@"LSYAlertView.bundle/common_alert_win_midButn_pressed"]

@class LSYAlertView;

typedef void (^LSYAlertViewButtonTouchUpInsideBlock)(LSYAlertView *alertView, NSUInteger buttonIndex);

@interface LSYAlertButton : UIControl
@property (nonatomic,readonly) CALayer        *disableLayer;
@property (nonatomic,readonly) UIView         *titleView;
@property (nonatomic,readonly) UIImageView    *imageView;
@property (nonatomic,assign  ) NSTimeInterval interval;//按钮点击后响应延迟
@property (nonatomic,assign  ) NSTimeInterval highlightInterval;//按钮高亮显示延迟
@property (nonatomic,assign  ) BOOL           isPressed;

- (id)initWithFrame:(CGRect)frame title:(NSString *)text;

- (void)setEnabled:(BOOL)enabled;
- (void)addTarget:(id)target action:(SEL)action;
- (void)setNormalImage:(UIImage*)image;
- (void)setHighlightImage:(UIImage*)image;

@end

@protocol LSYAlertViewDelegate <NSObject>

- (void)LSYAlertViewUserTouch:(LSYAlertView *)alertView link:(NSURL*)url;

@end

@interface LSYAlertView : UIView

@property (nonatomic, weak) id<LSYAlertViewDelegate> delegate;

@property (nonatomic, readonly) UIView  *dialogView;
@property (nonatomic, strong  ) UIView  *containerView; //可自定义容器View
@property (nonatomic, strong  ) NSArray *buttonTitles;
@property (nonatomic, readonly) NSArray *buttons;

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonSpacerHeight;
@property (nonatomic, assign) BOOL    useMotionEffects;
@property (nonatomic, assign) BOOL    tapToDissmiss;

@property (nonatomic, copy) LSYAlertViewButtonTouchUpInsideBlock onButtonTouchUpInside;

//显示"标题+消息"富文本样式的AlertView
+ (id)setupWithTitle:(NSString*)title massage:(NSString *)msg buttonTitles:(NSArray *)butnTitles;

/**
 *  生成指定range为蓝色style的string
 *
 *  @param oriString 原始string
 *  @param range     需要转换成蓝色style的range
 *
 *  @return 包含蓝色style的
 */
+ (NSString *)blueColorStyleString:(NSString *)oriString blueRange:(NSRange)range;

/**
 *  生成指定range为红色style的string
 *
 *  @param oriString 原始string
 *  @param ranges    需要转换成蓝色style的range
 *
 *  @return 包含蓝色style的
 */
+ (NSString *)redColorStyleString:(NSString *)oriString redRanges:(NSArray *)ranges;

/*自定义LSYAlertView的ContainerView后，显示与关闭窗口方法。
 *  如:
 *      LSYAlertView *alertView = [[LSYAlertView alloc] init];
 *      alertView.containerView = CustomView;
 *      alertView.buttonTitles  = [NSArray arrayWithObjects:@"OK",@"Cancel", nil];
 *      [alertView show];
 *  关闭:
 *      [alertView close];
 */
- (void)show;
- (void)close;

//LSYAlertView 设置按钮对应事件回调方法
- (void)setOnButtonTouchUpInside:(LSYAlertViewButtonTouchUpInsideBlock)onButtonTouchUpInside;

@end
