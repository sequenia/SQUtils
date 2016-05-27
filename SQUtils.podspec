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
#  s.public_header_files     = 'Sources/SQUtils.h'
#  s.source_files            = 'Sources/SQUtils.h'
  s.source_files            = 'Sources/**/*'
  s.ios.deployment_target   = '8.0'

#  s.subspec 'Categories' do |ss|
#      ss.source_files           = 'SQUtils/Categories/SQCategories.h'
#      ss.public_header_files    = 'SQUtils/Categories/SQCategories.h'
#      
#      ss.subspec 'Foundation' do |sss|
#         sss.source_files   = 'SQUtils/Categories/Foundation/**/*.{h,m}'
#      end
#      
#      ss.subspec 'UIKit' do |sss|
#          sss.source_files   = 'SQUtils/Categories/UIKit/**/*.{h,m}'
#      end
#  end
#  
#  s.subspec 'Classes' do |ss|
#      ss.source_files           = 'SQUtils/Classes/**/*'
#  end

end
