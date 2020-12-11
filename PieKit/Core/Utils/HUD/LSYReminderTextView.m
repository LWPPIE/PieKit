//
//  LSYReminderTextView.m
//  TTClub
//
//  Created by RoyLei on 15/9/16.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "LSYReminderTextView.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"

@interface LSYReminderTextView()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *innerContentView;

@end

@implementation LSYReminderTextView

+ (LSYReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                       withCompletion:(void (^)(void))completion
{
    return [self showReminderTextViewWithText:reminderText
                                    delayTime:delayTime
                                 continerView:[UIApplication sharedApplication].keyWindow
                                   offsetMinY:0
                               withCompletion:completion];
}

+ (LSYReminderTextView *)showReminderTextViewWithText:(NSString *)reminderText
                                            delayTime:(NSTimeInterval)delayTime
                                         continerView:(UIView *)continerView
                                           offsetMinY:(CGFloat)offsetMinY
                                       withCompletion:(void (^)(void))completion
{
    
    LSYReminderTextView *reminderTextView = [LSYReminderTextView new];
    [reminderTextView setReminderText:reminderText];
    
    CGSize size = reminderTextView.size;
    reminderTextView.centerX = continerView.centerX;
    reminderTextView.centerY = continerView.centerY + offsetMinY;
    [reminderTextView.innerContentView setFrame:CGRectInset(reminderTextView.bounds, 2, 2)];
    [reminderTextView.innerContentView setTop:-size.height-8];
    
    [continerView addSubview:reminderTextView];
    
    [UIView animateWithDuration:0.4 animations:^{
        reminderTextView.innerContentView.top = 2;
    } completion:^(BOOL finished) {
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.4 animations:^{
            reminderTextView.innerContentView.top = -size.height-8;
        } completion:^(BOOL finished) {
            [reminderTextView removeFromSuperview];
            if (completion) {
                completion();
            }
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
    self.innerContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.innerContentView];
    
    self.innerContentView.backgroundColor = UIColorHexAndAlpha(0x000000, 0.3);
    self.innerContentView.layer.cornerRadius = 6;
    self.innerContentView.layer.masksToBounds = NO;
    //LKColorRGB(118, 0, 60);
    // self.innerContentView.layer.shadowOffset = CGSizeMake(2, 2);
    // self.innerContentView.layer.shadowRadius = 6;
    // self.innerContentView.layer.shadowOpacity = 1;
    // self.innerContentView.layer.shadowColor = [LKColorRGB(118, 0, 60) colorWithAlphaComponent:0.6].CGColor;
    
    self.userInteractionEnabled = NO;
    self.multipleTouchEnabled = NO;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor clearColor];
    
    [self.innerContentView addSubview:self.label];
}

#pragma mark - Getter

- (UILabel *)label
{
    if (!_label) {
        _label =  ({
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 60, 24}];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            titleLabel.textColor = [UIColor whiteColor];
            //LKColorRGB(255, 226, 91);
            titleLabel;
        });
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        if (!font) {
            font = [UIFont systemFontOfSize:15];
        }
        _label.font = font;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        
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
        
        CGFloat maxWidth = 160;
        CGSize containerSize = CGSizeMake(YYScreenSize().width - 100, 120);
        containerSize = [_reminderText sizeForFont:self.label.font size:containerSize mode:NSLineBreakByWordWrapping];
        containerSize.width += 4;
        containerSize.height += 4;
        
        if (containerSize.width > maxWidth) {
            containerSize = CGSizeMake(140, 120);
            containerSize = [_reminderText sizeForFont:self.label.font size:containerSize mode:NSLineBreakByWordWrapping];
            containerSize.height += 4;
        }
        
        [self setSize:CGSizeMake(containerSize.width + 24, containerSize.height + 24)];
        [self setCenter:CGPointMake(YYScreenSize().width / 2, YYScreenSize().height / 2)];
        [self.innerContentView setFrame:CGRectInset(self.bounds, 2, 2)];
        
        [self.label setFrame:CGRectMake(10, 10, containerSize.width, containerSize.height)];
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
            make.size.mas_equalTo(containerSize);
        }];
    }
}

- (void)disapperImmediatelyWithCompletion:(void (^)(void))completion
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [window setUserInteractionEnabled:YES];
        
        if (completion) {
            completion();
        }
        [self removeFromSuperview];
    }];
}

@end
