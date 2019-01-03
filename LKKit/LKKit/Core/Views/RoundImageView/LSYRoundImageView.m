//
//  LSYRoundImageView.h
//  TTClub
//
//  Created by RoyLei on 15/6/1.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import "LSYRoundImageView.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@implementation LSYRoundImageView
{
    UIView      *_bgMarkView;
    UIImageView *_halfMarkView;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
//        _strokeColor = UIColorWithHexAndAlpha((0x000000, 0.2f);
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _roundMarkView.frame = self.bounds;
    _highlightRoundMarkView.frame = self.bounds;
    _halfMarkView.frame = self.bounds;
    _bgMarkView.frame = self.bounds;
}

- (void)setFrame:(CGRect)frame
{
	CGRect tRect = self.frame;
	[super setFrame:frame];
	
	if(!CGRectIsEmpty(frame) && !CGRectEqualToRect(frame, tRect))
	{
		//不为空，并且改变大小
		[self refreashRoundMarkWithIsNormal:YES];
		[self refreashRoundMarkWithIsNormal:NO];
	}
}

- (void)setDoubleMaskView
{
    if (!_halfMarkView) {
        _halfMarkView = [[UIImageView alloc] initWithImage:_roundMarkView.image
                                          highlightedImage:_roundMarkView.highlightedImage];
        
        WS(weakSelf)
        [_halfMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [self insertSubview:_halfMarkView atIndex:0];
        [self bringSubviewToFront:_bgMarkView];
    }
}

- (void)setRadius:(NSInteger)radius
{
	if(radius != _radius)
	{
		_radius = radius;
		[self refreashRoundMarkWithIsNormal:YES];
		[self refreashRoundMarkWithIsNormal:NO];
	}
}

- (void)setRoundMaskHighlight:(BOOL)isHighlight
{
    [self setRoundMaskHighlight:isHighlight animaiton:NO];
}
- (void)setRoundMaskHighlight:(BOOL)isHighlight animaiton:(BOOL)animation{
    if(animation){
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_highlightRoundMarkView setAlpha:isHighlight?1.0f:0.0f];

        } completion:nil];
    }else{
        [_highlightRoundMarkView setAlpha:isHighlight?1.0f:0.0f];

    }
}


- (void)setRoundMarkColorNormal:(UIColor *)roundMarkColorNormal
{
	if(roundMarkColorNormal != _roundMarkColorNormal)
	{
		_roundMarkColorNormal = roundMarkColorNormal;
		[self refreashRoundMarkWithIsNormal:YES];
	}
}

- (void)setRoundMarkColorHighlight:(UIColor *)roundMarkColorHighlight
{
	if(roundMarkColorHighlight != _roundMarkColorHighlight)
	{
		_roundMarkColorHighlight = roundMarkColorHighlight;
		[self refreashRoundMarkWithIsNormal:NO];
	}
}

- (void)refreashRoundMarkWithIsNormal:(BOOL)isNormal
{
	if((_radius != 0) && _roundMarkColorNormal)
	{
		if(isNormal)
		{
            if (!_roundMarkView) {
                _roundMarkView = [UIImageView new];
                [self addSubview:_roundMarkView];
                [self bringSubviewToFront:_bgMarkView];
            }
            
            _roundMarkView.image = [LVUIUtils getRoundImageWithCutOuter:NO
                                                                   Size:self.frame.size
                                                                 Radius:self.radius
                                                                  color:self.roundMarkColorNormal
                                                        withStrokeColor:_strokeColor];
		}
		else
		{
            
            if (!_highlightRoundMarkView) {
                _highlightRoundMarkView = [UIImageView new];
                [self addSubview:_highlightRoundMarkView];
                [self bringSubviewToFront:_bgMarkView];
                [_highlightRoundMarkView setAlpha:0.0f];
            }
            
            _highlightRoundMarkView.image = [LVUIUtils getRoundImageWithCutOuter:NO
                                                                             Size:self.frame.size
                                                                           Radius:self.radius
                                                                            color:self.roundMarkColorHighlight
                                                                   withStrokeColor:_strokeColor];
		}
	}
}

- (UIView *)bgMarkView
{
    if (!_bgMarkView) {
        UIImageView *bgMarkView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        UIImage *image = [LVUIUtils getRoundImageWithCutOuter:YES
                                                         Size:self.frame.size
                                                       Radius:self.radius
                                                        color:[UIColor colorWithWhite:0.0 alpha:0.4f]
                                              withStrokeColor:nil];
        [bgMarkView setImage:image];
        [bgMarkView setAlpha:0.0f];
        [self addSubview:bgMarkView];
        
        _bgMarkView = bgMarkView;
    }

    return _bgMarkView;
}

@end
