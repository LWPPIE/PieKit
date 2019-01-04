//
//  NSTimer+Addition.h
//  TTClub
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

- (BOOL)isPause;

@end
