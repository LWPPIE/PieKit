//
//  QQApiManager.m
//  Live
//
//  Created by 唐开福 on 17/12/9.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LKQQResponse.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


@interface LKQQResponse()<TencentLoginDelegate,TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSMutableSet<NSValue *> *observers;

@end

@implementation LKQQResponse

static LKQQResponse *_instance;

#pragma mark - LKResponseProtocol

+ (void)registerApp:(NSString *)appId
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKQQResponse alloc] initWithAppId:appId];
    });
}

+ (instancetype)sharedManager
{
    return _instance;
}

- (void)login
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [self.tencentOAuth authorize:permissions inSafari:YES];
}

- (instancetype)initWithAppId:(NSString *)appId
{
    self = [super init];
    if(self) {
        
        _observers = [NSMutableSet set];
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
    }
    return self;
}

#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin
{   
    NSString *accessToken = self.tencentOAuth.accessToken;
    NSString *openId = self.tencentOAuth.openId;
    
    if (accessToken.length > 0) {
        
        @synchronized (_observers) {
            [self.observers enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
                
                id<LKQQResponseProtocol> observer = obj.nonretainedObjectValue;
                if(observer && [observer respondsToSelector:@selector(didReceiveQQAuthResponse:openId:)]) {
                    [observer didReceiveQQAuthResponse:accessToken openId:openId];
                }
            }];
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
}

- (void)tencentDidNotNetWork
{
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req
{
}

- (void)isOnlineResponse:(NSDictionary *)response
{
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    @synchronized (_observers) {
        [self.observers enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
            
            id<LKQQResponseProtocol> observer = obj.nonretainedObjectValue;
            if(observer && [observer respondsToSelector:@selector(didReceiveQQShareResponse:)]) {
                [observer didReceiveQQShareResponse:resp];
            }
        }];
    }
}

#pragma mark - Observer

- (void)registerObserver:(id<LKQQResponseProtocol>)observer
{
    @synchronized (_observers) {
        NSValue *value = [NSValue valueWithNonretainedObject:observer];
        if (![_observers containsObject:value]) {
            [_observers addObject:value];
        };
    }
}

- (void)removeObserver:(id<LKQQResponseProtocol>)observer
{
    @synchronized (_observers) {
        NSValue *value = [NSValue valueWithNonretainedObject:observer];
        if([_observers containsObject:value]) {
            [_observers removeObject:value];
        }
    }
}

@end
