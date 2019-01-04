//
//  LKWeChatResponse.h
//  MicroCircleLibrary
//
//  Created by 唐开福 on 17/12/9.
//  Copyright © 2015年 唐开福. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol LKWeChatResponseProtocol<NSObject>

@optional
/**
 收到微信的分享回调
 */
- (void)didReceiveWeChatShareResponse:(SendMessageToWXResp *)response;

/**
 收到微信的支付回调
 */
- (void)didReceiveWeChatPayResponse:(PayResp *)response;

/**
 收到微信授权的登录回调
 */
- (void)didReceiveWeChatAuthResponse:(SendAuthResp *)response;

@end


@interface LKWeChatResponse : NSObject<WXApiDelegate>

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
- (void)registerObserver:(id<LKWeChatResponseProtocol>)observer;

/**
 移除监听者
 */
- (void)removeObserver:(id<LKWeChatResponseProtocol>)observer;

/**
 *  微信支付
 *
 *  @param req 订单信息字符串
 */
- (void)pay:(PayReq *)req;

@end

