Pod::Spec.new do |s|
  s.name         = "FWShareSDK"
  s.version      = “0.1.0”
  s.summary      = "Integrate Yixin, WeChat, SinaWeibo sharing message"
  s.homepage     = "https://github.com/CyonLeu/FWShareSDK"
  s.license      = "MIT"
  s.author             = { “CyonLeu” => “cyonleu@126.com” }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/CyonLeu/FWShareSDK.git", :tag => s.version }

  #s.source_files  = "FWShareSDK", "FWShareSDK/**/*.{h,m}"
  
  s.subspec 'FWShareModel' do |ss|
    ss.source_files = 'FWShareSDK/FWShareModel/*.{h,m}'
  end
 
  s.subspec 'FWShareView' do |ss|
    ss.source_files = 'FWShareSDK/FWShareView/*.{h,m}'
  end

  s.subspec 'Extend' do |ss|
      ss.subspec 'SinaWeiboSDK' do |sss|
      sss.source_files = 'FWShareSDK/Extend/SinaWeiboSDK/*.{h}'
        sss.resources = 'FWShareSDK/Extend/SinaWeiboSDK/WeiboSDK.bundle'
        sss.vendored_libraries = 'FWShareSDK/Extend/SinaWeiboSDK/libWeiboSDK.a'
    	sss.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/FWShareSDK/Extend/SinaWeiboSDK/**"}
      end

      ss.subspec 'WeChatSDK' do |sss|
        sss.source_files = 'FWShareSDK/Extend/WeChatSDK/*.{h}'
        sss.vendored_libraries = 'FWShareSDK/Extend/WeChatSDK/libWeChatSDK.a'
    	sss.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/FWShareSDK/Extend/WeChatSDK/**"}
      end

      ss.subspec 'YiXinSDK' do |sss|
        sss.source_files = 'FWShareSDK/Extend/YiXinSDK/*.{h}'
        sss.vendored_libraries = 'FWShareSDK/Extend/YiXinSDK/libYixinSDK_V2.2.a'
    	sss.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/FWShareSDK/Extend/YiXinSDK/**"}
      end
  end
  
  s.frameworks = "Foundation", "UIKit"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
