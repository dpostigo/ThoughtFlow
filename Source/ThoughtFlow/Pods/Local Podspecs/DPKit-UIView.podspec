Pod::Spec.new do |s|
  s.name         = "DPKit-UIView"
  s.version      = "0.0.1"
  s.summary      = "DPKit-UIView"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }


  s.source       = { :git => "https://github.com/dpostigo/DPKit-UIView.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'


  s.dependency     'DPKit-Utils'
  s.frameworks   = 'Foundation', 'QuartzCore'
  s.requires_arc = true

  s.source_files = 'DPKit-UIView/*.{h,m}'



  
end
