//
//  LSYConstance.m
//  TTClub
//
//  Created by RoyLei on 15/12/2.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "LSYConstance.h"
#import "LKMacros.h"
#import "NSDate+Utilities.h"
#import "UIDevice+YYAdd.h"
#import <CommonCrypto/CommonCrypto.h>
#import <sys/utsname.h>

NSString * const LKCacheDocumentName = @"com.laka.taste";
NSString * const LKMinePrivateMessageReadKey = @"LKMinePrivateMessageReadKey";
NSString * const LKGoodsPrivateMessageReadKey = @"LKGoodsPrivateMessageReadKey";

#pragma mark - Common

NSInteger const LKQueryDefaultCount = 20;
NSInteger const LKQueryDefaultFirstPage = 0;

NSString * const LKQueryDefaultEndId    = @"0";

#pragma mark - 首页
NSInteger const LSYKeyBoardBarViewHeight       = 44;
NSInteger const LSYNavBarHeight                = 64;
NSInteger const LSYStatusHeight                = 20;
NSInteger const LSYTabBarHeight                = 49;

inline NSString *makeMD5StringForKey(NSString *key)
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

inline UIColor *UIColorWithHex(long hexColor)
{
    return UIColorWithHexAndAlpha(hexColor, 1.f);
}

inline UIColor *UIColorWithHexAndAlpha(long hexColor, float opacity)
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

inline UIColor *UIColorHexAndAlpha(long hexColor, float opacity)
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}


/**
 *  适配5、6、6P~尺寸
 *
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
inline CGFloat g_fitFloat(NSArray *plist)
{
    CGFloat f = 0.0f;
    
    if (plist.count) {
        switch (plist.count) {
            case 1:
            {
                f = [[plist firstObject] floatValue];
            }
                break;
            case 2:
            {
                f = (IS_IPHONE_6 || IS_IPHONE_X) ? [plist[1] floatValue]:[plist[0] floatValue];
                f = IS_IPHONE_6P? [plist[1] floatValue]:f;
            }
                break;
            case 3:
            {
                f = (IS_IPHONE_6 || IS_IPHONE_X) ? [plist[1] floatValue]:[plist[0] floatValue];
                f = IS_IPHONE_6P? [plist[2] floatValue]:f;
            }
                break;
                
            case 4:
            {
                f = [[plist firstObject] floatValue];
                f = IS_IPHONE_6 ? [plist[1] floatValue]:f;
                f = IS_IPHONE_6P ? [plist[2] floatValue]:f;
                f = (IS_IPHONE_Xr || IS_IPHONE_X ||IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? [plist[3] floatValue]:f;
            }
                break;
            case 5:
            {
                f = [[plist firstObject] floatValue];
                f = IS_IPHONE_6 ? [plist[1] floatValue]:f;
                f = IS_IPHONE_6P ? [plist[2] floatValue]:f;
                f = IS_IPHONE_X ? [plist[3] floatValue]:f;
                f = (IS_IPHONE_Xr ||IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? [plist[4] floatValue]:f;
            }
                break;
            case 6:
            {
                f = [[plist firstObject] floatValue];
                f = IS_IPHONE_6 ? [plist[1] floatValue]:f;
                f = IS_IPHONE_6P ? [plist[2] floatValue]:f;
                f = IS_IPHONE_X ? [plist[3] floatValue]:f;
                f = IS_IPHONE_Xr ? [plist[4] floatValue]:f;
                f = (IS_IPHONE_Xs||IS_IPHONE_Xs_Max) ? [plist[5] floatValue]:f;
            }
                break;
            case 7:
            {
                f = [[plist firstObject] floatValue];
                f = IS_IPHONE_6 ? [plist[1] floatValue]:f;
                f = IS_IPHONE_6P ? [plist[2] floatValue]:f;
                f = IS_IPHONE_X ? [plist[3] floatValue]:f;
                f = IS_IPHONE_Xr ? [plist[4] floatValue]:f;
                f = IS_IPHONE_Xs ? [plist[5] floatValue]:f;
                f = IS_IPHONE_Xs_Max ? [plist[6] floatValue]:f;
            }
            default:
                break;
        }
    }
    
    return f;
}
/**
 *  适配4/4s、5、6、6P~尺寸
 *
 *  @param plist 参数列表，尺寸依次是多少例如(@[@7,@10,@20,@30])
 *
 *  @return 对应浮点数，例如(@[@7,@10,@20,@30])4/4s返回的是7 5返回10，6返回20，6P返回30; (@[@10,@20) 4s/5返回10，6和6P返回20; (@[@10])4、5、6、6P都返回10。
 */
inline CGFloat g_fitFloatWith4s(NSArray * plist){
    
    CGFloat f = 0.0f;
    
    if(plist.count){
        switch (plist.count) {
            case 1:
            {
                f = [[plist firstObject] floatValue];
                
            }
                break;
                
            case 2:
            {
                
                f = IS_IPHONE_4and5 ? [plist[0] floatValue] : f;
                f = (IS_IPHONE_6 || IS_IPHONE_X || IS_IPHONE_6P) ? [plist[1] floatValue]:f;
                
            }
                break;
                
            case 3:
            {
                f = IS_IPHONE_4and5 ? [plist[0] floatValue] : f;
                f = (IS_IPHONE_6 || IS_IPHONE_X) ?     [plist[1] floatValue] : f;
                f = IS_IPHONE_6P ?    [plist[2] floatValue] : f;
                
            }
                break;
                
            case 4:
            {
                f = IS_IPHONE_4 ?  [plist[0] floatValue] : f;
                f = IS_IPHONE_5 ?  [plist[1] floatValue] : f;
                f = (IS_IPHONE_6 || IS_IPHONE_X) ?  [plist[2] floatValue] : f;
                f = IS_IPHONE_6P ? [plist[3] floatValue] : f;
            }
                break;
                
            default:
                break;
        }
    }

    return  f;
}

/**
 *  适配ihone4, 5, 6, 6p, 以6的宽度为标准, 根据屏幕的比例进行缩放
 *
 *  @return 对应的屏幕的
 */
inline CGFloat g_fitScareOfIphone6(CGFloat f)
{
    
    CGFloat length = f;
    
    if(IS_IPHONE_6 || IS_IPHONE_X){
        return length;
    }else if (IS_IPHONE_6P){
        
        return ceilf(length * 414.0 / 375.0);
        
    }else if(IS_IPHONE_4and5){
        
        return ceilf(length * 320.0 / 375.0);
    }
    
    return ceilf(f);
}

/**
 *  适配5、6、6P~尺寸
 *
 *  @param plist 参数列表，字体大小依次是多少例如(@[@10,@20,@30])、(@[@10,@20)、(@[@10])
 *
 *  @return 返回对应字体大小,(@[@10,@20,@30])5返回10号字体，6返回20号字体，6P返回30号字体; (@[@10,@20) 5返回10号字体，6和6P返回20号字体; (@[@10])5、6、6P都返回10号字体。
 */
inline UIFont *g_fitSystemFontSize(NSArray *plist)
{
    return [UIFont systemFontOfSize:g_fitFloat(plist)];
}


#ifdef TTClubNeedStatisticesLog

void TTClubStatisticesLog(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *logStr = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if([logStr hasPrefix:@"【统计输出】："]) {
        
//#ifdef LKUseTestEnv
        //NSString *uploadMassage = [NSString stringWithFormat:@"%@ %@",[UserInfoModel defaultModel].devid, logStr];
        //[SLSYJsonRequestBundleSelfManager uploadLogMassageToPrintUnderWebView:uploadMassage];
//#endif
        
        logStr = [[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] stringByAppendingString:logStr];

        TTClubLog(TTClubLogLevelDebugInfo, @"%@",  logStr);
        
        if (nil == TTClubDocumentsDirectory) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            TTClubDocumentsDirectory = [[paths objectAtIndex:0] copy];
        }
        
        if (nil == TTClubStatisticesLogFilePath) {
            TTClubStatisticesLogFilePath = [TTClubDocumentsDirectory stringByAppendingPathComponent:TTClubStatisticesLogFileName];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:TTClubStatisticesLogFilePath]) {
            [logStr writeToFile:TTClubStatisticesLogFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:TTClubStatisticesLogFilePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
    }
}

void TTClubLog(TTClubLogLevel level, NSString *format, ...)
{
    if (level <= TTPrintLogLevel) {
        va_list args;
        va_start(args, format);
        NSString *logStr = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSLog(@"%@",  logStr);
    }
}

#endif

NSString *LKDeviceModelName(void)
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

BOOL LKIsiPhone6sAbove(void)
{
    NSString *deviceModel = [UIDevice currentDevice].machineModel;
    
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return NO;
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return NO;
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return NO;
    if ([deviceModel isEqualToString:@"iPod2,1"])      return NO;
    if ([deviceModel isEqualToString:@"iPod3,1"])      return NO;
    if ([deviceModel isEqualToString:@"iPod4,1"])      return NO;
    if ([deviceModel isEqualToString:@"iPod5,1"])      return NO;
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return NO;
    
    return YES;
}
