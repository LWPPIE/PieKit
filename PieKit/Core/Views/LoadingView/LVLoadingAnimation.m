//
//  LVLoaingAnimation.m
//  Live
//
//  Created by RoyLei on 16/7/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVLoadingAnimation.h"
#import "CAAnimation+Blocks.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@interface LVLoadingAnimation ()

@property (strong, nonatomic) NSMutableArray <CAShapeLayer *>*layers;
@property (assign, nonatomic) BOOL isLoading; /**< 正在显示加载 */

@end

@implementation LVLoadingAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _layers = [NSMutableArray arrayWithCapacity:10];
        _lineType = LVLoadingLineTypeBig;
    }
    return self;
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    NSInteger lineCount = 10;
    
    CGFloat lineWidth1 = 3;
    CGFloat lineWidth2 = 3;

    CGFloat lineMargin = 8;

    switch (_lineType) {
        case LVLoadingLineTypeBig: {
            lineWidth1 = 3;
            lineWidth2 = 2.5;
            lineMargin = 8;
            break;
        }
        case LVLoadingLineTypeSmall: {
            lineWidth1 = 2;
            lineWidth2 = 1.5;
            lineMargin = 5;
            break;
        }
    }
    
    CGFloat widthT = 10 * lineWidth1 + (lineCount - 1) * lineMargin - 2;
    
    CGFloat x = (layer.bounds.size.width - widthT) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    CGRect layerFrame = CGRectMake(x, y, lineWidth1, size.height);

    for (int i = 0; i < 10; i++) {

        if (i == 1 ||
            i == 3 ||
            i == 5 ||
            i == 6 ||
            i == 8 ||
            i == 10) {
            layerFrame.size.width = lineWidth1;
        }else {
            layerFrame.size.width = lineWidth2;
        }
        
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layerFrame.size.width, size.height)];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        line.frame = layerFrame;
        
        [layer addSublayer:line];
        [_layers addObject:line];
        
        layerFrame.origin.x += lineMargin + layerFrame.size.width;
    }
}

- (void)startAnimation
{
    self.isLoading = YES;

    CGFloat duration = 2.2f;
    NSArray *beginTimes = @[@0.00f, @0.10f, @0.20f, @0.30f, @0.40f, @0.50f, @0.60f, @0.70f, @0.80f, @0.90f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    animation.keyTimes = @[@0.0f, @0.16f, @0.32f, @0.48, @0.64, @1.0];
    animation.values = @[@1.0f, @0.0f, @1.0f, @0.0, @1.0f, @1.0f];
    animation.timingFunctions = @[timingFunction];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [_layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull lineLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        animation.beginTime = [beginTimes[idx] floatValue] + CACurrentMediaTime();
        [lineLayer addAnimation:animation forKey:@"animation"];
    }];
}

- (void)startAnimationHaveBeginAnimation
{
    self.isLoading = YES;
    
    [_layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull lineLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        lineLayer.transform = CATransform3DMakeScale(1.0, 0.0, 1.0);
    }];
    
    NSArray *beginTimes = @[@0.00f, @0.10f, @0.20f, @0.30f, @0.40f, @0.50f, @0.60f, @0.70f, @0.80f, @0.90f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Animation
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    startAnimation.keyTimes = @[@0.0f, @1.0];
    startAnimation.values = @[@0.0f, @1.0f];
    startAnimation.timingFunctions = @[timingFunction];
    startAnimation.duration = 0.25;
    startAnimation.removedOnCompletion = NO;
    startAnimation.fillMode = kCAFillModeForwards;
    startAnimation.repeatCount = 0;

    WS(weakSelf)
    [_layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull lineLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == _layers.count - 1) {
            [startAnimation setCompletion:^(BOOL finished) {
                if (weakSelf.isLoading) {
                    [weakSelf startAnimation];
                }
            }];
        }
        
        startAnimation.beginTime = [beginTimes[idx] floatValue] + CACurrentMediaTime();
        [lineLayer addAnimation:startAnimation forKey:@"groupAnimation"];
    }];
}

- (void)stopAnimation
{
    self.isLoading = NO;

    [_layers enumerateObjectsUsingBlock:^(CALayer * _Nonnull lineLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [lineLayer removeAllAnimations];
    }];
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor) {
        _lineColor = nil;
        _lineColor = lineColor;
        
        [_layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
            line.fillColor = lineColor.CGColor;
        }];
    }
}

+ (void)setupLineScalePulseOutRapidAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {

    CGFloat duration = 1.0f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.09f :0.57f :0.49f :0.9f];
    
    // Small circle
    {
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.keyTimes = @[@0.0f, @0.3f, @1.0f];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        scaleAnimation.duration = duration;
        scaleAnimation.repeatCount = HUGE_VALF;
        scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
        [scaleAnimation setRemovedOnCompletion:NO];
        [scaleAnimation setFillMode:kCAFillModeForwards];

        CGFloat circleSize = size.width / 2;
        
//        CAShapeLayer *circle = [CAShapeLayer layer];
//        circle.fillColor = tintColor.CGColor;
//        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
//
//        CGRect rect = CGRectMake((circle.frame.size.width - 28)/2, (circle.frame.size.height - 20)/2, 24, 18);
//        UIBezierPath * rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];
//        
//        UIBezierPath* polygonPath = [UIBezierPath bezierPath];
//        [polygonPath moveToPoint: CGPointMake(CGRectGetMaxX(rect)-4, CGRectGetMidY(rect))];
//        [polygonPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)+8, CGRectGetMidY(rect)-6)];
//        [polygonPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)+8, CGRectGetMidY(rect)+6)];
//        [polygonPath closePath];
//        [rectanglePath appendPath:polygonPath];
//
//        circle.path = rectanglePath.CGPath;
        
        CALayer *circle = [CALayer layer];

        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        circle.backgroundColor = UIColorWithHex(0xffb71b).CGColor;
//        circle.contents = (id)LKImage(@"nav_icon_camera").CGImage;
        circle.cornerRadius = circleSize / 2;
        [circle addAnimation:scaleAnimation forKey:@"animation"];
        [layer addSublayer:circle];
    }
    
//    return;
    // Big circle
    {
        // Scale animation
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        scaleAnimation.duration = duration;
        scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
        
        // Rotate animation
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
        rotateAnimation.keyTimes = scaleAnimation.keyTimes;
        rotateAnimation.duration = duration;
        rotateAnimation.timingFunctions = @[timingFunction, timingFunction];
        
        // Animation
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        
        animation.animations = @[scaleAnimation, rotateAnimation];
        animation.duration = duration;
        animation.repeatCount = HUGE_VALF;
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:kCAFillModeForwards];
        
        // Draw big circle
        CGFloat circleSize = size.width;
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-3 * M_PI / 4 endAngle:-M_PI / 4 clockwise:true];
        [circlePath moveToPoint:CGPointMake(circleSize / 2 - circleSize / 2 * cosf(M_PI / 4), circleSize / 2 + circleSize / 2 * sinf(M_PI / 4))];
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-5 * M_PI / 4 endAngle:-7 * M_PI / 4 clockwise:false];
        circle.path = circlePath.CGPath;
        circle.lineWidth = 2;
        circle.fillColor = nil;
        circle.strokeColor = tintColor.CGColor;
        
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

+ (void)setupBallScaleMultipleAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    CGFloat duration = 1.0f;
    
    // Scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.duration = duration;
    scaleAnimation.fromValue = @0.0f;
    scaleAnimation.toValue = @1.0f;
    
    // Opacity animation
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.duration = duration;
    opacityAnimation.fromValue = @1.0f;
    opacityAnimation.toValue = @0.0f;
    
    // Animation
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    // Draw circle
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
    
    circle.fillColor = tintColor.CGColor;
    circle.path = circlePath.CGPath;
    circle.opacity = 0.2f;
    [circle addAnimation:animation forKey:@"animation"];
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [layer addSublayer:circle];
}

+ (void)setupThreeDotsAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CGFloat circleSize = size.width / 6.0f;
    CGFloat circlePadding = circleSize / 2.0f;
    
    CGFloat oX = (layer.bounds.size.width - circleSize * 3 - circlePadding * 2) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize * 1) / 2.0f;
    
    CALayer *circle1 = [CALayer layer];
    circle1.backgroundColor = tintColor.CGColor;
    circle1.frame = CGRectMake(oX + (circleSize + circlePadding) * (0 % 3), oY, circleSize, circleSize);

    CALayer *circle2 = [CALayer layer];
    circle2.backgroundColor = tintColor.CGColor;
    circle2.frame = CGRectMake(oX + (circleSize + circlePadding) * (1 % 3), oY, circleSize, circleSize);
    
    CALayer *circle3 = [CALayer layer];
    circle3.backgroundColor = tintColor.CGColor;
    circle3.frame = CGRectMake(oX + (circleSize + circlePadding) * (2 % 3), oY, circleSize, circleSize);
    
    [layer addSublayer:circle1];
    [layer addSublayer:circle2];
    [layer addSublayer:circle3];

//    for (int i = 0; i < 3; i++) {
//        
//        circle.backgroundColor = tintColor.CGColor;
//        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
//        circle.opacity = 1.0f;
//        circle.cornerRadius = circle.bounds.size.width / 2.0f;
//        
//        CAKeyframeAnimation *tranformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        
//        tranformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)],
//                                     [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)]];
//        
//        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        
//        opacityAnimation.values = @[@(0.25f), @(1.0f)];
//        
//        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//        
//        animationGroup.removedOnCompletion = NO;
//        animationGroup.autoreverses = YES;
//        animationGroup.beginTime = beginTime;
//        animationGroup.repeatCount = HUGE_VALF;
//        animationGroup.duration = duration;
//        animationGroup.animations = @[tranformAnimation, opacityAnimation];
//        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        
//        [layer addSublayer:circle];
//        [circle addAnimation:animationGroup forKey:@"animation"];
//    }
}

- (void)setLayerAnimation:(CALayer *)circle
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    NSTimeInterval duration = 0.5f;
    
    circle.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.opacity = 1.0f;
    circle.cornerRadius = circle.bounds.size.width / 2.0f;
    
    CAKeyframeAnimation *tranformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    tranformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)]];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.values = @[@(0.25f), @(1.0f)];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    animationGroup.removedOnCompletion = NO;
    animationGroup.autoreverses = YES;
    animationGroup.beginTime = beginTime;
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.duration = duration;
    animationGroup.animations = @[tranformAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [circle addAnimation:animationGroup forKey:@"animation"];
}


@end
