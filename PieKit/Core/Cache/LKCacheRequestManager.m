//
//  LKCacheRequestManager.m
//  Socket
//
//  Created by 唐开福 on 2017/6/23.
//  Copyright © 2017年 LAKA. All rights reserved.
//

#import "LKCacheRequestManager.h"
#import "NSString+YYAdd.h"
#import "NSObject+YYModel.h"

static NSString *const LKQueyCacheDirName = @"com.laka.cache.quey";

static inline NSString *LKQueyCacheDefaultPath()
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:LKQueyCacheDirName];
    return path;
}

@implementation LKCacheRequestManager

+ (instancetype)sharedInstance
{
    static LKCacheRequestManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithPath:LKQueyCacheDefaultPath()];
    });
    return _instance;
}

#pragma mark - setRespond

+ (void)setRespond:(id)respond
               url:(NSString *)url
        parameters:(NSDictionary *)parameters
{
    [[self sharedInstance] setRespond:respond
                                  url:url
                           parameters:parameters];
}

- (void)setRespond:(id)respond
               url:(NSString *)url
        parameters:(NSDictionary *)parameters
{
    NSArray *array = (NSArray *)[self objectForKey:url];
    // 这个array存放着这个url下所有缓存数据的key
    NSMutableArray *cacheUrlParameters = [[NSMutableArray alloc] init];
    if(array != nil)
    {
        [cacheUrlParameters addObjectsFromArray:array];
    }
    NSString *key = [self keyForURL:url parameters:parameters];
    [cacheUrlParameters addObject:key];

    [self setObject:respond forKey:key];
    [self setObject:cacheUrlParameters forKey:url];
}

#pragma mark - getRespond

+ (id)respondForUrl:(NSString *)url
         parameters:(NSDictionary *)parameters
{
    return [[self sharedInstance] respondForUrl:url
                                     parameters:parameters];
}

- (id)respondForUrl:(NSString *)url
         parameters:(NSDictionary *)parameters
{
    NSString *key = [self keyForURL:url
                         parameters:parameters];
    return [self objectForKey:key];
}

#pragma mark - remove

+ (void)removeRepondForUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
{
    [[self sharedInstance] removeRepondForUrl:url
                                   parameters:parameters];
}

- (void)removeRepondForUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
{
    NSString *key = [self keyForURL:url
                         parameters:parameters];
    [self removeObjectForKey:key];
}

+ (void)removeRepondForUrl:(NSString *)url
{
    [[self sharedInstance] removeRepondForUrl:url];
}

- (void)removeRepondForUrl:(NSString *)url
{
    NSArray *array = (NSArray *)[self objectForKey:url];
    // 这个array存放着这个url下所有缓存数据的key
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObjectForKey:obj];
    }];
    [self removeObjectForKey:url];
}

+ (void)removeAllRepondCache
{
    [[self sharedInstance] removeAllRepondCache];
}

- (void)removeAllRepondCache
{
    [self removeAllObjects];
}

#pragma mark - private
/**
 根据参数和和url生成对应的key
 */
- (NSString *)keyForURL:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSArray *keySortArray = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *keyString = [NSMutableString string];
    [keyString appendString:url];
    [keyString appendString:@"?"];
    [keySortArray enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = parameters[key];
        [keyString appendFormat:@"%@=%@?", key, value];
    }];
    return [keyString md5String];
}

+ (void)setModelArray:(NSArray *)array forKey:(NSString *)key
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSString class]]) {
            [mutableArray addObject:obj];
        }else {
            id jsonObject = [obj modelToJSONObject];
            [mutableArray addObject:jsonObject];
        }
    }];
    [[self sharedInstance] setObject:mutableArray forKey:key];
}

+ (nullable NSArray *)modelArrayWithClass:(Class)cls forKey:(NSString *)key
{
    id json = [[self sharedInstance] objectForKey:key];
    return [NSArray modelArrayWithClass:cls json:json];
}
@end
