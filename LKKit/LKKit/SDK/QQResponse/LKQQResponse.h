//
//  QQApiManager.h
//  Live
//
//  Created by 唐开福 on 17/12/9.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@class QQBaseResp;

@protocol LKQQResponseProtocol<NSObject>
@optional

/**
 收到QQ的分享回调
 */
- (void)didReceiveQQShareResponse:(QQBaseResp *)response;

/**
 收到QQ的登录回调
 */
- (void)didReceiveQQAuthResponse:(NSString *)accessToken openId:(NSString *)openId;

@end


@interface LKQQResponse : NSObject<QQApiInterfaceDelegate>

/**
 注册App
 */
+ (void)registerApp:(NSString *)appId;

/**
 获取单例
 */
+ (instancetype)sharedManager;

/**
 登录
 */
- (void)login;

/**
 注册监听者
 */
- (void)registerObserver:(id<LKQQResponseProtocol>)observer;

/**
 移除监听者
 */
- (void)removeObserver:(id<LKQQResponseProtocol>)observer;

@end
