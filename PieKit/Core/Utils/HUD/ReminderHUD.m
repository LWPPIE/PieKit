//
//  ReminderHUD.m
//  TTClub
//
//  Created by RoyLei on 14/12/3.
//  Copyright (c) 2014年 RoyLei. All rights reserved.
//

#import "ReminderHUD.h"

#import "LSYReminderPatternView.h"
#import "LSYReminderTextView.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@interface ReminderHUD()
{
    UIImageView             *_imageView;
    UIView                  *_contentView;
    BOOL                     _onlyText;
}

@property (strong, nonatomic) UILabel  *titleLable;
@property (strong, nonatomic) LSYReminderPatternView  *patternView;
@property (strong, nonatomic) LSYReminderTextView     *lastReminderTextView;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation ReminderHUD

+ (ReminderHUD*)sharedView
{
    static dispatch_once_t once;
    static ReminderHUD *sharedView;
    dispatch_once(&once, ^ {sharedView = [self new];});
    return sharedView;
}

+ (ReminderHUD*)topTextShareView
{
    static dispatch_once_t onceTextView;
    static ReminderHUD *topTextShareView;
    dispatch_once(&onceTextView, ^ {topTextShareView = [self new];});
    return topTextShareView;
}

+ (void)showReminderText:(NSString *)text
                  inView:(UIView *)inView
              offsetMinY:(CGFloat)offsetMinY
                showTime:(double)time
{
    if(text == nil){
        return;
    }
    
    if ([self topTextShareView].lastReminderTextView) {
        [[self topTextShareView].lastReminderTextView setReminderText:text];
    }else {
        WS(weakSelf)
        LSYReminderTextView *showView = [LSYReminderTextView showReminderTextViewWithText:text
                                                                                delayTime:time
                                                                             continerView:inView
                                                                               offsetMinY:offsetMinY
                                                                           withCompletion:^{
            [weakSelf topTextShareView].lastReminderTextView = nil;
        }];
        [self topTextShareView].lastReminderTextView = showView;
    }
}

+ (void)showReminderText:(NSString *)text delayTime:(double)time
{
    ReminderHUD *reminderView = [self sharedView];
    [reminderView disappearNoRemoveWithCompleteBlock:^{
        [ReminderHUD showCurrentStatusText:text withTime:time];
    }];
}

+ (void)showRunningText:(NSString *)text
{
    ReminderHUD *reminderView = [self sharedView];
    
    [reminderView setRunningText:text];
    if (reminderView.isDisappeared) {
        [reminderView showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }
}

+ (void)showProgress:(CGFloat)progress status:(NSString*)status
{
    ReminderHUD *reminderView = [self sharedView];
    [reminderView setProgress:progress withStatus:status];
    if (reminderView.isDisappeared) {
        [reminderView showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }
}

+ (void)showImage:(UIImage *)image status:(NSString*)status
{
    ReminderHUD *reminderView = [self sharedView];
    [reminderView showReminderAfterLastDisappearWithImage:image withStatus:status];
}

+ (void)showImage:(UIImage *)image delayTime:(double)time text:(NSString*)text
{
    ReminderHUD *reminderView = [self sharedView];
    
    [reminderView setReminderImage:image withStatus:text];
    if (reminderView.isDisappeared) {
        [reminderView showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ReminderHUD disappear];
        });
    }else {
        [ReminderHUD disappear];
    }
}

+ (void)showFailureText:(NSString *)text delayTime:(double)time
{
    UIImage *tipFailureImage = [UIImage imageNamed:@"icon_tip_wrong"];
    [ReminderHUD showImage:tipFailureImage delayTime:time text:text];
}

+ (void)showSuccessText:(NSString *)text delayTime:(double)time
{
    //    UIImage *tipSuccessImage = [UIImage imageNamed:@"icon_tip_complete"];
    //    [ReminderHUD showImage:tipSuccessImage delayTime:time text:text];
    
    ReminderHUD *reminderView = [self sharedView];
    
    [reminderView disappearNoRemoveWithCompleteBlock:^{
        [ReminderHUD showCurrentStatusText:text withTime:time];
    }];
}

+ (void)disappear
{
    ReminderHUD *reminderView = [self sharedView];
    [reminderView disappearNoRemoveFromSuperView];
}

+ (void)disappearWithCompleteBlock:(void (^)(void))complete
{
    ReminderHUD *reminderView = [self sharedView];
    [reminderView disappearNoRemoveWithCompleteBlock:^{
        complete();
    }];
}

//兼容PageBase 提示
+ (void)showCurrentStatusText:(NSString *)noticeString withTime:(NSTimeInterval)time
{
    if(noticeString == nil) {
        return;
    }
    
    if ([self topTextShareView].lastReminderTextView) {
        [[self topTextShareView].lastReminderTextView removeFromSuperview];
        [self topTextShareView].lastReminderTextView = nil;
    }
    
    if ([self topTextShareView].outContainerView) {
        
        LSYReminderTextView *showView = [LSYReminderTextView showReminderTextViewWithText:noticeString
                                                                                delayTime:time
                                                                             continerView:[self topTextShareView].outContainerView
                                                                               offsetMinY:[self topTextShareView].offsetMinY
                                                                           withCompletion:^{
                                                                           }];
        [self topTextShareView].lastReminderTextView = showView;
        
    }else {
        LSYReminderTextView *showView = [LSYReminderTextView showReminderTextViewWithText:noticeString delayTime:time withCompletion:^{
        }];
        [self topTextShareView].lastReminderTextView = showView;
    }
}

#pragma mark - Lifecycle

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self) {
        
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.containerView setFrame:(CGRect){roundf((self.width-120)/2),roundf((self.height-94)/2),120,94}];
    
    if (_onlyText) {
        [_patternView setAlpha:0.0f];
        [_titleLable setCenterY:ceilf(CGRectGetHeight(self.containerView.frame)/2)];
    }else{
        [_patternView setAlpha:1.0f];
        [_patternView setFrame:(CGRect){roundf((self.containerView.width-36)/2),15,36,36}];
        [_titleLable setFrame:(CGRect){10,self.containerView.height-45,self.containerView.width-20,40}];
    }
}

- (void)commonInit
{
    [self setUseBlurEffect:NO];
    [self setUserInteractionEnabled:YES];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    [self.topView addSubview:self.containerView];
    
    [self.containerView.layer setCornerRadius:5.0f];
    [self.containerView.layer setMasksToBounds:YES];
    [self.containerView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self.containerView setFrame:(CGRect){roundf((self.width-120)/2),roundf((self.height-94)/2),120,94}];
    
    _patternView = [[LSYReminderPatternView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLable setNumberOfLines:2];
    [_titleLable setBackgroundColor:[UIColor clearColor]];
    [_titleLable setTextAlignment:NSTextAlignmentCenter];
    [_titleLable setFont:[UIFont systemFontOfSize:15]];
    [_titleLable setTextColor:[UIColor whiteColor]];
    
    [_patternView setFrame:(CGRect){roundf((self.containerView.width-36)/2),15,36,36}];
    [_titleLable setFrame:(CGRect){10,self.containerView.height-45,self.containerView.width-20,40}];
    
    [self.containerView addSubview:_patternView];
    [self.containerView addSubview:_titleLable];
    
    [self.singleTap removeTarget:nil action:nil];
    [self setGestureRecognizers:nil];
    
    [self.containerView setAlpha:0.0f];
}

#pragma mark - Overwrite

- (void)showPopupViewWithAnimation:(LSYPopupAnimationType)animationType
{
    [self.lastReminderTextView disapperImmediatelyWithCompletion:nil];
    self.lastReminderTextView = nil;
    [self.topView setUserInteractionEnabled:NO];
    
    [super showPopupViewWithAnimation:animationType];
}

- (void)disappearNoRemoveFromSuperView
{
    WS(weakSelf)
    [self disappearNoRemoveWithCompleteBlock:^{
        [weakSelf.topView setUserInteractionEnabled:YES];
        
        //        if (weakSelf.patternView.percentage >= 1.0f) {
        //            [weakSelf.patternView setPercentage:0.0f];
        //        }
    }];
}

- (void)disappearNoRemoveWithCompleteBlock:(void (^)(void))complete
{
    WS(weakSelf)
    [super disappearNoRemoveWithCompleteBlock:^(){
        [weakSelf.topView setUserInteractionEnabled:YES];
        if(complete) {
            complete();
        }
    }];
}

#pragma mark - 先隐藏上一次提示，后显示

- (void)showReminderAfterLastDisappearWithText:(NSString *)text
{
    WS(weakSelf)
    [self disappearNoRemoveWithCompleteBlock:^{
        [weakSelf setReminderText:text];
        [weakSelf showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }];
}

- (void)showRunningReminderAfterLastDisappearWithText:(NSString *)text
{
    WS(weakSelf)
    [self disappearNoRemoveWithCompleteBlock:^{
        [weakSelf setRunningText:text];
        [weakSelf showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }];
}

- (void)showReminderAfterLastDisappearWithImage:(UIImage *)image withStatus:(NSString *)status
{
    WS(weakSelf)
    [self disappearNoRemoveWithCompleteBlock:^{
        [weakSelf setReminderImage:image withStatus:status];
        [weakSelf showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }];
}

- (void)showReminderAfterLastDisappearWithProgress:(CGFloat)percentage withStatus:(NSString *)status
{
    WS(weakSelf)
    [self disappearNoRemoveWithCompleteBlock:^{
        [weakSelf setProgress:percentage withStatus:status];
        [weakSelf showPopupViewWithAnimation:LSYPopupAnimationType_Middle];
    }];
}

#pragma mark - Set Display Infomation

- (void)setReminderText:(NSString *)text {
    
    _onlyText = YES;
    
    [_titleLable setText:text];
    [self setNeedsLayout];
}

- (void)setRunningText:(NSString *)text
{
    _onlyText = NO;
    
    [_patternView setIsProgressing:NO];
    [_patternView setImage:nil];
    [_patternView setNeedsDisplay];
    
    [_patternView.indicatorView startAnimating];
    [_titleLable setText:text];
    
    [self setNeedsLayout];
}

- (void)setReminderImage:(UIImage *)image withStatus:(NSString *)status
{
    _onlyText = NO;
    
    [_patternView.indicatorView stopAnimating];
    [_patternView setIsProgressing:NO];
    [_patternView setImage:image];
    [_patternView setNeedsDisplay];
    
    [_titleLable setText:status];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _patternView.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.0);
    [UIView animateWithDuration:0.4 delay:0.1
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         _patternView.layer.transform = CATransform3DIdentity;
                     }completion:nil];
}

- (void)setProgress:(CGFloat)percentage withStatus:(NSString *)status
{
    _onlyText = NO;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [_patternView.indicatorView stopAnimating];
    [_patternView setIsProgressing:YES];
    [_patternView setPercentage:percentage];
    [_titleLable setText:status];
    
}

@end

