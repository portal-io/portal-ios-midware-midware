Pod::Spec.new do |s|
    s.name         = 'WVRPlayerUI'
    s.version      = '0.1.8'
    s.summary      = 'WVRPlayerUI framework'
    s.homepage     = 'https://git.moretv.cn/whaley-vr-ios-lib/WVRPlayerUI'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://git.moretv.cn/whaley-vr-ios-midware/WVRPlayerUI.git', :tag => s.version}
    
    s.prefix_header_contents = '#import "WVRPlayerUIHeader.h"'
    
    s.source_files = ['WVRPlayerUI/Classes/*.{h,m}', 'WVRPlayerUI/Classes/**/*.{h,m}']
    s.resources = 'WVRPlayerUI/Classes/**/*.xib'

    # s.vendored_frameworks = ['WVRPlayerUI/Classes/Player/WhaleyVRPlayer.framework']
    # s.resources = ['WVRPlayerUI/Classes/Player/WVRPlayerUIBundle.bundle']
    
    s.requires_arc = true
    s.frameworks = ['Foundation', 'UIKit']
    
    s.dependency 'Masonry'
    s.dependency 'WVRAppContext'
    s.dependency 'WVRImage'
    s.dependency 'WVRUtil'
    s.dependency 'YYText'
    s.dependency 'ReactiveObjC'
    s.dependency 'WVRUIFrame'
    s.dependency 'WVRWidget'
    s.dependency 'WVRBI'
    
end
