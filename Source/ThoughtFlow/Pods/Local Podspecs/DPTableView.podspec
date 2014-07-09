Pod::Spec.new do |s|
  s.name         = "DPTableView"
  s.version      = "0.0.1"
  s.summary      = "DPTableView"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani.postigo@gmail.com" }


  s.source       = { :git => "https://github.com/dpostigo/DPTableView.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'


  # s.dependency     'NSColor-Crayola'
  # s.dependency     'NSView-NewConstraints'
  s.dependency     'DPKit-Utils'
  s.dependency     'DPKit-UIView'
  # s.dependency     'DPKit-Styles'
  s.frameworks   = 'Foundation', 'QuartzCore', 'UIKit'
  s.requires_arc = true

  s.source_files = 'DPTableView/*.{h,m}'



  
end
