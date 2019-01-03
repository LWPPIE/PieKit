//
//  LSYConstance.h
//  TTClub
//
//  Created by RoyLei on 15/12/2.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSInteger const LKQueryDefaultCount;
UIKIT_EXTERN NSInteger const LKQueryDefaultFirstPage;
UIKIT_EXTERN NSString * const LKQueryDefaultEndId;

UIKIT_EXTERN NSInteger const LSYKeyBoardBarViewHeight;
UIKIT_EXTERN NSInteger const LSYNavBarHeight;
UIKIT_EXTERN NSInteger const LSYStatusHeight;
UIKIT_EXTERN NSInteger const LSYTabBarHeight;

UIKIT_EXTERN NSString * const LKCacheDocumentName;
UIKIT_EXTERN NSString * const LKMinePrivateMessageReadKey;
UIKIT_EXTERN NSString * const LKGoodsPrivateMessageReadKey;

#pragma mark - 

static inline BOOL TTObjectIsNil(id obj) {
    return (obj ? NO : YES);
};
static inline NSString * TTStringNotNil(NSString *string) {
    return (string ? string : @"");
};
static inline NSString * TTStringNilToZero(NSString *string) {
    if (!string) {
        string = @"0";
        return string;
    }
    return string;
};

/**
 本地化显示字符串
 
 @param str 要本地化显示的字符串
 */
static inline NSString *LKLocalizedString(NSString *str){
    return NSLocalizedString(str, nil);
}

#pragma mark - UIFont

static inline UIFont *LKFZCYFont(CGFloat fontSize) {
    
     UIFont *font = [UIFont fontWithName:@"FZCuYuan-M03" size:fontSize];
    if(font == nil) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

static inline UIFont * LKFont(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

static inline UIFont * LKBoldFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark - Image


/**
 判断是不是有折扣

 @param discount 折扣
 */
static inline BOOL LKHaveDiscount(float discount)
{
    if(discount >= 0) {
        return fabs(discount - 10.0) > 0.001;
    }else {
        return NO;
    }
}

#pragma mark - Color

static inline UIColor *LKColorRGB(CGFloat r, CGFloat g, CGFloat b) {
    
    return [UIColor colorWithRed:r / 255.00 green:g / 255.00 blue:b / 255.00 alpha:1.0];
}

static inline UIColor *LKColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat alpha) {
    
    return [UIColor colorWithRed:r / 255.00 green:g / 255.00 blue:b / 255.00 alpha:alpha];
}

#pragma mark - Image

static inline UIImage *LKImage(NSString *imageName) {
    if (!imageName || [imageName isEqualToString:@""]) {
        return nil;
    }
    return [UIImage imageNamed:imageName];
}

static inline UIImage *LKImageWithAlpha(UIImage *image, CGFloat alpha) {
    
    if(image == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

static inline UIImage *LKImageNameWithAlpha(NSString *imageName, CGFloat alpha) {
    if (!imageName || [imageName isEqualToString:@""]) {
        return nil;
    }
    return LKImageWithAlpha(LKImage(imageName), alpha);
}

#pragma mark - 快捷适配函数

static inline UIImage *TTImage(NSString *imageName) {
    if (!imageName || [imageName isEqualToString:@""]) {
        return nil;
    }
    return [UIImage imageNamed:imageName];
}

static inline CGFloat LKCGRectGetMaxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

static inline CGFloat LKCGRectGetMaxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
};

static inline UIFont *LKUIFont(CGFloat fontSize) {
    return  [UIFont systemFontOfSize:fontSize];
};

static inline NSString *LKAppShortVersion() {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersionStr;
}

static inline NSDictionary *LKParseURLQueryToDict(NSURL *reqUrl) {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (NSString *param in [reqUrl.query componentsSeparatedByString:@"&"]) {
        @autoreleasepool {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts lastObject] forKey:[elts firstObject]];
        }
    }
    
    return params;
}

static inline NSString *LKCacheDefaultPath()
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:LKCacheDocumentName];
    return path;
}

static inline NSString *LKLibraryDefaultPath()
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:LKCacheDocumentName];
    return path;
}

/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloat(NSArray *plist);

/**
 *  适配4/4s、5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@7,@10,@20,@30])
 *  @return 对应浮点数，例如(@[@7,@10,@20,@30])4/4s返回的是7 5返回10，6返回20，6P返回30; (@[@10,@20) 4s/5返回10，6和6P返回20; (@[@10])4、5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloatWith4s(NSArray * plist);
/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，字体大小依次是多少例如(@[@10,@20,@30])、(@[@10,@20)、(@[@10])
 *  @return 返回对应字体大小,(@[@10,@20,@30])5返回10号字体，6返回20号字体，6P返回30号字体; (@[@10,@20) 5返回10号字体，6和6P返回20号字体; (@[@10])5、6、6P都返回10号字体。
 */
FOUNDATION_EXPORT UIFont *g_fitSystemFontSize(NSArray *plist);


FOUNDATION_EXPORT CGFloat g_fitScareOfIphone6(CGFloat f);

/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloat(NSArray *plist);

FOUNDATION_EXPORT UIColor *UIColorWithHexAndAlpha(long hexColor, float opacity);
FOUNDATION_EXPORT UIColor *UIColorWithHex(long hexColor);
FOUNDATION_EXPORT UIColor *UIColorHexAndAlpha(long hexColor, float opacity);

/**
 *  生成对应的MD5 字符串
 *
 *  @param key 要计算MD5的字符串
 *
 *  @return 返回生成后的MD5
 */
FOUNDATION_EXPORT inline NSString *makeMD5StringForKey(NSString *key);

#ifdef TTClubNeedStatisticesLog
FOUNDATION_EXPORT void TTClubStatisticesLog(NSString *format, ...);
FOUNDATION_EXPORT void TTClubLog(TTClubLogLevel level, NSString *format, ...);
#endif

FOUNDATION_EXPORT NSString *LKDeviceModelName(void);
FOUNDATION_EXPORT BOOL LKIsiPhone6sAbove(void);


