//
//  LSYNLineView.m
//  13Helper
//
//  Created by TTClub RoyLei on 14/11/25.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import "LSYNLineView.h"
#import "LSYConstance.h"
#import "LVUIUtils.h"

#define LK_LINE_COLOR LKColorRGB(238, 238, 238)

@interface LSYNLineView()
{
    BOOL _isVertical;
    
    UIColor *_color;
}

@end

@implementation LSYNLineView

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(YES, @"not!");
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    return [self initGrayLineWithFrame:frame vertical:NO isFirstPixelOpaque:YES];
}

- (id)initGrayLineWithFrame:(CGRect)frame
                   vertical:(BOOL)isVertical
         isFirstPixelOpaque:(BOOL)isFirstOpaque
{
    return [self initWithFrame:frame
                      vertical:isVertical
            isFirstPixelOpaque:isFirstOpaque
                     lineColor:LK_LINE_COLOR];
}

- (id)initWithFrame:(CGRect)frame
           vertical:(BOOL)isVertical
 isFirstPixelOpaque:(BOOL)isFirstOpaque
          lineColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    
    if (nil != self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _isVertical = isVertical;
        
        CGRect lineFrame = (CGRect){self.frame.origin,self.bounds.size};
        
        UIImage *image = [LVUIUtils getLineImageWithIsVertical:isVertical
                                            isFirstPixelOpaque:isFirstOpaque
                                                highlightColor:color];
        if (_isVertical) {
            
            self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            lineFrame.size.width = 1;
            
        }else{
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            lineFrame.size.height = 1;
        }
        
        [self setFrame:lineFrame];
        [self setImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color vertical:(BOOL)isVertical
{
    _isVertical = isVertical;
    
    if (_isVertical) {
        frame.size.width = 1;
    }else{
        frame.size.height = 1;
    }
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _color = color;
        
    }
    return self;
}

@end
