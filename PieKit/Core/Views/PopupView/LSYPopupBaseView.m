//
//  LSYPopupBaseView.m
//  13Helper
//
//  Created by TTClub RoyLei on 14/12/3.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import "LSYPopupBaseView.h"
#import "LSYShowAnimation.h"
#import "UIView+YYAdd.h"

@interface LSYPopupBaseView()<UIGestureRecognizerDelegate>
{
    
}
@property (nonatomic, readwrite) UIView     *topView;

@end

@implementation LSYPopupBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        self.alpha           = 0.0f;
        
        _isDisappeared       = YES;
        [self setUseBlurEffect:YES];
        
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        [_singleTap setDelegate:self];
        [self addGestureRecognizer:_singleTap];
    }
    
    return self;
}

- (void)setUseBlurEffect:(BOOL)useBlurEffect
{
    _useBlurEffect = useBlurEffect;
    
    [self.containerView removeFromSuperview];
    
    if (useBlurEffect) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.containerView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }else{
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    [self.containerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    [_topView addSubview:_containerView];
}

- (void)showPopupViewWithAnimation:(LSYPopupAnimationType)animationType
{
    if (!_isShowing) {
        
        _isShowing   = YES;
        [self showViewWithAnimation:animationType];
    }
}

- (void)showViewWithAnimation:(LSYPopupAnimationType)animationType
{
    self.animationType = animationType;
    _isAnimating = YES;
    _isDisappeared = NO;

    [_topView setUserInteractionEnabled:YES];
//    _topView = [[UIApplication sharedApplication] keyWindow];
    _topView = [UIApplication sharedApplication].delegate.window;
    
    if ([self isDescendantOfView:_topView]) {
        [_topView bringSubviewToFront:self];
        [_topView bringSubviewToFront:_containerView];
    }else{
        [self setFrame:_topView.bounds];
        [_topView addSubview:self];
        [_topView addSubview:_containerView];
    }
    
    switch (animationType) {
        case LSYPopupAnimationType_None:
        {
            self.alpha = 1.0f;
            _isAnimating = NO;
        }
            break;
        case LSYPopupAnimationType_Middle:
        {
            [_containerView setCenter:self.center];
            self.alpha = 0.0f;
            _containerView.layer.transform = CATransform3DIdentity;
            [LSYShowAnimation showViewWithAnimation:_containerView
                                    backgroundView:self
                                        completion:^(BOOL finished) {
                                            _isAnimating = NO;
                                            
                                            if (_useBlurEffect) {
                                                [UIView animateWithDuration:0.1 animations:^{
                                                    [_containerView setBackgroundColor:[UIColor clearColor]];
                                                }];
                                            }
                                        }];
        }
            break;
        case LSYPopupAnimationType_Bottom:
        {
            [_containerView setTop:self.height];
            [LSYShowAnimation popupView:_containerView
                        backgroundView:self
                          fromPosition:self.height + _containerView.height/2
                            toPosition:self.height - _containerView.height/2
                              isBounce:NO
                            completion:^(BOOL finished) {
                                
                                _isAnimating = NO;

                                [_containerView setTop:self.height-_containerView.height];
                                [self setUserInteractionEnabled:YES];
                                [_containerView setUserInteractionEnabled:YES];
                                
                                if (_useBlurEffect) {
                                    [_containerView setBackgroundColor:[UIColor clearColor]];
                                }
                            }];
        }
            break;
        default:
            break;
    }
}

- (void)disappear
{
    if (_isShowing){
        [self disappearIsRemove:YES withCompleteBlock:nil withIsDelay:_isAnimating];
    }
}

- (void)disappearWithCompleteBlock:(void (^)(void))complete
{
    if (_isShowing){
        [self disappearIsRemove:YES withCompleteBlock:complete withIsDelay:_isAnimating];
    }else if(complete){
        complete();
    }
}

- (void)disappearNoRemoveFromSuperView
{
    if (_isShowing){
        
        [self disappearIsRemove:NO withCompleteBlock:nil withIsDelay:_isAnimating];
    }
}

- (void)disappearNoRemoveWithCompleteBlock:(void (^)(void))complete
{
    if (_isShowing){
        
        [self disappearIsRemove:NO withCompleteBlock:complete withIsDelay:_isAnimating];
        
    }else if(complete){
        
        NSTimeInterval delay = 0.0f;
        if (_isAnimating || !_isDisappeared) {
            delay = 0.5f;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete();
        });
    }
}

- (void)disappearIsRemove:(BOOL)isRemove withCompleteBlock:(void (^)(void))complete withIsDelay:(BOOL)isDelay
{
    if (isDelay) {
        _isShowing = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disappearIsRemove:isRemove withCompleteBlock:complete];
        });
    }else{
        [self disappearIsRemove:isRemove withCompleteBlock:complete];
    }
}

- (void)disappearIsRemove:(BOOL)isRemove withCompleteBlock:(void (^)(void))complete
{
    _isShowing = NO;
    _isAnimating = YES;

    switch (self.animationType) {
        case LSYPopupAnimationType_None:
        {
            if (self.disappearBlock) {
                self.disappearBlock(self);
            }
            if (complete) {
                complete();
            }
            
            _isAnimating = NO;
            _isDisappeared = YES;

            if (isRemove) {
                [self removeFromSuperview];
            }
        }
            break;
        case LSYPopupAnimationType_Middle:
        {
            if (self.disappearBlock) {
                self.disappearBlock(self);
            }
            
            if(_useBlurEffect){
                [_containerView setBackgroundColor:[UIColor whiteColor]];
            }
            
            [LSYShowAnimation hideViewWithAnimation:_containerView
                                    backgroundView:self
                                        completion:^(BOOL finished) {
                                            
                                            _isAnimating = NO;
                                            _isDisappeared = YES;
                                            
                                            if (complete) {
                                                complete();
                                            }
                                            
                                            if (isRemove) {
                                                [_containerView removeFromSuperview];
                                                [self removeFromSuperview];
                                            }else{
                                                [self setTransform:CGAffineTransformIdentity];
                                                [self setNeedsLayout];
                                            }
                                            
                                        }];
        }
            break;
        case LSYPopupAnimationType_Bottom:
        {
            if (self.disappearBlock) {
                self.disappearBlock(self);
            }
            
            if(_useBlurEffect){
                [_containerView setBackgroundColor:[UIColor whiteColor]];
            }
            [LSYShowAnimation disapearPopupView:_containerView
                                backgroundView:self
                                  fromPosition:_containerView.center.y
                                    toPosition:self.height+_containerView.height/2
                                    completion:^(BOOL finished) {
                                        
                                        _isAnimating = NO;
                                        _isDisappeared = YES;

                                        [_containerView setTop:self.height+_containerView.height];
                                        
                                        if (complete) {
                                            complete();
                                        }
                                        
                                        if (isRemove) {
                                            [_containerView removeFromSuperview];
                                            [self removeFromSuperview];
                                        }else{
                                            [self setTransform:CGAffineTransformIdentity];
                                            [self setNeedsLayout];
                                        }
                                        
                                    }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint position = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(_containerView.frame, position)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
