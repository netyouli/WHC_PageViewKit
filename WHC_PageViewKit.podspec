`echo "4.0" > .swift-version`
Pod::Spec.new do |s|

  s.name         = "WHC_PageViewKit"
  s.version      = "1.0.6"
  s.summary      = "iOS平台轻量级的PageView组件，其中TitleBar拥有30多种UI样式"

  s.homepage     = "https://github.com/netyouli/WHC_PageViewKit"

  s.license      = "MIT"

  s.author             = { "吴海超(WHC)" => "712641411@qq.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/netyouli/WHC_PageViewKit.git", :tag => "1.0.6"}

  s.source_files  = "WHC_PageViewKit/WHC_PageViewKit/*.{swift}"

  s.requires_arc = true
  s.dependency   'WHC_Layout'

end
