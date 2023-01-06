Pod::Spec.new do |s|
  s.name             = 'Common'
  s.version          = '1.0.0'
  s.summary          = 'Common logic layer of the project.'
  s.homepage         = 'https://github.com/iCookbook/Common'
  s.author           = { 'htmlprogrammist' => '60363270+htmlprogrammist@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/iCookbook/Common.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'Common/Sources/**/*.{swift}'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Common/Tests/**/*.{swift}'
  end
  
  s.dependency 'Models'
  s.dependency 'Networking'
  s.dependency 'CommonUI'
  s.dependency 'RecipeDetails'
  s.dependency 'Logger'
end
