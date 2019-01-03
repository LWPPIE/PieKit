#LakaTV UI Tools


#####备注

```
 如果不需要QQResponse/WeChatResponse
 需要到LKKit.podspec文件中对应的模块的描述给注释,可以减少App包的大小。
 
  s.subspec 'XXXXX' do |ss|
    .......
  end
```

###使用QQResponse（V3.3.0）

- 第一步

```
[LKQQResponse registerApp:QQKEY];
```

- 第二步

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [QQApiInterface handleOpenURL:url delegate:[LKQQResponse sharedManager];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [QQApiInterface handleOpenURL:url delegate:[LKQQResponse sharedManager];
}

```

###使用WeChatResponse（V1.8.1）

- 第一步

```
[LKWeChatResponse registerApp:kSDKWeixinKey];

```

- 第二步

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:[LKWeChatResponse sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [WXApi handleOpenURL:url delegate:[LKWeChatResponse sharedManager]];
}
```



