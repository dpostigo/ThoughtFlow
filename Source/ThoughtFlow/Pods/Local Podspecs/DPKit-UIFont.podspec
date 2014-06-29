Pod::Spec.new do |s|
  s.name         = "DPKit-UIFont"
  s.version      = "0.0.3"
  s.summary      = "DPKit-UIFont"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }


  s.source       = { :git => "https://github.com/dpostigo/DPKit-UIFont.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'


  s.frameworks   = 'Foundation', 'QuartzCore', 'CoreText'
  s.requires_arc = true

  s.source_files = 'DPKit-UIFont/*.{h,m}'
  s.resource_bundle = {'DPKitFonts' => 'DPKit-UIFont/Resources/*'}



  
end
