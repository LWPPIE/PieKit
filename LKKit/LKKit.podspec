
Pod::Spec.new do |s|

  s.name = 'LKKit'
  s.summary = "LaKaTV local Kit"
  s.homepage = "http://lakatv.com"
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author = { "RoyLei" => "redwarly@gmail.com" }
  s.version = '0.0.1'
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.source = { :path => ".", :tag => "0.0.1" }
  s.source_files = 'LKKit/Core/*.{h,m}','LKKit/Core/**/*.{h,m}','LKKit/Core/**/**/*.{h,m}'
  s.resource     = 'LKKit/Resource/LSYAlertView.bundle','LKKit/Resource/LKImages.bundle'
  s.frameworks = 'UIKit'
  
  s.dependency 'Masonry'
  s.dependency 'YYKit'
  s.dependency 'CAAnimationBlocks'
  s.dependency 'SDWebImage'

  s.subspec 'WeChatResponse' do |ss|
    ss.frameworks            = 'SystemConfiguration','CoreGraphics','CoreTelephony','Security','CoreLocation','JavaScriptCore'
    ss.libraries             = 'iconv','sqlite3','stdc++','z'
    ss.source_files          = 'LKKit/SDK/WeChatResponse/*.{h,m}','LKKit/SDK/WeChatResponse/**/*.{h}'
    ss.ios.vendored_library  = 'LKKit/SDK/WeChatResponse/lib/libWeChatSDK.a'
  end

   s.subspec 'QQResponse' do |ss|
    ss.libraries               = "stdc++", "sqlite3", "z"
    ss.frameworks              = "SystemConfiguration", "ImageIO", "CoreTelephony"
    ss.ios.vendored_frameworks = 'LKKit/SDK/QQResponse/lib/TencentOpenAPI.framework'
    ss.resource                = 'LKKit/SDK/QQResponse/lib/TencentOpenApi_IOS_Bundle.bundle'
    ss.source_files            = 'LKKit/SDK/QQResponse/**/*.{h,m}', 'LKKit/SDK/QQResponse/lib/*.{h,m}'
  end



  s.requires_arc = true

end
