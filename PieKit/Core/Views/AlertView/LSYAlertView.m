//
//  LSYAlertView.m
//  ViewTest
//
//  Created by RoyLei on 14-6-30.
//  Copyright (c) 2014年 RoyLei. All rights reserved.
//

#import "LSYAlertView.h"
#import "FTCoreTextView.h"
#import "CAAnimation+Blocks.h"
#import "FTCoreTextViewStyleDefine.h"
#import "LKMacros.h"

NSInteger const LSY_ALERTTITLE_WINDOW_TAG  = 65123;

#define kLSYAlertViewDegreesToRadians(degrees) (degrees * M_PI / 180)

const static CGFloat kLSYAlertViewContinerWidth             = 270.0f;
const static CGFloat kLSYAlertViewContinerHight             = 116.0f;
const static CGFloat kLSYAlertViewTitleHight                = 44.0f;
const static CGFloat kLSYAlertViewDefaultButtonHeight       = 44.0f;
const static CGFloat kLSYAlertViewMaxHeight                 = 290.0f;

const static CGFloat kLSYAlertViewDefaultButtonSpacerHeight = 1.0f;
const static CGFloat kLSYAlertViewCornerRadius              = 5.0f;
const static CGFloat kLSYAlertViewMotionEffectExtent        = 10.0f;
const static CGFloat kLSYAlertViewRLTextMargin              = 20.0f;
const static CGFloat kLSYAlertViewUpDownTextMargin          = 12.0f;

@interface LSYAlertButton()
{
    FTCoreTextView *_titleView;
}

@property (nonatomic,weak  ) id  target;
@property (nonatomic,assign) SEL action;
@end

@implementation LSYAlertButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (nil != self) {
        
        self.exclusiveTouch = YES;
        
        _interval          = 0.01;
        _highlightInterval = 0.01;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setUserInteractionEnabled:NO];
        
		_titleView = [[FTCoreTextView alloc] initWithFrame:self.bounds];
        [_titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_titleView setText:text];
        
        [_titleView addStyles:createCoreTextNormalStyle()];
        [_titleView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
		[_titleView setBackgroundColor:[UIColor clearColor]];
        [_titleView setUserInteractionEnabled:NO];
        [_titleView fitToSuggestedHeight];
        [_titleView setCenter:(CGPoint){(int)(self.frame.size.width/2), (int)(self.frame.size.height/2)}];
        
        _disableLayer = [CALayer layer];
        [_disableLayer setBackgroundColor:[UIColor colorWithRed:215/255.0f green:215/255.0f blue:230/255.0f alpha:1.0f].CGColor];
        [_disableLayer setOpacity:0.4f];
        [_disableLayer setFrame:self.layer.bounds];
        [_disableLayer setHidden:YES];
        
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchCancel];
		[self addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
		[self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:_imageView];
        [self addSubview:_titleView];
        [self.layer addSublayer:_disableLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_disableLayer setFrame:self.layer.bounds];
    [_titleView fitToSuggestedHeight];
    [_titleView setCenter:(CGPoint){(int)(self.frame.size.width/2), (int)(self.frame.size.height/2)}];
    [_titleView setFrame:CGRectIntegral(_titleView.frame)];
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        self.alpha = 1.0;
    }else{
        self.alpha = 0.7;
    }
    [_disableLayer setHidden:enabled];
    [super setEnabled:enabled];
}

- (void)addTarget:(id)target action:(SEL)action
{
	_target = target;
	_action = action;
}

- (void)setNormalImage:(UIImage*)image
{
	[_imageView setImage:image];
}

- (void)setHighlightImage:(UIImage*)image
{
	[_imageView setHighlightedImage:image];
}

- (void)touchUpInside
{
	if(_highlightInterval<=0.0f)
		[self performSelector:@selector(imageViewNoHiglight) withObject:nil];
	else
		[self performSelector:@selector(imageViewNoHiglight)
                   withObject:nil
                   afterDelay:_highlightInterval
                      inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	
	if(_interval<=0.0f)
        [_target performSelector:_action
                      withObject:self
                      afterDelay:0.0f
                         inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	else
		[_target performSelector:_action
                      withObject:self
                      afterDelay:_interval
                         inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (void)touchDown
{
	if([self isHighlighted]){
        [_titleView addStyles:createCoreTextHighlightStyle()];
    }else{
        [_titleView addStyles:createCoreTextNormalStyle()];
    }
	[_imageView setHighlighted:YES];
}

- (void)touchUpOutside
{
	if(_highlightInterval<=0.0f)
		[self performSelector:@selector(imageViewNoHiglight) withObject:nil];
	else
		[self performSelector:@selector(imageViewNoHiglight) withObject:nil
                   afterDelay:_highlightInterval
                      inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    //0.1秒的延迟生效
    [super setEnabled:NO];
    [self performSelector:@selector(layEnabled)
               withObject:nil
               afterDelay:0.1f
                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (void)layEnabled
{
    [super setEnabled:YES];
}

- (void)imageViewNoHiglight
{
	[_imageView setHighlighted:NO];
    [_titleView addStyles:createCoreTextNormalStyle()];
}

@end

#pragma mark - LSYAlertView
//LSYAlertView Queue
static NSMutableArray *alertViewQueue = nil;

@interface LSYAlertView()<FTCoreTextViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray   *_buttons;
}
@property (nonatomic, strong) UITapGestureRecognizer *tapGetsure;
@property (nonatomic, strong) UIWindow   *window;
@property (nonatomic, strong) NSString   *title;
@property (nonatomic, strong) NSString   *massage;
@property (nonatomic, assign) NSUInteger curIndex;
@property (nonatomic, assign) BOOL       isRecovering;
@property (nonatomic, assign) BOOL       isShowing;
@property (nonatomic, assign) BOOL       isDlayShow;
@end

@implementation LSYAlertView

+ (id)setupWithTitle:(NSString*)title massage:(NSString *)msg buttonTitles:(NSArray *)butnTitles
{
    LSYAlertView *alertView = [[LSYAlertView alloc] init];
    [alertView setupWithTitle:title massage:msg buttonTitles:butnTitles];
    return alertView;
}

- (void)setupWithTitle:(NSString*)title massage:(NSString *)msg buttonTitles:(NSArray *)butnTitles
{
    [self creatContainerViewWithTitle:title massage:msg];
    [self setButtonTitles:butnTitles];
    [self setUseMotionEffects:true];
    [self show];
}

/**
 *  生成指定range为蓝色style的string
 *
 *  @param oriString 原始string
 *  @param range     需要转换成蓝色style的range
 *
 *  @return 包含蓝色style的
 */
+ (NSString *)blueColorStyleString:(NSString *)oriString blueRange:(NSRange)range{
    if (oriString.length > range.location + range.length) {
        NSLog(@"range 超过边界");
        return oriString;
    }
    NSMutableString *resultStr = [NSMutableString stringWithString:oriString];
    [resultStr insertString:@"</a>" atIndex:range.location + range.length];
    [resultStr insertString:@"<a>|" atIndex:range.location];
    return resultStr;
}

/**
 *  生成指定range为红色style的string
 *
 *  @param oriString 原始string
 *  @param range     需要转换成蓝色style的range
 *
 *  @return 包含蓝色style的
 */
+ (NSString *)redColorStyleString:(NSString *)oriString redRanges:(NSArray *)ranges
{
    NSMutableString *resultStr = [NSMutableString stringWithString:oriString];
    for (NSString * rangStr in ranges) {
        NSRange range = NSRangeFromString(rangStr);
        [resultStr insertString:@"</a>" atIndex:range.location + range.length];
        [resultStr insertString:@"<a>|" atIndex:range.location];
    }
    return resultStr;
}

- (id)init
{
    self = [super init];
    if (nil != self) {

        _useMotionEffects = NO;
        _isRecovering     = NO;
        _isShowing        = NO;
        _buttonHeight       = kLSYAlertViewDefaultButtonHeight;
        _buttonSpacerHeight = kLSYAlertViewDefaultButtonSpacerHeight;
        _buttonTitles     = @[@"Done"];
        _buttons          = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformAlertViewForOrientation)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didMoveToSuperview
{
    [self transformAlertViewForOrientation];
}

//添加LSYAlertView到全局队列中方法
- (void)handleQueue
{
    //非TRLAlerView的恢复模式时添加Alert到队列
    if (!_isRecovering) {
        
        if (nil == alertViewQueue) {
            alertViewQueue = [[NSMutableArray alloc] init];
        }
        
        if (nil != alertViewQueue && alertViewQueue.count) {
            
            LSYAlertView *alertView = [alertViewQueue lastObject];
            self.window = alertView.window;
            _isDlayShow = alertView.isShowing;
        }
        
        if (![alertViewQueue containsObject:self]) {
            [alertViewQueue addObject:self];
        }
        
    }else{
        _isDlayShow = NO;
    }
}

- (void)show
{
    [self handleQueue];
    
    if (_isDlayShow) {
        self.isShowing = YES;
    }else{
        [self showFromQueue];
    }
}

// Create the dialog view, and animate opening the dialog
- (void)showFromQueue
{
    _isShowing = YES;

    _curIndex  = [alertViewQueue indexOfObject:self];

    //隐藏上一个LSYAlertView
    if (nil != alertViewQueue && alertViewQueue.count - 1 >= _curIndex - 1 ) {
        LSYAlertView *alertView = [alertViewQueue objectAtIndex:_curIndex - 1];
        [alertView sendAlertViewToBack];
    }
    
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    if (!_dialogView) {
        _dialogView = [self createDialogView];
//        [_dialogView setBackgroundColor:[UIColor whiteColor]];
//        [_dialogView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
//                                          UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:_dialogView.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView setImage:kLSYAlertViewBackgroundImage];
        [_dialogView insertSubview:bgView belowSubview:_containerView];
    }
    
    [self addButtonsToView:_dialogView];
    
    _dialogView.layer.shouldRasterize    = YES;
    _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize           = YES;
    self.layer.rasterizationScale        = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (_useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
//    _dialogView.layer.opacity = 0.5f;
//    [self addSubview:_dialogView];
    
    if (nil == _window) {
        self.window = [[UIWindow alloc] initWithFrame:self.bounds];
        self.window.windowLevel = UIWindowLevelAlert;
        self.window.tag = LSY_ALERTTITLE_WINDOW_TAG;
    }
    
    [self.window addSubview:self];
    [self.window addSubview:_dialogView];
    [self.window setHidden:NO];
    [self.window makeKeyAndVisible];
    
    [self transformAlertViewForOrientation];

    [_buttons enumerateObjectsUsingBlock:^(LSYAlertButton *alertButton, NSUInteger idx, BOOL *stop) {
        [alertButton setEnabled:NO];
        [alertButton setAlpha:1.0];
        [alertButton.disableLayer setHidden:YES];
    }];
    
    // Completion block
    WS(weakSelf)
    __weak NSArray *wButtons = _buttons;
	void (^completion)(BOOL finished) = ^(BOOL finished) {
        
        weakSelf.isShowing = NO;
        [wButtons enumerateObjectsUsingBlock:^(LSYAlertButton *alertButton, NSUInteger idx, BOOL *stop) {
            [alertButton setEnabled:YES];
        }];
    
        int maxIndex  = (int)alertViewQueue.count - 1;
        if (maxIndex > 0 && maxIndex > weakSelf.curIndex ) {
            LSYAlertView *alertView = [alertViewQueue objectAtIndex:weakSelf.curIndex + 1];
            alertView.window = weakSelf.window;
            [alertView showFromQueue];
        }
	};
    
    [self showAlertViewHaveAnimation:completion];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    if (!_isShowing) {
        
        _isShowing = YES;
        
        //关闭窗口时，将自身从全局队列中移除
        [alertViewQueue removeObject:self];
        
        //获取队列中最近要显示的LSYAlertView
        LSYAlertView *willDisplayAlert         = [alertViewQueue lastObject];

        CATransform3D currentTransform         = _dialogView.layer.transform;
        _dialogView.layer.transform            = CATransform3DConcat(currentTransform, CATransform3DMakeScale(1, 1, 1));
        _dialogView.layer.opacity              = 1.0f;

        __weak LSYAlertView *bSelf             = self;
        __weak LSYAlertView *bWillDisplayAlert = willDisplayAlert;
        
        // Completion block
        void (^completion)(BOOL finished)      = ^(BOOL finished){
            
            [self removeFromSuperview];
            
            // Release window from memory
            if (alertViewQueue.count == 0) {
                bSelf.window.hidden     = YES;
                if (bSelf.window.windowLevel == UIWindowLevelAlert) {
                    bSelf.window.windowLevel = UIWindowLevelNormal;
                }
                [bSelf.window resignKeyWindow];
                bSelf.window            = nil;
            }

            bWillDisplayAlert.isShowing = NO;
        };
        
        [self hideAlertViewHaveAnimation:completion];
        
        //显示队列最后一个AlertView
        if (nil != alertViewQueue && alertViewQueue.count) {
            willDisplayAlert.isShowing    = YES;
            willDisplayAlert.isRecovering = YES;
            [willDisplayAlert setupWithTitle:willDisplayAlert.title
                                     massage:willDisplayAlert.massage
                                buttonTitles:willDisplayAlert.buttonTitles];
        }
    }
}

#pragma mark - UITapGestureRecognizer 

- (void)setTapToDissmiss:(BOOL)tapToDissmiss
{
    _tapToDissmiss = tapToDissmiss;
    
    if (_tapToDissmiss) {
        
        if (![self.gestureRecognizers containsObject:self.tapGetsure]) {
            [self addGestureRecognizer:self.tapGetsure];
        }
        [self setUserInteractionEnabled:YES];
        [self.tapGetsure setEnabled:YES];
        
    }else {
        
        if (_tapGetsure) {
            [_tapGetsure setEnabled:NO];
        }
    }
}

- (UITapGestureRecognizer *)tapGetsure
{
    if (!_tapGetsure) {
        _tapGetsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetsureHandle:)];
        [_tapGetsure setDelegate:self];
    }
    
    return _tapGetsure;
}

- (void)tapGetsureHandle:(id)sender
{
    if (!self.isShowing) {
        [self close];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (CGRectContainsPoint(self.dialogView.frame, location) ||
        gestureRecognizer.view == self.dialogView ||
        [gestureRecognizer.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Hide Last AlertView Method
- (void)sendAlertViewToBack
{
    CATransform3D currentTransform = _dialogView.layer.transform;
    
    _dialogView.layer.transform    = CATransform3DConcat(currentTransform, CATransform3DMakeScale(1, 1, 1));
    _dialogView.layer.opacity      = 1.0f;
    
    __weak LSYAlertView *bSelf     = self;
    __block __weak UIView *weakDialogView  = _dialogView;

    // Completion block
	void (^completion)(BOOL finished) = ^(BOOL finished){
        
        [bSelf removeFromSuperview];
        
        //隐藏后移除容器View, 释放内存
        bSelf.containerView = nil;
        weakDialogView      = nil;
        
	};
    
    [self hideAlertViewHaveAnimation:completion];
    
}

#pragma mark -
#pragma mark Show|Hide Animation
- (void)showAlertViewHaveAnimation:(void (^)(BOOL))completion
{
    CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
    CATransform3D transformTo   = CATransform3DMakeScale(1.0, 1.0, 1.0);
    
    _dialogView.layer.opacity   = 0.0;
    _dialogView.layer.transform = transformFrom;
    if (!_isRecovering && alertViewQueue.count == 1) {
        _window.layer.opacity = 0.0;
    }
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dialogView.layer.opacity   = 1.0;
                         _dialogView.layer.transform = transformTo;
                         if (!_isRecovering && alertViewQueue.count == 1) {
                             _window.layer.opacity   = 1.0;
                             _window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         }
                     }
                     completion:completion];
}

- (void)hideAlertViewHaveAnimation:(void (^)(BOOL))completion
{
    CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D transformTo   = CATransform3DMakeScale(0.840, 0.840, 1.0);
    
    _dialogView.layer.transform = transformFrom;
    
    if (alertViewQueue.count == 0) {
        _window.layer.opacity = 1.0f;
    }
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dialogView.layer.opacity   = 0.0;
                         _dialogView.layer.transform = transformTo;
                         if (alertViewQueue.count == 0) {
                             _window.layer.opacity = 0.0f;
                         }
                     }
                     completion:completion];
}

#pragma mark -
#pragma mark Setup AlertView Component Method
- (void)creatContainerViewWithTitle:(NSString *)title massage:(NSString *)msg
{
    [self setTitle:title];
    [self setMassage:msg];
    
    FTCoreTextView *titleView = nil;
    FTCoreTextView *msgView   = nil;
    
    if (nil == _containerView) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLSYAlertViewContinerWidth, kLSYAlertViewContinerHight)];
        [_containerView setBackgroundColor:[UIColor clearColor]];
        
        titleView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
        [titleView setFrame:(CGRect){0,0,kLSYAlertViewContinerWidth - (kLSYAlertViewRLTextMargin*2), kLSYAlertViewTitleHight}];
        [titleView setDelegate:self];
        [titleView addStyles:createCoreTextNormalStyle()];
        [titleView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
        [titleView setText:title];
        [titleView fitToSuggestedHeight];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setCenter:(CGPoint){(int)(kLSYAlertViewContinerWidth/2),(int)(kLSYAlertViewTitleHight/2)}];
        
        msgView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
        [msgView setFrame:(CGRect){kLSYAlertViewRLTextMargin,kLSYAlertViewTitleHight,kLSYAlertViewContinerWidth -(kLSYAlertViewRLTextMargin*2), CGFLOAT_MAX}];
        [msgView setBackgroundColor:[UIColor clearColor]];
        [msgView setDelegate:self];
        [msgView addStyles:createCoreTextNormalStyle()];
        [msgView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
        [msgView setText:msg];
        [msgView fitToSuggestedHeight];

    }

    
    CGSize msgSize     = msgView.frame.size;
    msgSize.width      = (int)msgSize.width;
    msgSize.height     = (int)msgSize.height + kLSYAlertViewUpDownTextMargin;

    CGRect fullRect    = _containerView.frame;
    fullRect.size.height = msgSize.height + kLSYAlertViewTitleHight + kLSYAlertViewUpDownTextMargin - 5;

    CGRect msgRect     = (CGRect){0,0,kLSYAlertViewContinerWidth-kLSYAlertViewRLTextMargin*2,msgSize.height};
    msgRect.origin     = (CGPoint){kLSYAlertViewRLTextMargin, CGRectGetMaxY(titleView.frame)+kLSYAlertViewUpDownTextMargin};
    msgView.frame      = msgRect;

    //超过300.0f，使用Scrollview
    if(fullRect.size.height > kLSYAlertViewMaxHeight - _buttonHeight)
    {
        fullRect.size.height   = kLSYAlertViewMaxHeight - _buttonHeight;

        CGRect scrollRect      = (CGRect){0,0,kLSYAlertViewContinerWidth,kLSYAlertViewMaxHeight-_buttonHeight+2};
        UIScrollView *scroll   = [[UIScrollView alloc] initWithFrame:scrollRect];
        scroll.backgroundColor = [UIColor clearColor];

        [scroll addSubview:titleView];
        [scroll addSubview:msgView];
        [scroll setContentSize:(CGSize){msgSize.width, CGRectGetMaxY(titleView.frame)+msgSize.height+kLSYAlertViewUpDownTextMargin*2}];
        [_containerView addSubview:scroll];
        
    }else
    {
        fullRect.size.height = msgSize.height + kLSYAlertViewTitleHight + kLSYAlertViewUpDownTextMargin - 5;
        titleView.center     = (CGPoint){(int)_containerView.frame.size.width/2+2, (int)titleView.center.y};
        msgView.center       = (CGPoint){(int)_containerView.frame.size.width/2+2, (int)msgView.center.y};
        msgView.frame        = CGRectIntegral(msgView.frame);
        
        [_containerView addSubview:titleView];
        [_containerView addSubview:msgView];
    }
    
    _containerView.frame = fullRect;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createDialogView
{
    if (_containerView == NULL) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLSYAlertViewContinerWidth, kLSYAlertViewContinerHight)];
    }
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    CGPoint origin    = (CGPoint){(int)((screenSize.width - dialogSize.width)/2), (int)((screenSize.height - dialogSize.height)/2)};

    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    UIView *dialogContainer = [[UIView alloc] initWithFrame:(CGRect){origin, dialogSize}];
    dialogContainer.layer.cornerRadius = kLSYAlertViewCornerRadius;
    dialogContainer.clipsToBounds      = YES;
    
    [dialogContainer addSubview:_containerView];
    
    return dialogContainer;
}

- (void)addButtonsToView:(UIView *)container
{
    if (_buttonTitles == NULL || _buttons == NULL) { return; }
    if (_isRecovering && _buttons.count) {
        for (LSYAlertButton *alertButton in _buttons) {
            [container addSubview:alertButton];
        }
        return;
    }
    
    CGFloat buttonWidth = ceilf(container.bounds.size.width / [_buttonTitles count]);
    
    for (int i = 0; i< [_buttonTitles count]; i++) {
        
        LSYAlertButton *alertButton = [[LSYAlertButton alloc] initWithFrame:CGRectZero title:[_buttonTitles objectAtIndex:i]];
        [alertButton setTag:i];
        [alertButton.layer setCornerRadius:kLSYAlertViewCornerRadius];
        [alertButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - _buttonHeight, buttonWidth, _buttonHeight)];
        [alertButton addTarget:self action:@selector(dialogButtonTouchUpInside:)];
        
        UIImage *normalImage    = nil;
        UIImage *highLightImage = nil;
        
        if (1 == [_buttonTitles count]) {
            normalImage    = kLSYAlertViewOneButtonImage_Normal;
            highLightImage = kLSYAlertViewOneButtonImage_Highlight;
        }
        else
        {
            if(i == 0) {
                normalImage    = kLSYAlertViewLeftButtonImage_Normal;
                highLightImage = kLSYAlertViewLeftButtonImage_Highlight;
                
            }else if ([_buttonTitles count] - 1 == i){

                normalImage    = kLSYAlertViewRightButtonImage_Normal;
                highLightImage = kLSYAlertViewRightButtonImage_Highlight;
                
            }else{
                normalImage    = kLSYAlertViewMidButtonImage_Normal;
                highLightImage = kLSYAlertViewMidButtonImage_Highlight;
            }
        }
        
        [alertButton setNormalImage:normalImage];
        [alertButton setHighlightImage:highLightImage];
        
        [_buttons addObject:alertButton];
        [container addSubview:alertButton];
    }
}

#pragma mark -
#pragma mark Alert Button Action ExcutableBlock Method
- (void)dialogButtonTouchUpInside:(id)sender
{
    //按钮事件在View动画执行完成之后才会执行，同时有新AlertView在后续添加时不执行按钮事件。
    int lastIndex = alertViewQueue.count ? ((int)alertViewQueue.count - 1) : -1;
    if (!_isShowing && _curIndex == lastIndex) {
        
        LSYAlertButton *butn = sender;
        if (butn.isPressed) {
            return;
        }
        
        [self close];
        __weak LSYAlertView *wSelf = self;
        if (_onButtonTouchUpInside != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                    _onButtonTouchUpInside(wSelf, [sender tag]);
            });
        }
        
    }
}

#pragma mark -
#pragma mark Count Size Method
// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = _containerView.frame.size.width;
    CGFloat dialogHeight = _containerView.frame.size.height + _buttonHeight + _buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (_buttonTitles != NULL && [_buttonTitles count] > 0) {
        
    } else {
        _buttonHeight = 0;
        _buttonSpacerHeight = 0;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            return screenSize;
        }else{
            return  CGSizeMake(screenSize.height, screenSize.width);

        }

    }else{
        return screenSize;

    }
}

#pragma mark -
#pragma mark IOS7 Add Motion Effects Method
#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kLSYAlertViewMotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kLSYAlertViewMotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kLSYAlertViewMotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kLSYAlertViewMotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [_dialogView addMotionEffect:motionEffectGroup];
}
#endif

#pragma mark -
#pragma mark Handle Orientation Method
- (void)transformAlertViewForOrientation{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform transform;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            transform = CGAffineTransformMakeRotation(-kLSYAlertViewDegreesToRadians(90));
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            transform = CGAffineTransformMakeRotation(kLSYAlertViewDegreesToRadians(90));
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            transform = CGAffineTransformMakeRotation(kLSYAlertViewDegreesToRadians(180));
        }
            break;
        case UIInterfaceOrientationPortrait:
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    [self setTransform:transform];
    _window.transform = transform;
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    if (screenSize.height > screenSize.width) {
        [_window setFrame:(CGRect){0,0,screenSize}];
    }
    else {
        [_window setFrame:(CGRect){0,0,screenSize.height, screenSize.width}];
    }
    
    [self setFrame:(CGRect){0,0,screenSize}];
    
    CGFloat screenW = screenSize.width;
    CGFloat screenH = screenSize.height;
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]<8 &&
        UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat tmp = screenW;
        screenW = screenH;
        screenH = tmp;
    }
    
    CGPoint origin = (CGPoint){(int)((screenW - dialogSize.width)/2), (int)((screenH - dialogSize.height)/2)};
    
    [_dialogView setFrame:(CGRect){origin, dialogSize}];
}

#pragma mark -
#pragma mark FTCoreTextViewDelegate Method

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    //  You can get detailed info about the touched links
    //  URL if the touched data was link
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    
#ifdef DEBUG
    //  Name (type) of selected tag
    NSString *tagName = [data objectForKey:FTCoreTextDataName];
    
    //  Frame of the touched element
    //  Notice that frame is returned as a string returned by NSStringFromCGRect function
    CGRect touchedFrame = CGRectFromString([data objectForKey:FTCoreTextDataFrame]);
    
    //  You can get detailed CoreText information
    NSDictionary *coreTextAttributes = [data objectForKey:FTCoreTextDataAttributes];
    
    NSLog(@"Received touched on element:\n"
          @"Tag name: %@\n"
          @"URL: %@\n"
          @"Frame: %@\n"
          @"CoreText attributes: %@",
          tagName, url, NSStringFromCGRect(touchedFrame), coreTextAttributes
          );
#endif
    
    if ([_delegate respondsToSelector:@selector(LSYAlertViewUserTouch:link:)]) {
        [_delegate LSYAlertViewUserTouch:self link:url];
    }
}

#pragma mark -
#pragma mark  Handle keyboard show/hide Method
// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}


@end
