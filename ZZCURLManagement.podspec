
Pod::Spec.new do |s|

  s.name         = "ZZCURLManagement"
  s.version      = "0.0.1"
  s.summary      = "租租车URL封装"
  s.description  = <<-DESC
                          租租车网络请求封装
                   DESC

  s.homepage     = "http://m.zuzuche.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Blue" => "lizhaoyang@zuzuche.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "ssh://git@120.79.86.56:10022/zuzuche_ios_library/ZZCURLManagement.git", :tag => "v#{s.version}" }
  s.framework  = 'Foundation','UIKit'
  s.requires_arc = true
  s.dependency "AFNetworking"
  s.dependency "MJExtension"
  

  s.source_files = 'ZZCURLManagement/ZZCHTTPManager/*'

  s.subspec 'view' do |view|
    view.resources = "ZZCHomeCollectionLayout/homeLayout.bundle"
    view.source_files = 'ZZCHomeCollectionLayout/Views/*{h,m}'
  end

end
