//
//  LSYReminderPatternView.m
//  TTClub
//
//  Created by RoyLei on 15/7/17.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LSYReminderPatternView.h"
#import "UIView+YYAdd.h"

#define CGPointCenterPointOfRect(rect) CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f)

@implementation LSYReminderPatternView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self) {
        
        self.lineWidth = 2.0f;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _strokeColor = [UIColor whiteColor];
        _drawColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.isProgressing) {
        [self drawCicleBackground:rect];
    }else if (self.image) {
        CGSize imageSize = self.image.size;
        [self.image drawInRect:CGRectMake(roundf((self.width-imageSize.width)/2),
                                          roundf((self.height-imageSize.height)/2),
                                          imageSize.width,
                                          imageSize.height)];
    }
}

- (void)drawCicleBackground:(CGRect)rect
{
    CGFloat radiusMinusLineWidth = self.radius-self.lineWidth/2;
    UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointCenterPointOfRect(rect)
                                                                  radius:radiusMinusLineWidth
                                                              startAngle:0
                                                                endAngle:2 * M_PI
                                                               clockwise:YES];
    [_strokeColor setStroke];
    progressCircle.lineWidth = self.lineWidth;
    [progressCircle stroke];
}

#pragma mark - UIActivityIndicatorView and CAShapeLayer

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

- (CAShapeLayer *)pathLayer
{
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        [_pathLayer setFrame:self.bounds];
        _pathLayer.lineWidth = [self radius];
        _pathLayer.fillColor   = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = _drawColor.CGColor;
        [self.layer addSublayer:_pathLayer];
    }
    
    return _pathLayer;
}

#pragma mark - UIBezierPath

- (UIBezierPath *)progressPath
{
    if (!_progressPath) {
        
        CGFloat radius = [self radius];
        
        self.sectorWidth = radius;
        
        CGFloat radiusMinusLineWidth = self.radius-self.sectorWidth/2;
        
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = startAngle + 2 * M_PI;
        
        _progressPath = [self getPathWithProgressArcWithStartAngle:startAngle
                                                          endAngle:endAngle
                                                            radius:radiusMinusLineWidth
                                                         clockwise:YES];
    }
    
    return _progressPath;
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = nil;
        _image = image;
        [self setNeedsDisplay];
    }
}

- (void)setIsProgressing:(BOOL)isProgressing
{
    _isProgressing = isProgressing;
    [_pathLayer setHidden:!_isProgressing];
}

- (void)setPercentage:(CGFloat)percentage
{
    if (_image) {
        _image  = nil;
    }
    
    [self setNeedsDisplay];
    
    if (!_progressPath) {
        [self.pathLayer setPath:[self progressPath].CGPath];
    }
    
    [self.pathLayer removeAllAnimations];
    
    if (percentage > 1.0) {
        percentage = 0.0;
    }
    
    CABasicAnimation *pathAnimation = (CABasicAnimation *)[_pathLayer animationForKey:@"strokeProgress"];
    if (!pathAnimation) {
        pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [pathAnimation setDuration:0.2];
        [pathAnimation setFromValue:@(_percentage)];
        [pathAnimation setToValue:@(percentage)];
        [pathAnimation setFillMode:kCAFillModeForwards];
        [pathAnimation setRemovedOnCompletion:NO];
        [_pathLayer addAnimation:pathAnimation forKey:@"strokeProgress"];
    }
    
    _percentage = fminf(fmax(percentage, 0), 1);
}

- (void)setFinished
{
    CABasicAnimation *pathAnimation = (CABasicAnimation *)[_pathLayer animationForKey:@"strokeProgress"];
    if (!pathAnimation) {
        pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [pathAnimation setDuration:0.2];
        [pathAnimation setFromValue:@(1.0)];
        [pathAnimation setToValue:@(0.0)];
        [pathAnimation setFillMode:kCAFillModeForwards];
        [pathAnimation setRemovedOnCompletion:NO];
        [_pathLayer addAnimation:pathAnimation forKey:@"strokeProgress"];
    }
}

#pragma mark - Getter

- (CGFloat) radius
{
    return self.width/2.0;
}

- (UIBezierPath *)getPathWithProgressArcWithStartAngle:(CGFloat)startAngle
                                              endAngle:(CGFloat)endAngle
                                                radius:(CGFloat)radius
                                             clockwise:(BOOL)clockwise
{
    UIBezierPath *progressCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointCenterPointOfRect(self.bounds)
                                                                      radius:radius
                                                                  startAngle:startAngle
                                                                    endAngle:endAngle
                                                                   clockwise:clockwise];
    
    progressCirclePath.lineWidth = self.sectorWidth/2;
    return progressCirclePath;
}

@end
