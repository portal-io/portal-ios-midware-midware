Pod::Spec.new do |s|
    s.name         = 'WVRHybrid'
    s.version      = '0.0.3'
    s.summary      = 'WVRHybrid files'
    s.homepage     = 'http://git.moretv.cn/whaley-vr-ios-midware/WVRHybrid'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'http://git.moretv.cn/whaley-vr-ios-midware/WVRHybrid.git', :tag => s.version}
    s.source_files = ['WVRHybrid/Classes/**/*.{h,m}']
    s.requires_arc = true

    s.dependency 'WVRAppContext'
    s.dependency 'WVRWidget'
    s.dependency 'WVRUtil'
    s.dependency 'YYModel'

    s.framework = 'UIKit', 'Foundation'
end

