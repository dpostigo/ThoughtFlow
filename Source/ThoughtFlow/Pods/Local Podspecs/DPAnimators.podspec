Pod::Spec.new do |s|
  s.name         = "DPAnimators"
  s.version      = "0.0.4"
  s.summary      = "DPAnimators"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }


  s.source       = { :git => "https://github.com/dpostigo/DPAnimators.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.frameworks   = 'Foundation', 'QuartzCore'
  s.dependency     'BlocksKit'
  s.dependency     'DPKit-Utils'
  s.dependency     'DPKit-UIView'
  s.requires_arc = true

  # s.source_files = 'DPAnimators/**/*.{h,m}'
  s.source_files = 'DPAnimators/**/*.{h,m}'



  # s.subspec 'Utils' do |utils|
  #   utils.source_files = 'DPAnimators/Utils/*.{h,m}'
  #   utils.dependency     'DPKit-Utils'
  #   utils.dependency     'DPKit-UIView'
  # end


  
end
