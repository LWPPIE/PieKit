//
//  LKCacheManager.h
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <YYKit/YYCache.h>

FOUNDATION_EXPORT NSString *const LKSearchHistoryRecordKey;     // 搜索历史存储键
FOUNDATION_EXPORT NSString *const LKHomeListReqParamsRecordKey; // 首页浏览键值储键

typedef NS_ENUM(NSInteger, LKCacheManagerType) {
    LKCacheManagerTypeVideo = 0,    /**< 视频下载信息缓存 */
    LKCacheManagerTypeUserData = 1, /**< 用户数据缓存, 搜索历史记录缓存 */
    LKCacheManagerTypeComment = 2,  /**< 存储用户输入的文字 */
    LKCacheManagerTypeCanClean = 3, /**< 可清除的缓存 */
};

@class LKCacheManager;
@interface LKCacheFactory : NSObject

/**
 单例
 
 @return LKCacheManager 单列对象
 */
+ (instancetype)sharedInstance;

/**
 获取对应的缓存信息
 
 @param type 缓存类型
 @return 返回对应的缓存管理类
 */
+ (LKCacheManager *)cacheManger:(LKCacheManagerType)type;

/**
 清理缓存
 */
+ (void)cleanCacheDir;

@property (copy, nonatomic) NSString *buriedPointPage; /**<首页埋点标示>*/

@end

static inline LKCacheManager *LKUserDataCache()
{
    return [LKCacheFactory cacheManger:LKCacheManagerTypeUserData];
}

static inline LKCacheManager *LKCanCleanCache()
{
    return [LKCacheFactory cacheManger:LKCacheManagerTypeCanClean];
}

#pragma mark - Class LKCacheManager

/**
 缓存管理Key-Value 形式存储管理类
 */
@interface LKCacheManager : YYCache

/**
 获取对应尺寸placeHolder图

 @param size 对应尺寸
 @return UIImage
 */
- (UIImage *)placeHolderWithSize:(CGSize)size;

/**
 获取上次视频视频播放记录，如果没有则为0

 @param videoUrl 视频URL地址
 @return 播放时间
 */
+ (NSTimeInterval)videoLastPlayTime:(NSString *)videoUrl;

/**
 设置上一次播放时间，在暂停、退出播放时

 @param lastPlayTime 上一次播放时间
 @param videoUrl 视频URL地址
 */
+ (void)setVideoLastPlayTime:(NSTimeInterval)lastPlayTime videoUrl:(NSString *)videoUrl;

@end

