//
//  CALayer+Helper.m
//  AnimationTool
//
//  Created by Heller on 16/4/18.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+Helper.h"

@implementation CALayer (Helper)

+ (CALayer *)layerFromImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CALayer *layer = [CALayer layer];
    layer.contents = (id)[image CGImage];
    layer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    return layer;
}

@end
