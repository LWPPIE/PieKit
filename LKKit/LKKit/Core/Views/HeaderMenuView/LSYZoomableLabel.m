//
//  LSYZoomableLabel.m
//  TTClub
//
//  Created by RoyLei on 15/8/12.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LSYZoomableLabel.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "LKMacros.h"

@implementation LSYZoomableLabel
{
    NSRecursiveLock *_colorLock;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (IOS8) {
        CATiledLayer *tiledLayer = (CATiledLayer *)self.layer;
        tiledLayer.contents = nil;
        tiledLayer.levelsOfDetailBias = 4;
        tiledLayer.levelsOfDetail = 4;
        self.opaque = YES;
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    lk_dispatch_main_sync_safe(^{
        [_colorLock lock];
        [super drawLayer:layer inContext:ctx];
        [_colorLock unlock];
    });
}

- (NSRecursiveLock *)colorLock
{
    if (!_colorLock) {
        _colorLock = [[NSRecursiveLock alloc] init];
    }
    
    return _colorLock;
}

- (void)setTransform:(CGAffineTransform)transform color:(UIColor *)color
{
    [self setTransform:transform];

    if (IOS8) {
        [self.colorLock lock];
        [self setTextColor:color];
        [self.colorLock unlock];
    }else {
        [self setTextColor:color];
    }
}

+ (Class)layerClass
{
    if (IOS8) {
        return [CATiledLayer class];
    }
    return [CALayer class];
}

@end
