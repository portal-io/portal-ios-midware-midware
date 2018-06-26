Pod::Spec.new do |s|
    s.name         = 'WVRWidget'
    s.version      = '0.5.6'
    s.summary      = 'WVRWidget files'
    s.homepage     = 'http://git.moretv.cn/whaley-vr-ios-midware/WVRWidget'
    s.license      = 'MIT'
    s.authors      = {'whaleyvr' => 'vr-iosdev@whaley.cn'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://git.moretv.cn/whaley-vr-ios-midware/WVRWidget.git', :tag => s.version}
    
    s.prefix_header_contents = '#import "WVRWidgetHeader.h"'
    
    s.source_files = ["WVRWidget/Core/**/*.{h,m}"]
    # s.public_header_files = 'WVRWidget/Core/**.h'   #公开头文件地址
    s.resources = ['WVRWidget/Core/**/*.{xib}']
    
    s.dependency 'MJRefresh'
    s.dependency 'WVRAppContext'
    s.dependency 'WVRUIFrame'
    s.dependency 'Masonry'
    s.dependency 'WVRImage'
    s.dependency 'YYText'

    # s.subspec "Transformer" do |ss|
    #   ss.source_files = ["Pod/Classes/YTXGooeyCircleLayer.{h,m}", "Pod/Classes/YTXCountDownShowLayer.{h,m}"]
    # end
    s.requires_arc = true

end

    

    

    