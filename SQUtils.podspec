#
# Be sure to run `pod lib lint SQUtils.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
    
  s.name                    = 'SQUtils'
  s.version                 = '0.1.0'
  s.summary                 = 'Pack of categories and custom classes'
  s.homepage                = 'https://github.com/sequenia/SQUtils'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'sequenia' => 'sequenia@sequenia.com' }
  s.source                  = { :git => 'https://github.com/sequenia/SQUtils.git', :tag => s.version.to_s }
  s.requires_arc            = true
  s.ios.deployment_target   = '8.0'

  s.source_files            = 'Sources/SQUtils.h'
  
  s.subspec 'Categories' do |ss|
      ss.source_files = 'Sources/Categories/**/*'
  end
  
  s.subspec 'Classes' do |ss|
      ss.dependency 'SQUtils/Categories'
      ss.source_files = 'Sources/Classes/**/*'
  end

end
