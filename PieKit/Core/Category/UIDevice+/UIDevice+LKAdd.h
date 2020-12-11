//
//  UIDevice+LKAdd.h
//  Pods
//
//  Created by Heller on 16/9/2.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (LKAdd)
/**
 *  比iPhone5s旧的设备,性能比较差,需要做降低码率等额外处理
 *
 *  @return 如果比5s老的设备,返回YES
 */
+ (BOOL)isOlderThaniPhone5s;

/**
 *
 *
 *  @return 如果比iPhone6新的设备,返回YES
 */
+ (BOOL)isNewThaniPhone6;

/**
 *  获取所有CPU的占用率
 *
 *  @return CPU占用率
 */
+ (float)getCPUUsage;

@end
