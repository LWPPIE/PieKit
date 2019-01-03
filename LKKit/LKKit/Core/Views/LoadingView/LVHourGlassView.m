//
//  LVHourGlassView.m
//  Live
//
//  Created by RoyLei on 16/7/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVHourGlassView.h"

#define kLV_HourGlass_Length 30.0f
#define kLV_HourGlass_Duration 3.5f

@interface LVHourGlassView ()
{
    CGFloat __width;
    CGFloat __height;
    
    BOOL _isShowing;
}
// Top
@property (strong, nonatomic) CAShapeLayer *topLayer;

// Bottom
@property (strong, nonatomic) CAShapeLayer *bottomLayer;

// Dash line
@property (strong, nonatomic) CAShapeLayer *lineLayer;

// container Layer
@property (strong, nonatomic) CALayer *containerLayer;

// Animaiton
@property (strong, nonatomic) CAKeyframeAnimation *topAnimation;

@property (strong, nonatomic) CAKeyframeAnimation *bottomAnimation;

@property (strong, nonatomic) CAKeyframeAnimation *lineAnimation;

@property(strong, nonatomic) CAKeyframeAnimation *containerAnimation;

///////////
// Init
-(void) initCommon;
-(void) initContainer;
-(void) initTop;
-(void) initBottom;
-(void) initLine;
-(void) initAnimation;

@end

@implementation LVHourGlassView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCommon];
        
        [self initContainer];
        
        [self initTop];
        
        [self initBottom];
        
        [self initLine];
        
        [self initAnimation];
    }
    return self;
}
-(void) initCommon
{
    _isShowing = NO;
    
    __width = sqrtf(kLV_HourGlass_Length * kLV_HourGlass_Length + kLV_HourGlass_Length * kLV_HourGlass_Length);
    __height = sqrtf((kLV_HourGlass_Length * kLV_HourGlass_Length) - ((__width / 2.0f) * (__width / 2.0f)));
}
-(void) initContainer
{
    _containerLayer = [CALayer layer];
    _containerLayer.backgroundColor = [UIColor clearColor].CGColor;
    _containerLayer.frame = CGRectMake(0, 0, __width, __height * 2);
    _containerLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    _containerLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    [self.layer addSublayer:_containerLayer];
}
-(void) initTop
{
    // BezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(__width, 0)];
    [path addLineToPoint:CGPointMake(__width / 2.0f, __height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [path closePath];
    
    // Top Layer
    _topLayer = [CAShapeLayer layer];
    _topLayer.frame = CGRectMake(0, 0, __width, __height);
    _topLayer.path = path.CGPath;
    _topLayer.fillColor = [UIColor whiteColor].CGColor;
    _topLayer.strokeColor = [UIColor whiteColor].CGColor;
    _topLayer.lineWidth = 0.0f;
    _topLayer.anchorPoint = CGPointMake(0.5f, 1);
    _topLayer.position = CGPointMake(__width / 2.0f, __height);
    
    [_containerLayer addSublayer:_topLayer];
}
-(void) initBottom
{
    // BezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(__width / 2, 0)];
    [path addLineToPoint:CGPointMake(__width, __height)];
    [path addLineToPoint:CGPointMake(0, __height )];
    [path addLineToPoint:CGPointMake(__width / 2, 0)];
    
    [path closePath];
    
    // Top Layer
    _bottomLayer = [CAShapeLayer layer];
    _bottomLayer.frame = CGRectMake(0, __height, __width, __height);
    _bottomLayer.path = path.CGPath;
    _bottomLayer.fillColor = [UIColor whiteColor].CGColor;
    _bottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    _bottomLayer.lineWidth = 0.0f;
    _bottomLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    _bottomLayer.position = CGPointMake(__width / 2.0f, __height * 2.0f);
    _bottomLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    [_containerLayer addSublayer:_bottomLayer];
}
-(void) initLine
{
    // BezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(__width / 2, 0)];
    [path addLineToPoint:CGPointMake(__width / 2, __height)];
    
    // Line Layer
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.frame = CGRectMake(0, __height, __width, __height);
    _lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    _lineLayer.lineWidth = 1.0;
    _lineLayer.lineJoin = kCALineJoinMiter;
    _lineLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];
    _lineLayer.lineDashPhase = 3.0f;
    _lineLayer.path = path.CGPath;
    _lineLayer.strokeEnd = 0.0f;
    
    [_containerLayer addSublayer:_lineLayer];
}
-(void) initAnimation
{
    if (YES) // Top Animation
    {
        _topAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _topAnimation.duration = kLV_HourGlass_Duration;
        _topAnimation.repeatCount = HUGE_VAL;
        _topAnimation.keyTimes = @[@0.0f, @0.9f, @1.0f];
        _topAnimation.values = @[@1.0f, @0.0f, @0.0f];
    }
    if (YES) // Bottom Animation
    {
        _bottomAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _bottomAnimation.duration = kLV_HourGlass_Duration;
        _bottomAnimation.repeatCount = HUGE_VAL;
        _bottomAnimation.keyTimes = @[@0.1f, @0.9f, @1.0f];
        _bottomAnimation.values = @[@0.0f, @1.0f, @1.0f];
    }
    if (YES) // Bottom Animation
    {
        _lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        _lineAnimation.duration = kLV_HourGlass_Duration;
        _lineAnimation.repeatCount = HUGE_VAL;
        _lineAnimation.keyTimes = @[@0.0f, @0.1f, @0.9f, @1.0f];
        _lineAnimation.values = @[@0.0f, @1.0f, @1.0f, @1.0f];
    }
    if (YES) // Container Animation
    {
        _containerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        _containerAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :1 :0.8f :0.0f];
        _containerAnimation.duration = kLV_HourGlass_Duration;
        _containerAnimation.repeatCount = HUGE_VAL;
        _containerAnimation.keyTimes = @[@0.8f, @1.0f];
        _containerAnimation.values = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:M_PI]];
        //_containerAnimation.calculationMode = kCAAnimationCubic;
    }
}

#pragma mark - Action

- (void)startLoadingAnimation
{
    if (_isShowing)
        return;
    
    _isShowing =  YES;
    
    [_topLayer addAnimation:_topAnimation forKey:@"TopAnimatin"];
    [_bottomLayer addAnimation:_bottomAnimation forKey:@"BottomAnimation"];
    [_lineLayer addAnimation:_lineAnimation forKey:@"LineAnimation"];
    [_containerLayer addAnimation:_containerAnimation forKey:@"ContainerAnimation"];
}

- (void)stopLoadingAnimation
{
    if (!_isShowing)
        return;
    
    _isShowing = NO;
    
    [_topLayer removeAllAnimations];
    [_bottomLayer removeAllAnimations];
    [_lineLayer removeAllAnimations];
    [_containerLayer removeAllAnimations];
}

@end
