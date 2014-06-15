Pod::Spec.new do |s|
  s.name         = "DPKit-Utils"
  s.version      = "0.0.22"
  s.summary      = "DPKit-Utils"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }
  s.source       = { :git => "https://github.com/dpostigo/DPKit-Utils.git", :tag => s.version.to_s }
  s.requires_arc = true


  s.ios.deployment_target = '4.3'
  s.ios.source_files = 'DPKit-Utils/*.{h,m}', 'DPKit-Utils/ios/**/*.{h,m}'

  s.osx.deployment_target = '10.7'
  s.osx.source_files = 'DPKit-Utils/*.{h,m}', 'DPKit-Utils/osx/**/*.{h,m}'



  s.dependency  'JMSimpleDate'
  s.frameworks   = 'Foundation', 'QuartzCore', 'UIKit', 'CoreGraphics'
  s.ios.frameworks   = 'Foundation', 'QuartzCore', 'UIKit', 'CoreGraphics'



  
end
