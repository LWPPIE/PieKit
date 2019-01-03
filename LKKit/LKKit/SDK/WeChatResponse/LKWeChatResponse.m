//
//  WXApiManager.m
//  MicroCircleLibrary
//
//  Created by 唐开福 on 17/12/9.
//  Copyright © 2015年 唐开福. All rights reserved.
//

#import "LKWeChatResponse.h"
#import "WXApiObject.h"

@interface LKWeChatResponse()

@property (nonatomic, strong) NSMutableSet<NSValue *> *observers;

@end

@implementation LKWeChatResponse

static LKWeChatResponse *_instance;

#pragma mark - LKResponseProtocol

+ (void)registerApp:(NSString *)appId
{
    [WXApi registerApp:appId enableMTA:YES];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKWeChatResponse alloc] init];
    });
}

+ (instancetype)sharedManager
{
    return _instance;
}

- (void)login
{
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if(self) {
        
        _observers = [NSMutableSet set];
    }
    return self;
}

- (void)pay:(PayReq *)req
{
    // 调起微信支付
    [WXApi registerApp:req.openID];
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
}

- (void)onResp:(BaseResp *)response
{
    if ([response isKindOfClass:[SendAuthResp class]]){
        
        @synchronized (_observers) {
            [self.observers enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
                
                id<LKWeChatResponseProtocol> observer = obj.nonretainedObjectValue;
                if(observer && [observer respondsToSelector:@selector(didReceiveWeChatAuthResponse:)]) {
                    [observer didReceiveWeChatAuthResponse:(SendAuthResp *)response];
                }
            }];
        }
        
    }else if ([response isKindOfClass:[PayResp class]]) {
        
        @synchronized (_observers) {
            [self.observers enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
                
                id<LKWeChatResponseProtocol> observer = obj.nonretainedObjectValue;
                if(observer && [observer respondsToSelector:@selector(didReceiveWeChatPayResponse:)]) {
                    [observer didReceiveWeChatPayResponse:(PayResp *)response];
                }
            }];
        }
        
    }else if ([response isKindOfClass:[SendMessageToWXResp class]]) {
        
        @synchronized (_observers) {
            [self.observers enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
                
                id<LKWeChatResponseProtocol> observer = obj.nonretainedObjectValue;
                if(observer && [observer respondsToSelector:@selector(didReceiveWeChatShareResponse:)]) {
                    [observer didReceiveWeChatShareResponse:(SendMessageToWXResp *)response];
                }
            }];
        }
    }
}

#pragma mark - Observer

- (void)registerObserver:(id <LKWeChatResponseProtocol>)observer
{
    @synchronized (_observers) {
        NSValue *value = [NSValue valueWithNonretainedObject:observer];
        if (![_observers containsObject:value]) {
            [_observers addObject:value];
        };
    }
}

- (void)removeObserver:(id <LKWeChatResponseProtocol>)observer
{
    @synchronized (_observers) {
        NSValue *value = [NSValue valueWithNonretainedObject:observer];
        if([_observers containsObject:value]) {
            [_observers removeObject:value];
        }
    }
}
@end
