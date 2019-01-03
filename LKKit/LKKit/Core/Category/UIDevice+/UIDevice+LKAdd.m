//
//  UIDevice+LKAdd.m
//  Pods
//
//  Created by Heller on 16/9/2.
//
//

#import "UIDevice+LKAdd.h"

#import <mach/mach.h>
#import <sys/utsname.h>


@implementation UIDevice (LKAdd)

+ (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

//
//@"iPad1,1" : @"iPad 1",
//@"iPad2,1" : @"iPad 2 (WiFi)",
//@"iPad2,2" : @"iPad 2 (GSM)",
//@"iPad2,3" : @"iPad 2 (CDMA)",
//@"iPad2,4" : @"iPad 2",
//@"iPad2,5" : @"iPad mini 1",
//@"iPad2,6" : @"iPad mini 1",
//@"iPad2,7" : @"iPad mini 1",
//@"iPad3,1" : @"iPad 3 (WiFi)",
//@"iPad3,2" : @"iPad 3 (4G)",
//@"iPad3,3" : @"iPad 3 (4G)",
//@"iPad3,4" : @"iPad 4",
//@"iPad3,5" : @"iPad 4",
//@"iPad3,6" : @"iPad 4",
//@"iPad4,1" : @"iPad Air",
//@"iPad4,2" : @"iPad Air",
//@"iPad4,3" : @"iPad Air",
//@"iPad4,4" : @"iPad mini 2",
//@"iPad4,5" : @"iPad mini 2",
//@"iPad4,6" : @"iPad mini 2",
//@"iPad4,7" : @"iPad mini 3",
//@"iPad4,8" : @"iPad mini 3",
//@"iPad4,9" : @"iPad mini 3",
//@"iPad5,1" : @"iPad mini 4",
//@"iPad5,2" : @"iPad mini 4",
//@"iPad5,3" : @"iPad Air 2",
//@"iPad5,4" : @"iPad Air 2",
//@"iPad6,3" : @"iPad Pro (9.7 inch)",
//@"iPad6,4" : @"iPad Pro (9.7 inch)",
//@"iPad6,7" : @"iPad Pro (12.9 inch)",
//@"iPad6,8" : @"iPad Pro (12.9 inch)",
//
//@"AppleTV2,1" : @"Apple TV 2",
//@"AppleTV3,1" : @"Apple TV 3",
//@"AppleTV3,2" : @"Apple TV 3",
//@"AppleTV5,3" : @"Apple TV 4",
//
//@"Watch1,1" : @"Apple Watch",
//@"Watch1,2" : @"Apple Watch",
//
//@"iPod1,1" : @"iPod touch 1",
//@"iPod2,1" : @"iPod touch 2",
//@"iPod3,1" : @"iPod touch 3",
//@"iPod4,1" : @"iPod touch 4",
//@"iPod5,1" : @"iPod touch 5",
//@"iPod7,1" : @"iPod touch 6",
//
//@"iPhone1,1" : @"iPhone 1G",
//@"iPhone1,2" : @"iPhone 3G",
//@"iPhone2,1" : @"iPhone 3GS",
//@"iPhone3,1" : @"iPhone 4 (GSM)",
//@"iPhone3,2" : @"iPhone 4",
//@"iPhone3,3" : @"iPhone 4 (CDMA)",
//@"iPhone4,1" : @"iPhone 4S",
//@"iPhone5,1" : @"iPhone 5",
//@"iPhone5,2" : @"iPhone 5",
//@"iPhone5,3" : @"iPhone 5c",
//@"iPhone5,4" : @"iPhone 5c",
//@"iPhone6,1" : @"iPhone 5s",
//@"iPhone6,2" : @"iPhone 5s",
//@"iPhone7,1" : @"iPhone 6 Plus",
//@"iPhone7,2" : @"iPhone 6",
//@"iPhone8,1" : @"iPhone 6s",
//@"iPhone8,2" : @"iPhone 6s Plus",
//@"iPhone8,4" : @"iPhone SE",
#pragma mark -- DeviceCategory
+ (BOOL)isOlderThaniPhone5s {
    NSString *device = [self deviceName];
//    NSLog(@"device %@", device);
    if (device == nil) {
        return NO;
    }
    NSArray *array = [device componentsSeparatedByString:@","];
    if (array.count < 2) {
        return NO;
    }
    NSString *model = [array objectAtIndex:0];
//    NSLog(@"model %@", model);
    if ([model hasPrefix:@"iPhone"]) {
        NSString *str1 = [model substringFromIndex:[@"iPhone" length]];
        NSUInteger num = [str1 integerValue];
//        NSLog(@"num %lu", (unsigned long)num);
        if (num < 6) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isNewThaniPhone6 {
    NSString *device = [self deviceName];
//    NSLog(@"device %@", device);
    if (device == nil) {
        return NO;
    }
    NSArray *array = [device componentsSeparatedByString:@","];
    if (array.count < 2) {
        return NO;
    }
    NSString *model = [array objectAtIndex:0];
//    NSLog(@"model %@", model);
    if ([model hasPrefix:@"iPhone"]) {
        NSString *str1 = [model substringFromIndex:[@"iPhone" length]];
        NSUInteger num = [str1 integerValue];
        NSLog(@"num %lu", (unsigned long)num);
        if (num > 7) {
            return YES;
        }
    }
    
    if ([model hasPrefix:@"iPad"]) {
        NSString *str1 = [model substringFromIndex:[@"iPad" length]];
        NSUInteger num = [str1 integerValue];
        if (num > 4) {
            return YES;
        }
    }
    
    return NO;
}

// 获取CPU使用率
+ (float)getCPUUsage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
