//
//  NSTimer+Addition.m
//  TTClub
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)
-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}


- (BOOL)isPause{
    
    if ([self.fireDate isEqualToDate:[NSDate distantFuture]]){
        return YES;
    }else{
        return NO;
    }
}
@end
