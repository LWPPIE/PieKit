//
//  LSYReminderTextView.h
//  TTClub
//
//  Created by RoyLei on 15/9/16.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYReminderTextView : UIView

@property (nonatomic, readonly) UILabel     *label;
@property (nonatomic, copy    ) NSString    *reminderText;

+ (LSYReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                       withCompletion:(void (^)(void))completion;

+ (LSYReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                         continerView:(UIView *)continerView
                                           offsetMinY:(CGFloat)offsetMinY
                                       withCompletion:(void (^)(void))completion;

- (void)disapperImmediatelyWithCompletion:(void (^)(void))completion;

@end
