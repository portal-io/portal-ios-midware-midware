Pod::Spec.new do |s|
    s.name         = 'WVRInteractor'
    s.version      = '0.0.1'
    s.summary      = 'WVRInteractor files'
    s.homepage     = 'https://git.moretv.cn/whaley-vr-ios-midware/WVRInteractor'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://git.moretv.cn/whaley-vr-ios-midware/WVRInteractor.git', :tag => s.version}
    
    s.source_files = 'WVRInteractor/Core/*.{h,m}'

    s.requires_arc = true
    s.dependency 'WVRNet'
end
