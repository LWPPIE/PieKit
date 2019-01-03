//
//  LVBottomSheetView.h
//  Live
//
//  Created by RoyLei on 16/6/22.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LVBottomSheetViewButtonPressedBlock)(NSInteger buttonIndex, UIButton *button);

@interface LVBottomSheetView : UIView

@property (strong, nonatomic, readonly) NSArray <UIButton *> *buttons;

/**
 *  单列
 */
+ (instancetype)sharedSheetView;

/**
 *  底部弹出显示控件
 *
 *  @param titles             如@[@"确认", @"取消"]
 *  @param buttonPressedBlock 按钮点击回调，点击界面弹出
 */
+ (void)showBottomSheetViewWithButtonTitles:(NSArray <NSString *> *)titles
                              buttonPressed:(LVBottomSheetViewButtonPressedBlock)buttonPressedBlock;

/**
 *  消失动画
 */
- (void)dissmiss;

- (void)dissmissWithCompletion:(void(^)(void))completion;

@end
