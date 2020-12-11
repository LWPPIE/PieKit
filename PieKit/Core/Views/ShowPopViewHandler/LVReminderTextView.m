//
//  LVReminderTextView.m
//  TTClub
//
//  Created by RoyLei on 15/9/16.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "LVReminderTextView.h"
#import "LSYConstance.h"
#import "YYCGUtilities.h"
#import "UIView+YYAdd.h"
#import "LKMacros.h"

@implementation LVReminderTextView
{
    UILabel *_label;
}

+ (LVReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                       withCompletion:(LVNoParamsTypeBlock)completion
{
    LVReminderTextView *reminderTextView = [LVReminderTextView new];
    [reminderTextView setReminderText:reminderText];
    [[UIApplication sharedApplication].keyWindow addSubview:reminderTextView];

    [UIView animateWithDuration:0.3 animations:^{
        [reminderTextView setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.3 animations:^{
            [reminderTextView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
            [reminderTextView removeFromSuperview];
        }];
    });
    
    return reminderTextView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setAlpha:0.0f];
    
    self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.9f];
    self.layer.cornerRadius = 6;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 6;
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor colorWithWhite:0.2f alpha:0.9f].CGColor;
    self.userInteractionEnabled = NO;
    self.multipleTouchEnabled = NO;
}

#pragma mark - Getter

- (UILabel *)label
{
    if (!_label) {
        _label =  ({
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,60,24}];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextAlignment:NSTextAlignmentLeft];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = LKUIFont(14);

            titleLabel;
        });
        
        [self addSubview:_label];
    }
    
    return _label;
}

#pragma mark - Setter

- (void)setReminderText:(NSString *)reminderText
{
    if (_reminderText != reminderText) {
        _reminderText = nil;
        
        //去除提示语首尾空格
        _reminderText = [[reminderText stringByTrimmingCharactersInSet:
                             [NSCharacterSet characterSetWithCharactersInString:@" "]] copy];
        self.label.text = _reminderText;

        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label setNumberOfLines:2];
        CGSize size = [self.label sizeThatFits:CGSizeMake(YYScreenSize().width - kDeviceRatio*140, 60)];
        [self.label setCenter:CGPointMake(YYScreenSize().width / 2, YYScreenSize().height / 2)];
        [self setSize:CGSizeMake(size.width + 20, size.height + 20)];
        [self setCenter:CGPointMake(YYScreenSize().width / 2, YYScreenSize().height / 2)];
        [self.label setFrame:CGRectMake(10, 10, size.width, size.height)];
        [self.label sizeToFit];
    }
}

- (void)disapperImmediatelyWithCompletion:(LVNoParamsTypeBlock)completion
{
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];

        if (completion) {
            completion();
        }
        [self removeFromSuperview];
    }];
}

@end
