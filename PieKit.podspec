Pod::Spec.new do |s|
s.name      = 'PieKit'
s.version   = '1.0.4'
s.summary   = 'PieKit 是一组在OC中使用比较方便的工具类'
s.homepage  = 'https://github.com/LWPPIE/PieKit'
s.license   = '{ :type => "MIT", :file => "LICENSE" }'
s.platform  = :ios
s.author    = {'LWPPIE' => '610310337@qq.com'}
s.ios.deployment_target = '8.0'
s.source    = {:git => 'https://github.com/LWPPIE/PieKit.git',:tag => s.version}
s.source_files = "PieKit/*.{h,m}"
#s.resources = "PieKits/*.{h,m}"
s.requires_arc = true
s.frameworks    = 'UIKit'
end