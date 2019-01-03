//
//  LVReminderTextView.h
//  TTClub
//
//  Created by RoyLei on 15/9/16.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LVNoParamsTypeBlock)(void);

@interface LVReminderTextView : UIView

@property (nonatomic, readonly) UILabel     *label;
@property (nonatomic, copy    ) NSString    *reminderText;

+ (LVReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                       withCompletion:(LVNoParamsTypeBlock)completion;

- (void)disapperImmediatelyWithCompletion:(LVNoParamsTypeBlock)completion;

@end
