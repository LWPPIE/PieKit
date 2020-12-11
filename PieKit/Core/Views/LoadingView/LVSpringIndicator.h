//
//  LVSpringIndicator.h
//  Live
//
//  Created by RoyLei on 16/7/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVSpringIndicator : UIView

@property (assign, nonatomic) NSTimeInterval rotateDuration;
@property (assign, nonatomic) NSTimeInterval strokeDuration;
@property (strong, nonatomic) UIColor * lineColor;
@property (assign, nonatomic) NSInteger lineWidth;

@property (copy, nonatomic) void(^stopAnimationsHandler)(LVSpringIndicator *indicator);
@property (copy, nonatomic) void(^intervalAnimationsHandler)(LVSpringIndicator *indicator);

- (void)startAnimation:(BOOL)expand;
- (void)stopAnimation:(BOOL)waitAnimation completion:(void(^)())completion;
@end
