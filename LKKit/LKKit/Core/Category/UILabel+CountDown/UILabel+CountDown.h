//
//  UILabel+CountDown.h
//  Live
//
//  Created by Heller on 16/5/25.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CountDown)

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 */
- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
           completion:(void (^)(void))completion;
@end
