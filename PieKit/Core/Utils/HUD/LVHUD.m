//
//  LVHUD.m
//  Live
//
//  Created by RoyLei on 16/7/22.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVHUD.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"
#import "YYLabel.h"
#import "NSString+YYAdd.h"
#import "NSTimer+YYAdd.h"
#import "ReminderHUD.h"

#define PADDING 10.0f
#define SCROLL_SPEED 40.0f
#define SCROLL_DELAY 1.0f

typedef NS_ENUM(NSInteger, LVHUDStyle) {
    LVHUDStyleStatusBar = 0,
    LVHUDStyleNavgationBar,
};

typedef void(^LVDelayedBlockHandle)(BOOL cancel);

static LVDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block)
{
    if (block == nil) {
        return nil;
    }
    
    __block dispatch_block_t blockToExecute = [block copy];
    __block LVDelayedBlockHandle delayHandleCopy = nil;
    
    LVDelayedBlockHandle delayHandle = ^(BOOL cancel){
        if (NO == cancel && nil != blockToExecute) {
            dispatch_async(dispatch_get_main_queue(), blockToExecute);
        }
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
};

/**
 * A subclass of @c UILabel that scrolls the text if it is too long for the
 * label.
 */
@interface LVScrollLabel : UILabel
/**
 * Used to find the amount of time that the label will spend scrolling.
 * @return The amount of time that will be spent scrolling.
 */
- (CGFloat)scrollTime;
@end

@interface LVHUDMassage : NSObject
@property (strong, nonatomic) NSString      *massage;
@property (assign, nonatomic) LVHUDStyle    style;
@end

@implementation LVHUDMassage
@end

@interface LVHUD()
{
    BOOL _isShowing;
    BOOL _dissmissed;
    BOOL _beginDissmiss;

}
@property (strong, nonatomic) LVScrollLabel *label;
@property (strong, nonatomic) UIView        *statusBarView;
@property (strong, nonatomic) UIView        *statusBarCloneView;
@property (strong, nonatomic) UIView        *contentView;
@property (assign, nonatomic) LVHUDStyle     style;

@property (strong, nonatomic) NSMutableArray  *statusBarQueue;
@property (strong, nonatomic) NSMutableArray  *navBarmassageQueue;

@property (strong, nonatomic) UIImageView  *statusBarImageView;
@property (strong, nonatomic) NSTimer *checkTimer;
@end

@implementation LVHUD

+ (LVHUD *)sharedHUD
{
    static dispatch_once_t once;
    static LVHUD *sharedHUD;
    dispatch_once(&once, ^ {sharedHUD = [self new];});
    return sharedHUD;
}

+ (void)showLoding:(UIView *)aView
{
    LVLoadingView *loadingView = [LVLoadingView showLoadingViewAddedTo:aView];
    [loadingView setIsClearColor:YES];
    [LVLoadingView startAnimationTo:aView];
}

+ (void)dismissLoding:(UIView *)view
{
    [LVLoadingView hideLoadingViewForView:view];
}

+ (void)showNavBarAlertMessage:(NSString *)msg
{
    if (msg.length == 0) {
        return;
    }
    
    [[LVHUD sharedHUD] addMassageToQueue:msg style:LVHUDStyleNavgationBar];
}

+ (void)showAlertMessage:(NSString *)msg
{
    if (msg.length == 0) {
        return;
    }

    // 使用中间提示
    [ReminderHUD showReminderText:msg delayTime:2.5];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dissmissed = YES;
        _statusBarQueue = [NSMutableArray array];
        _navBarmassageQueue = [NSMutableArray array];

    }
    return self;
}

- (void)addMassageToQueue:(NSString *)msg style:(LVHUDStyle)style
{
    LVHUDMassage *massage = [LVHUDMassage new];
    massage.style = style;
    massage.massage = msg;
    
    switch (style) {
        case LVHUDStyleStatusBar: {
            [self.statusBarQueue addObject:massage];
            [self showStatusBarHUDWithMassage:massage];
            break;
        }
        case LVHUDStyleNavgationBar: {
            [self.navBarmassageQueue addObject:msg];
            [self showNavBarHUDWithMassage:massage];
            break;
        }
    }
}

- (void)showNavBarHUDWithMassage:(LVHUDMassage *)msg
{
    if (!_dissmissed){
        return;
    }
    
    self.style = LVHUDStyleNavgationBar;
    
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg.massage;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.width = kDeviceWidth;
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.height = [msg.massage heightForFont:label.font width:label.width] + 2 * padding + LSYStatusHeight;
    
    label.bottom = -label.height;
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [UIView animateWithDuration:0.3 animations:^{
        label.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = -label.height;
        } completion:^(BOOL finished) {
            
            _dissmissed = YES;
            [label removeFromSuperview];
            [self dequeueMassage:msg loopShow:YES];
        }];
    }];
}

- (void)showStatusBarHUDWithMassage:(LVHUDMassage *)msg
{
    if(_dissmissed){
        
        self.label.text = msg.massage;

        self.statusBarImageView = [[UIImageView alloc] initWithImage:[self getImageFromView:self.statusBarView atFrame:self.statusBarView.bounds]];
        UIView *statusBarView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
        [self.statusBarCloneView addSubview:statusBarView];
        
        _isShowing = YES;
        _dissmissed = NO;
        
        self.label.top = -_label.height;
        self.statusBarCloneView.top = 0;
        
        if (![self.contentView isDescendantOfView:self.statusBarView]) {
            [self.statusBarView addSubview:self.contentView];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.label.top = 0;
            self.statusBarCloneView.top = _label.height;
            
        } completion:^(BOOL finished) {
            
            _isShowing = NO;
            double delayInSeconds = [self.label scrollTime] + 1.0;

            perform_block_after_delay(delayInSeconds, ^{
                [self startCheckMessageTimer];
            });
            
        }];
    }
}

- (void)startCheckMessageTimer
{
    if (_checkTimer) {
        [_checkTimer invalidate];
        _checkTimer = nil;
    }

    WS(weakSelf)
    self.checkTimer = [NSTimer timerWithTimeInterval:0.5 block:^(NSTimer * _Nonnull timer){
        [weakSelf dequeueMassage];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.checkTimer forMode:NSRunLoopCommonModes];
    [self.checkTimer fire];
}

- (void)dequeueMassage
{
    LVHUDMassage *massage = self.statusBarQueue.firstObject;

    if (massage) {
        self.label.text = massage.massage;
        [self.statusBarQueue removeObject:massage];
    }
    
    if (self.statusBarQueue.count == 0 && !_beginDissmiss) {
        if (_checkTimer) {
            [_checkTimer invalidate];
            _checkTimer = nil;
        }
        
        perform_block_after_delay(1.0, ^{
            [self dissmissHUDWithMassage:massage];
        });
    }
}

- (void)dissmissHUDWithMassage:(LVHUDMassage *)msg
{
    _beginDissmiss = YES;
    
    UIView *statusBarView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];

    if (statusBarView) {
        [self.statusBarCloneView addSubview:statusBarView];
    }
    
    [self.statusBarCloneView addSubview:self.statusBarImageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.label.top = -self.label.height;
        self.statusBarCloneView.top = 0;
        
    } completion:^(BOOL finished) {
        
        self.label.top = 0;
        self.label.text = @"";
        self.statusBarCloneView.top = -self.label.height;
        [self.contentView removeFromSuperview];
        _dissmissed = YES;
        _beginDissmiss = NO;

        [self dequeueMassage:msg loopShow:NO];
        
    }];
}

- (UIImage *)getImageFromView:(UIView *)theView atFrame:(CGRect)frame
{
    NSParameterAssert(theView);
    
    UIGraphicsBeginImageContextWithOptions(theView.size, NO, [UIScreen mainScreen].scale);
    [theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)dequeueMassage:(LVHUDMassage *)msg loopShow:(BOOL)loopShow
{
    switch (msg.style) {
        case LVHUDStyleStatusBar: {
            [self.statusBarQueue removeObject:msg];
            break;
        }
        case LVHUDStyleNavgationBar: {
            [self.navBarmassageQueue removeObject:msg];
            break;
        }
    }
    
    if(loopShow){
        if (self.statusBarQueue.count > 0) {
            [self showStatusBarHUDWithMassage:self.statusBarQueue.firstObject];
        }else if (self.navBarmassageQueue.count > 0) {
            [self showNavBarHUDWithMassage:self.statusBarQueue.firstObject];
        }
    }
}

#pragma mark - Getter

- (LVScrollLabel *)label
{
    if (!_label) {
        LVScrollLabel *label = [[LVScrollLabel alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:1.0];
        label.width = kDeviceWidth;
        label.top = -LSYStatusHeight;
        _label = label;
        
        [self.contentView addSubview:_label];
        [self.contentView bringSubviewToFront:_label];
    }
    
    return _label;
}

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        _statusBarView = [[UIApplication sharedApplication] valueForKey:@"statusBar"];

    }
    return _statusBarView;
}

- (UIView *)statusBarCloneView
{
    if (!_statusBarCloneView) {

        _statusBarCloneView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        [_statusBarCloneView setClipsToBounds:YES];
    
        [self.contentView addSubview:_statusBarCloneView];
        [self.contentView sendSubviewToBack:_statusBarCloneView];
    }
    
    return _statusBarCloneView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        _contentView.clipsToBounds = YES;
        [self.statusBarView addSubview:_contentView];
    }
    
    return _contentView;
}

@end

#pragma mark - LVScrollLabel

@implementation LVScrollLabel
{
    UIImageView *textImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textImage = [[UIImageView alloc] init];
        [self addSubview:textImage];
    }
    return self;
}

- (CGFloat)fullWidth
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}].width;
}

- (CGFloat)scrollOffset
{
    if (self.numberOfLines != 1) return 0;
    
    CGRect insetRect = CGRectInset(self.bounds, PADDING, 0);
    return MAX(0, [self fullWidth] - insetRect.size.width);
}

- (CGFloat)scrollTime
{
    return ([self scrollOffset] > 0) ? [self scrollOffset] / SCROLL_SPEED + SCROLL_DELAY : 0;
}

- (void)setText:(NSString *)text
{
    textImage.transform = CGAffineTransformIdentity;
    [super setText:text];
}

- (void)drawTextInRect:(CGRect)rect
{
    if ([self scrollOffset] > 0) {
        rect.size.width = [self fullWidth] + PADDING * 2;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        [super drawTextInRect:rect];
        textImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [textImage sizeToFit];
        [self bringSubviewToFront:textImage];
        [UIView animateWithDuration:[self scrollTime] - SCROLL_DELAY
                              delay:SCROLL_DELAY
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             textImage.transform = CGAffineTransformMakeTranslation(-[self scrollOffset], 0);
                         } completion:^(BOOL finished) {
                         }];
    } else {
        textImage.image = nil;
        [super drawTextInRect:CGRectInset(rect, PADDING, 0)];
    }
}

@end


