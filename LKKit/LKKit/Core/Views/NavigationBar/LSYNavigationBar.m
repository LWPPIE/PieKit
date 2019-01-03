//
//  LSYNavigationBar.m
//  TTClub
//
//  Created by RoyLei on 16/2/19.
//  Copyright © 2016年 TTClub. All rights reserved.
//

#import "LSYNavigationBar.h"

@interface LSYNavigationBar ()

@property (strong, nonatomic) UIView *lsyUnderlayView;
@property (strong, nonatomic) UINavigationItem *firstNavigationItem;
@end

@implementation LSYNavigationBar

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    if(subview != _lsyUnderlayView && _lsyUnderlayView) {
        UIView* lsyUnderlayView = self.lsyUnderlayView;
        [lsyUnderlayView removeFromSuperview];
        [self insertSubview:lsyUnderlayView atIndex:1];
    }
}

- (UIView *)lsyUnderlayView
{
    if(_lsyUnderlayView == nil) {
        
        CGFloat statusBarHeight = 20;
        CGSize selfSize = self.frame.size;
        
        _lsyUnderlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, selfSize.width, selfSize.height + statusBarHeight)];
        [_lsyUnderlayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [_lsyUnderlayView setHidden:YES];
        [_lsyUnderlayView setUserInteractionEnabled:NO];
        
        UIView* lsyUnderlayView = self.lsyUnderlayView;
        [lsyUnderlayView removeFromSuperview];
        [self insertSubview:lsyUnderlayView atIndex:1];
    }
    
    return _lsyUnderlayView;
}

- (UINavigationItem *)firstNavigationItem
{
    if (!_firstNavigationItem && self.items.count > 0) {
        _firstNavigationItem = [self.items firstObject];
    }
    
    return _firstNavigationItem;
}

@end
