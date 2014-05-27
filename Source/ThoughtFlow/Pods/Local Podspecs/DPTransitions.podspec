Pod::Spec.new do |s|
  s.name         = "DPTransitions"
  s.version      = "0.0.1"
  s.summary      = "DPTransitions"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }


  s.source       = { :git => "https://github.com/dpostigo/DPTransitions.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.dependency     'DPKit-Utils'
  s.dependency     'DPAnimators', '0.0.1'
  s.frameworks   = 'Foundation', 'QuartzCore'
  s.requires_arc = true

  # s.source_files = 'DPTransitions/**/*.{h,m}'
  s.source_files = 'DPTransitions/*.{h,m}'


  s.subspec 'Segues' do |segues|
    segues.source_files = 'DPTransitions/Segues/*.{h,m}'
    segues.dependency     'DPKit-Utils'
  end

  
end
