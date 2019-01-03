//
//  LSYShowAnimation.m
//  13Helper
//
//  Created by TTClub RoyLei on 14/11/25.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import "LSYShowAnimation.h"

@implementation LSYShowAnimation

#pragma mark - Show View With Spring Gradual Animation
+ (void)showViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion
{
    CATransform3D transformFrom = CATransform3DScale(view.layer.transform, 1.26, 1.26, 1.0);
    CATransform3D transformTo   = CATransform3DScale(view.layer.transform, 1.0, 1.0, 1.0);

    view.layer.transform = transformFrom;
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.opacity   = 1.0;
                         view.layer.transform = transformTo;
                         bgView.layer.opacity = 1.0;
                     }
                     completion:completion];
}

+ (void)hideViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion
{
    CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D transformTo   = CATransform3DMakeScale(0.840, 0.840, 1.0);
    
    view.layer.opacity   = 1.0;
    view.layer.transform = transformFrom;
    bgView.layer.opacity = 1.0;
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.opacity   = 0.0;
                         view.layer.transform = transformTo;
                         bgView.layer.opacity = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [view.layer setTransform:CATransform3DIdentity];
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

#pragma mark -
#pragma mark Popup View

+ (void)popupView:(UIView *)view
   backgroundView:(UIView *)bgView
     fromPosition:(NSInteger)fromValue
       toPosition:(NSInteger)toValue
         isBounce:(BOOL)isBounce
       completion:(void (^)(BOOL))completion
{
    CGRect frame = view.frame;
    view.frame = CGRectMake(frame.origin.x, fromValue, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.opacity   = 0.0;
                         view.frame = CGRectMake(frame.origin.x, toValue, frame.size.width, frame.size.height);
                         bgView.layer.opacity = 1.0;
                     }
                     completion:completion];
}

+ (void)disapearPopupView:(UIView *)view
           backgroundView:(UIView *)bgView
             fromPosition:(NSInteger)fromValue
               toPosition:(NSInteger)toValue
               completion:(void (^)(BOOL))completion
{
    CGRect frame = view.frame;
    view.frame = CGRectMake(frame.origin.x, fromValue, frame.size.width, frame.size.height);
    
    [view setUserInteractionEnabled:NO];
    [bgView setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.5058237314224243
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.opacity   = 0.0;
                         view.frame = CGRectMake(frame.origin.x, toValue, frame.size.width, frame.size.height);
                         bgView.layer.opacity = 1.0;
                     }
                     completion:completion];
    
    [UIView animateWithDuration:0.1f
                          delay:0.2f
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         
                         [bgView setAlpha:0.0f];
                     }
                     completion:nil];
}


@end
