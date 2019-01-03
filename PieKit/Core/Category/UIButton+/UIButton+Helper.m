//
//  UIButton+Helper.m
//  Live
//
//  Created by Heller on 16/3/11.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "UIButton+Helper.h"
#import <objc/runtime.h>
#import "LVUIUtils.h"
#import "UIColor+YYAdd.h"
#import "UIImage+YYAdd.h"

static char const * const LVCustomBadgeTagKey = "LVCustomBadgeObjectTag";

@implementation UIButton (Helper)

@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (UIView *)lv_customBadge
{
    return objc_getAssociatedObject(self, LVCustomBadgeTagKey);
}

- (void)setLv_customBadge:(UIImageView *)newObjectTag
{
    objc_setAssociatedObject(self, LVCustomBadgeTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lv_displayRedPoint:(BOOL)display
{
    if (!self.lv_customBadge) {
        UIImageView *redImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor redColor]]];
        redImageView.backgroundColor = [UIColor redColor];
        redImageView.layer.masksToBounds = YES;
        redImageView.layer.cornerRadius = 3;
        redImageView.layer.allowsEdgeAntialiasing = YES;
        self.lv_customBadge = redImageView;
        
        CGSize btnImageSize = self.imageView.image.size;
        
        if (redImageView) {
            redImageView.frame = CGRectMake(0,0,6,6);
            redImageView.center = CGPointMake(self.imageView.frame.size.width/2 + btnImageSize.width - 10,
                                              self.imageView.frame.size.height/2 - btnImageSize.height + 14);

            [redImageView setUserInteractionEnabled:NO];
            
            [self.imageView addSubview:redImageView];
            self.imageView.clipsToBounds = NO;
            self.clipsToBounds = NO;
        }
    }
    
    [self.lv_customBadge setHidden:!display];
}

+ (UIButton *)createButton:(UIImage *)normalImg
              highlightImg:(UIImage *)highlightImg
               selectedImg:(UIImage *)selectedImg
                     title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if(normalImg)
        [button setImage:normalImg forState:UIControlStateNormal];
    if(highlightImg)
        [button setImage:highlightImg forState:UIControlStateHighlighted];
    if(selectedImg)
        [button setImage:selectedImg forState:UIControlStateSelected];
    
    return button;
}

- (void)lv_setUpImageAndDownTitleByMargin:(CGFloat)margin
{
    CGPoint buttonBoundsCenter    = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint endImageViewCenter    = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    CGPoint endTitleLabelCenter   = CGPointMake(buttonBoundsCenter.x,
                                                CGRectGetHeight(self.bounds)-
                                                CGRectGetMidY(self.titleLabel.bounds));
    
    CGPoint startImageViewCenter  = self.imageView.center;
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    CGFloat imageEdgeInsetsTop    = -margin;
    CGFloat imageEdgeInsetsLeft   = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight  = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets        = UIEdgeInsetsMake(imageEdgeInsetsTop,
                                                   imageEdgeInsetsLeft,
                                                   imageEdgeInsetsBottom,
                                                   imageEdgeInsetsRight);
    
    CGFloat titleEdgeInsetsTop    = ceilf(fabs(margin)*2)+2;
    CGFloat titleEdgeInsetsLeft   = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight  = -titleEdgeInsetsLeft;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop,
                                            titleEdgeInsetsLeft,
                                            titleEdgeInsetsBottom,
                                            titleEdgeInsetsRight);
}


+ (instancetype)lk_BackButton
{
    UIButton *button = [[self alloc] initWithFrame:CGRectMake(0, 0, 55, 25)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"title_icon_back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"title_icon_back_h"] forState:UIControlStateHighlighted];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0,0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    return button;
}
@end
