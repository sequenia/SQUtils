#
# Be sure to run `pod lib lint --use-libraries SQUtils.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
    
    s.name                    = 'SQUtils'
    s.version                 = '0.2.0'
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
        ss.source_files = 'Sources/Classes/**/*.{h,m}'
        ss.resources = ['Sources/Classes/**/*.{strings,png,xib}']
    end
    
    s.subspec 'Social' do |ss|
        ss.source_files = 'Sources/Social/SQSocial.h'
        
        ss.subspec 'VKontakte' do |sss|
            sss.dependency 'VK-ios-sdk', '~> 1.3.12'
            sss.source_files = 'Sources/Social/VKontakte/**/*.{h,m}', 'Sources/Social/SQSocnetHelper.{h,m}'
        end
        
        ss.subspec 'Instagram' do |sss|
            sss.source_files = 'Sources/Social/Instagram/**/*.{h,m}', 'Sources/Social/SQSocnetHelper.{h,m}'
            sss.resources = ['Sources/Social/Instagram/**/*.xib']
        end
        
        ss.subspec 'Facebook' do |sss|
            sss.dependency 'FBSDKCoreKit', '~> 4.7.1'
            sss.dependency 'FBSDKLoginKit', '~> 4.7.1'
            sss.dependency 'FBSDKShareKit', '~> 4.7.1'
            sss.source_files = 'Sources/Social/Facebook/**/*.{h,m}', 'Sources/Social/SQSocnetHelper.{h,m}'
        end
        
        ss.subspec 'GooglePlus' do |sss|
            sss.dependency 'GoogleSignIn', '~> 4.0.0'
            sss.source_files = 'Sources/Social/GooglePlus/**/*.{h,m}', 'Sources/Social/SQSocnetHelper.{h,m}'
        end
        
        
    end

end