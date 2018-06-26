Pod::Spec.new do |s|
    s.name         = 'WVRMediator'
    s.version      = '0.2.5'
    s.summary      = 'WVRMediator files'
    s.homepage     = 'http://git.moretv.cn/whaley-vr-ios-midware/WVRMediator'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'http://git.moretv.cn/whaley-vr-ios-midware/WVRMediator.git', :tag => s.version}
    s.source_files = ['WVRMediator/Classes/*.{h,m}', 'WVRMediator/Classes/**/*.{h,m}']
    s.requires_arc = true
    s.dependency 'CTMediator'
    s.dependency 'YYModel'
    s.framework = 'UIKit', 'Foundation'
end

