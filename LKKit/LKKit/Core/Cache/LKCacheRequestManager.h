//
//  LKCacheRequestManager.h
//  Socket
//
//  Created by 唐开福 on 2017/6/23.
//  Copyright © 2017年 LAKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYCache.h>

@interface LKCacheRequestManager : YYCache

+ (instancetype)sharedInstance;

/**
 缓存服务器响应的数据
 
 @param respond 响应的数据(直接缓存服务器返回的NSDictionary)
 @param url 对应的url
 @param parameters 请求参数
 */
+ (void)setRespond:(id)respond
              url:(NSString *)url
       parameters:(NSDictionary *)parameters;

/**
 获取缓存的数据
 
 @param url 对应的url
 @param parameters 请求参数
 */
+ (id)respondForUrl:(NSString *)url
         parameters:(NSDictionary *)parameters;

#pragma mark - remove

/**
 删除缓存的数据
 
 @param url 对应的url
 @param parameters 请求参数
 */
+ (void)removeRepondForUrl:(NSString *)url
                parameters:(NSDictionary *)parameters;

/**
 删除缓存的数据,这个url对应的所有数据
 
 @param url 对应的url
 */
+ (void)removeRepondForUrl:(NSString *)url;

/**
 删除所有的缓存的数据
 */
+ (void)removeAllRepondCache;

/**
 缓存数组

 @param array 需要缓存的数组
 @param key 取出的时候需要的key
 */
+ (void)setModelArray:(NSArray *)array forKey:(NSString *)key;


/**
 取出模型数组

 @param cls 模型的类型
 @param key 取出的时候需要的key
 @return 缓存的数据
 */
+ (NSArray *)modelArrayWithClass:(Class)cls forKey:(NSString *)key;
@end
