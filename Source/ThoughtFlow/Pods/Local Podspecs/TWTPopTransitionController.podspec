Pod::Spec.new do |s|
  s.name         = "TWTPopTransitionController"
  s.version      = "0.0.1"
  s.summary      = "TWTPopTransitionController"
  s.homepage     = "https://github.com/ObjectiveToast/InteractiveTransitions.git"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani.postigo@gmail.com" }


  s.source       = { :git => "https://github.com/dpostigo/TWTPopTransitionController.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'


  s.frameworks   = 'Foundation', 'QuartzCore'
  s.requires_arc = true

  s.source_files = 'TWTPopTransitionController/*.{h,m}'



  
end
