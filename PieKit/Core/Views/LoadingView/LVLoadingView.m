//
//  LVLoadingView.m
//  Live
//
//  Created by 熙文 张 on 16/3/29.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVLoadingView.h"
//#import "LVHourGlassView.h"
//#import "LVSpringIndicator.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"
#import "YYAnimatedImageView.h"
#import "LVLoadingAnimation.h"
#import "UIColor+YYAdd.h"
#import "LKSequenceAnimation.h"

#define kAnimationDuration 1.3f

@interface LVLoadingView()

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
//@property (strong, nonatomic) LKSequenceAnimation *loadingAnimation;
@property (strong, nonatomic) UIView              *animationView;

@end

@implementation LVLoadingView

+ (LVLoadingView *)findLoadingView:(UIView*)view
{
    LVLoadingView *hud = nil;
    for(UIView *v in view.subviews)
    {
        if ([v isKindOfClass:[LVLoadingView class]]) {
            hud = (LVLoadingView *)v;
            [hud setHidden:NO];
            break;
        }
    }
    
    return hud;
}

#pragma mark - 显示LoadingView

+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view frame:(CGRect)bounds coverHeader:(BOOL)coverHeader
{
    LVLoadingView *hud = [self findLoadingView:view];
    
    if (!hud) {
        UITableView *tableView = nil;
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
            tableView.scrollEnabled = NO;
        }
        
        if([tableView tableHeaderView] != nil && !coverHeader) {
            hud = [[LVLoadingView alloc] initWithFrame:CGRectMake(0,
                                                                  tableView.tableHeaderView.height - tableView.contentInset.top,
                                                                  view.width,
                                                                  view.height - tableView.tableHeaderView.height)];
        }
        else {
            hud = [[LVLoadingView alloc] initWithFrame:bounds];
        }
//        hud.frame = view.bounds;
        [view addSubview:hud];
        [view bringSubviewToFront:hud];
    }
    
    if([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView*)view;
        tmp.scrollEnabled = NO;
    }else {
        view.userInteractionEnabled = NO;
    }
    
    return hud;
}

+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view frame:(CGRect)bounds
{
    return [LVLoadingView showLoadingViewAddedTo:view frame:bounds coverHeader:YES];
}

+ (LVLoadingView *)showLoadingViewAddedTo:(UIView *)view
{
    return [self showLoadingViewAddedTo:view frame:view.bounds];
}

#pragma mark - 开始LoadingView动画

+ (void)startAnimationTo:(UIView* )view
{
    LVLoadingView *hud = [self findLoadingView:view];
    if (hud.isClearColor)
    {
        [hud setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [hud setBackgroundColor:UIColorWithHex(0xf5f5f5)];
    }
    [hud setStartTime:CFAbsoluteTimeGetCurrent()];
    
    if (hud) {
        [hud beginAnimated];
    }
}

#pragma mark - 隐藏LoadingView

+ (void)hideLoadingViewForView:(UIView *)view
{
    LVLoadingView *hud = [self findLoadingView:view];
    [hud setEndTime:CFAbsoluteTimeGetCurrent()];
    
    //确保加载动画展示100ms后消失
    NSTimeInterval interval = hud.endTime - hud.startTime;
    NSTimeInterval delayInterval = 0.0f;
    if (interval < 0.1) {
        delayInterval = 0.1 - interval;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (hud) {
            [hud stopAnimated];
        }
    });
    
    if([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView *)view;
        tmp.scrollEnabled = YES;
    }else {
        view.userInteractionEnabled = YES;
    }
}

+ (void)hideLoadingViewImmediatelyForView:(UIView *)view
{
    LVLoadingView *hud = [self findLoadingView:view];
    [hud setEndTime:CFAbsoluteTimeGetCurrent()];
    [hud stopAnimated];
    if([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView *)view;
        tmp.scrollEnabled = YES;
    }else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self)
    {
        self.backgroundColor = UIColorWithHex(0xf5f5f5);
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.frame = CGRectMake(0, 0, 50, 50);
        _activityIndicator.hidesWhenStopped = NO;
        _activityIndicator.color = UIColorWithHex(0x333333);
        [self addSubview:_activityIndicator];
        
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
//        _loadingAnimation = [[LKSequenceAnimation alloc] init];
//        _loadingAnimation.lineType = LKSequenceAnimationBig;
//        [_loadingAnimation initImageViewUI:self];
    }
    
    return self;
}

#pragma mark - Animation Control

- (void)beginAnimated
{
    _starting = YES;
//    [_loadingAnimation startAnimationHaveBeginAnimation];
    [_activityIndicator startAnimating];
}

- (void)stopAnimated
{
    _starting = NO;
    
    self.alpha = 0.0f;

    [_imageView stopAnimating];
//    [_loadingAnimation stopAnimation];
    [_activityIndicator stopAnimating];
    [self removeFromSuperview];
}

//暂停旋转动画
- (void)pauseRunning
{
    [_imageView stopAnimating];
}

//恢复旋转动画
-(void)resumeRunning
{
    [self beginAnimated];
}

@end
