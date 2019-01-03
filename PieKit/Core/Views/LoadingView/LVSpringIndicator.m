//
//  LVSpringIndicator.m
//  Live
//
//  Created by RoyLei on 16/7/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVSpringIndicator.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

NSString *const RotateAnimationKey   = @"rotateAnimation";
NSString *const ExpandAnimationKey   = @"expandAnimation";
NSString *const GroupAnimationKey    = @"groupAnimation";
NSString *const ContractAnimationKey = @"contractAnimation";


@interface LVSpringIndicator ()
{
    NSInteger _animationCount;
    NSInteger _rotateThreshold;
}

@property (strong, nonatomic) UIView *indicatorView;

@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) CAShapeLayer *rotateLayer;

@property (strong, nonatomic) NSPort *timerPort;
@property (strong, nonatomic) NSRunLoop *timerRunLoop;
@property (strong, nonatomic) dispatch_queue_t timerQueue;

@property (strong, nonatomic) NSTimer *strokeTimer;

@property (nonatomic) BOOL animating;

@end

@implementation LVSpringIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];

        _indicatorView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_indicatorView];
        
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _rotateThreshold = (M_PI / M_PI_2 * 2) - 1;
        _timerRunLoop = [NSRunLoop currentRunLoop];
        _timerQueue = dispatch_queue_create("SpringIndicator.Timer.Thread", DISPATCH_QUEUE_CONCURRENT);
        _timerPort = [[NSPort alloc] init];
        
        _lineColor = [UIColor whiteColor];
        _lineWidth = 3;
        
        _rotateDuration = 1.0f;
        _strokeDuration = 0.7;
        
        dispatch_async(self.timerQueue, ^{
            [self.timerRunLoop addPort:self.timerPort forMode:NSRunLoopCommonModes];
            [self.timerRunLoop run];
        });
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    if (self.animating) {
//        [self startAnimation:NO];
//    }
//}

- (BOOL)isSpinning
{
    return ([self.pathLayer animationForKey:ContractAnimationKey] != nil || [self.pathLayer animationForKey:GroupAnimationKey] != nil);
}

- (NSInteger)incrementAnimationCount
{
    _animationCount++;
    
    if (_animationCount > _rotateThreshold) {
        _animationCount = 0;
    }
    
    return _animationCount;
}

#pragma mark - Getter

- (CAShapeLayer *)rotateLayer
{
    if (!_rotateLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = _lineColor.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = _lineWidth;
        shapeLayer.lineCap = kCALineCapRound;
        
        _rotateLayer = shapeLayer;
    }
    
    return _rotateLayer;
}

- (CAShapeLayer *)nextStrokeLayer:(NSInteger)count
{
    CAShapeLayer *shapeLayer = self.rotateLayer;
    shapeLayer.path = [self nextRotatePath:count].CGPath;
    return shapeLayer;
}

- (UIBezierPath *)nextRotatePath:(NSInteger)count
{
    _animationCount = count;
    
    CGFloat start = M_PI_2 * (0 - count);
    CGFloat end = M_PI_2 * (_rotateThreshold - count);
    CGPoint center = CGPointMake(self.width / 2, self.height / 2);
    CGFloat radius = MAX(self.width, self.height) / 2;
    
    UIBezierPath * arc = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
    arc.lineWidth = 0;
    
    return arc;
}

- (void)strokeRatio:(CGFloat)ratio {
    
    if (ratio <= 0) {
        self.pathLayer = nil;
    } else if (ratio >= 1) {
        [self strokeValue:1];
    } else {
        [self strokeValue:ratio];
    }
}

- (void)strokeValue:(CGFloat)value {
    if (self.pathLayer == nil) {
        CAShapeLayer *shapeLayer = [self nextStrokeLayer:0];
        self.pathLayer = shapeLayer;
        [self.indicatorView.layer addSublayer:shapeLayer];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.pathLayer.strokeStart = 0;
    self.pathLayer.strokeEnd = value;
    [CATransaction commit];
}

- (void)startAnimation:(BOOL)expand
{
    self.stopAnimationsHandler = nil;
    
    if ([self isSpinning]) {
        return;
    }
    
    CAPropertyAnimation *animation = [self rotateAnimation:_rotateDuration];
    [self.indicatorView.layer addAnimation:animation forKey:RotateAnimationKey];
    
    [self strokeTransaction:expand];
    
    [self setStrokeTimer:[self nextStrokeTimer:expand]];
}

/// true is wait for stroke animation.
- (void)stopAnimation:(BOOL)waitAnimation completion:(void(^)())completion {
    if (waitAnimation) {
        
        WS(weakSelf)
        self.stopAnimationsHandler = ^(LVSpringIndicator *indicator){
            [weakSelf stopAnimation:NO completion:completion];
        };
        
    } else {
        
        [self.timerPort invalidate];
        
        self.strokeTimer = nil;
        self.stopAnimationsHandler = nil;
        [self.indicatorView.layer removeAllAnimations];
        self.pathLayer.strokeEnd = 0;
        self.pathLayer = nil;
        
        if ([NSThread currentThread].isMainThread && completion) {
            completion();
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                if (completion) {
                    completion();
                }
            });
        }
    }
}

- (void)strokeTransaction:(BOOL)expand {
    NSInteger count = [self nextAnimationCount:expand];
    
    if (self.pathLayer) {
        [self.pathLayer removeAllAnimations];
        self.pathLayer.path = [self nextRotatePath:count].CGPath;
        self.pathLayer.strokeColor = self.lineColor.CGColor;
        self.pathLayer.lineWidth = self.lineWidth;
    }else {
        CAShapeLayer *shapeLayer = [self nextStrokeLayer:count];
        self.pathLayer = shapeLayer;
        [self.indicatorView.layer addSublayer:shapeLayer];
    }
    
    CAAnimation *animation = [self nextStrokeAnimation:expand];
    NSString *animationKey = [self nextAnimationKey:expand];
    
    [self.pathLayer addAnimation:animation forKey:animationKey];
}

// MARK: stroke properties
- (NSTimer *)nextStrokeTimer:(BOOL)expand {
    NSString *animationKey = [self nextAnimationKey:expand];
    
    if (expand) {
        return [self createStrokeTimer:_strokeDuration userInfo:animationKey repeats:NO];
    } else {
        return [self createStrokeTimer:_strokeDuration * 2 userInfo:animationKey repeats:YES];
    }
}

- (NSString *)nextAnimationKey:(BOOL)expand {
    return expand ? ContractAnimationKey : GroupAnimationKey;
}

- (NSInteger)nextAnimationCount:(BOOL)expand {
    return expand ? 0 : [self incrementAnimationCount];
}

- (CAAnimation *)nextStrokeAnimation:(BOOL)expand {
    return expand ? [self contractAnimation:_strokeDuration] : [self groupAnimation:_strokeDuration];
}

// MARK: animations
- (CAPropertyAnimation *)rotateAnimation:(CFTimeInterval)duration {
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = duration;
    anim.repeatCount = HUGE;
    anim.fromValue = @(-(M_PI + M_PI_4));
    anim.toValue = @(M_PI - M_PI_4);
    anim.removedOnCompletion = NO;
    
    return anim;
}

- (CAAnimationGroup *)groupAnimation:(CFTimeInterval)duration {
    CAPropertyAnimation * expand = [self expandAnimation:duration];
    expand.beginTime = 0;
    
    CAPropertyAnimation * contract = [self contractAnimation:duration];
    contract.beginTime = duration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[expand, contract];
    group.duration = duration * 2;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    return group;
}

- (CAPropertyAnimation *)contractAnimation:(CFTimeInterval)duration {
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    anim.duration = duration;
    anim.keyTimes = @[@(0), @(0.3), @(0.5), @(0.7), @(1)];
    anim.values = @[@(0), @(0.1), @(0.5), @(0.9), @(1)];
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

- (CAPropertyAnimation *)expandAnimation:(CFTimeInterval)duration {
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = duration;
    anim.keyTimes = @[@(0), @(0.3), @(0.5), @(0.7), @(1)];
    anim.values = @[@(0), @(0.1), @(0.5), @(0.9), @(1)];
    
    return anim;
}

- (NSTimer *)createStrokeTimer:(NSTimeInterval)timeInterval userInfo:(id)userInfo repeats:(BOOL) yesOrNo {
    return [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(onStrokeTimer:) userInfo:userInfo repeats:yesOrNo];
}

- (void)setStrokeTimer:(NSTimer *)timer {
    
    if (_strokeTimer != timer) {
        [_strokeTimer invalidate];
        _strokeTimer = timer;
        
        if (timer) {
            [self.timerRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)onStrokeTimer:(id)sender {
    
    if (self.stopAnimationsHandler) {
        self.stopAnimationsHandler(self);
    }
    
    if (self.intervalAnimationsHandler) {
        self.intervalAnimationsHandler(self);
    }
    
    if ([self isSpinning] == NO) {
        return;
    }
    
    NSTimer *timer = [self createStrokeTimer:_strokeDuration * 2 userInfo:GroupAnimationKey repeats:YES];
    
    [self setStrokeTimer:timer];
    [self strokeTransaction:NO];
}

- (CAShapeLayer *)videoIcon
{
    CGFloat circleSize = self.size.width / 2;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.fillColor = [UIColor whiteColor].CGColor;
    circle.frame = CGRectMake((self.bounds.size.width - circleSize) / 2, (self.bounds.size.height - circleSize) / 2, circleSize, circleSize);

    CGRect rect = CGRectMake((circle.frame.size.width - 28)/2, (circle.frame.size.height - 20)/2, 24, 18);
    UIBezierPath * rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];

    UIBezierPath* polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint: CGPointMake(CGRectGetMaxX(rect)-4, CGRectGetMidY(rect))];
    [polygonPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)+8, CGRectGetMidY(rect)-6)];
    [polygonPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)+8, CGRectGetMidY(rect)+6)];
    [polygonPath closePath];
    [rectanglePath appendPath:polygonPath];

    circle.path = rectanglePath.CGPath;
    
    return circle;
}

@end
