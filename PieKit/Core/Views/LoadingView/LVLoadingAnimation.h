//
//  LVLoaingAnimation.h
//  Live
//
//  Created by RoyLei on 16/7/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LVLoadingLineType) {
    LVLoadingLineTypeSmall = 0,
    LVLoadingLineTypeBig = 1,
};

@interface LVLoadingAnimation : NSObject

@property (strong, nonatomic, readonly) NSArray <CALayer *>*layers;
@property (assign, nonatomic, readonly) BOOL isLoading; /**< 正在显示加载 */

@property (assign, nonatomic) LVLoadingLineType lineType;
@property (strong, nonatomic) UIColor *lineColor;

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;

- (void)startAnimation;

- (void)startAnimationHaveBeginAnimation;

- (void)stopAnimation;

@end
