Pod::Spec.new do |s|
    s.name         = 'WVRAPIService'
    s.version      = '0.0.8'
    s.summary      = 'WVRAPIService files'
    s.homepage     = 'https://git.moretv.cn/whaley-vr-ios-midware/WVRAPIService'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://git.moretv.cn/whaley-vr-ios-midware/WVRAPIService.git', :tag => s.version}
    
    s.source_files = 'WVRAPIService/Classes/*.{h,m}'

    s.requires_arc = true
    s.dependency 'WVRNet'
    s.dependency 'WVRAppContext'
end
