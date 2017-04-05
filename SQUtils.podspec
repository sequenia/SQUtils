#
#  Be sure to run `pod spec lint SQUtils.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SQUtils"
  s.version      = '0.0.24'
  s.summary      = 'Pack of categories and custom classes'
  s.homepage     = 'https://github.com/sequenia/SQUtils'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'sequenia' => 'sequenia@sequenia.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/sequenia/SQUtils', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.source_files        = 'Sources/SQUtils.h'
  s.public_header_files = 'Sources/SQUtils.h'
  # s.exclude_files = "Sources/SQSocial/*"


  s.subspec 'SQCategories' do |ss|
    ss.source_files = 'Sources/SQCategories/**/*.{h,m}'
    ss.public_header_files = 'Sources/SQCategories/SQCategories.h', 'Sources/SQCategories/Foundation/*.h', 'Sources/SQCategories/UIKit/*.h'
  end

  s.subspec 'SQBehavior' do |ss|
    ss.source_files = 'Sources/SQBehavior/**/*.{h,m}'
    ss.public_header_files = 'Sources/SQBehavior/SQBehaviors.h', 'Sources/SQBehavior/Base/NKBehavior.h', 'Sources/SQBehavior/Address/NKAddressBookPickerBehavior.h', 'Sources/SQBehavior/Paging/NKPagingBehavior.h', 'Sources/SQBehavior/PhotoPicker/NKPhotoPickerBehavior.h'
    ss.frameworks = 'AddressBook', 'AddressBookUI'
    ss.dependency 'SQUtils/SQCategories'
  end

  s.subspec 'SQEdgedCollection' do |ss|
    ss.source_files = 'Sources/SQEdgedCollection/*.{h,m}'
    ss.public_header_files = 'Sources/SQEdgedCollection/SQEdgedCollectionViewController.h'
  end

  s.subspec 'SQEndlessCollection' do |ss|
    ss.source_files = 'Sources/SQEndlessCollection/*.{h,m}'
    ss.public_header_files = 'Sources/SQEndlessCollection/SQEndlessCollectionView.h', 'Sources/SQEndlessCollection/SQPageControl.h'
  end

  s.subspec 'SQKeyboard' do |ss|
    ss.source_files = 'Sources/SQKeyboard/*.{h,m}'
    ss.public_header_files = 'Sources/SQKeyboard/GSKeyboardManager.h'
  end

  s.subspec 'SQNews' do |ss|
    ss.source_files = 'Sources/SQNews/*.{h,m}'
    ss.resources = 'Sources/SQNews/Resources/*.{xib}'
    ss.public_header_files = 'Sources/SQNews/SQNewsContainerViewController.h', 'Sources/SQNews/SQNewsDetailViewController.h', 'Sources/SQNews/SQNewsListViewController.h', 'Sources/SQNews/SQNewsSelectDelegate.h'
  end

  s.subspec 'SQOnboarding' do |ss|
    ss.source_files = 'Sources/SQOnboarding/*.{h,m}'
    ss.resources = 'Sources/SQOnboarding/Resources/*.{png}'
    ss.public_header_files = 'Sources/SQOnboarding/SQOnboardingView.h'
  end

  s.subspec 'SQPhotoPicker' do |ss|
    ss.source_files = 'Sources/SQPhotoPicker/**/*.{h,m}'
    ss.resources = 'Sources/SQPhotoPicker/Resources/*.{png,strings,xib,lproj}'
    ss.public_header_files = 'Sources/SQPhotoPicker/SQPhotoPickerSheet.h', 'Sources/SQPhotoPicker/Data/SQPhoto.h'
    ss.frameworks = 'Photos', 'PhotosUI'
  end

  s.subspec 'SQViews' do |ss|
    ss.source_files = 'Sources/SQViews/*.{h,m}'
    ss.public_header_files = 'Sources/SQViews/SQTopAlignedLabel.h', 'Sources/SQViews/SQBorderedButton.h'
  end

  s.subspec 'SQFileViewer' do |ss|
    ss.source_files = 'Sources/SQFileViewer/*.{h,m}'
    ss.public_header_files = 'Sources/SQFileViewer/SQFileManager.h', 'Sources/SQFileViewer/SQFileViewer.h', 'Sources/SQFileViewer/SQAttachment.h'
    ss.frameworks = 'QuickLook'
    s.exclude_files = 'Sources/SQFileViewer/README.md'
    ss.dependency 'SQUtils/SQCategories'

  end

  s.subspec 'SQSocial' do |ss|
        ss.source_files = 'Sources/SQSocial/**/*.{h,m}'
        ss.subspec 'VKontakte' do |sss|
            sss.source_files = 'Sources/SQSocial/VKontakte/*.{h,m}'
            sss.public_header_files = 'Sources/SQSocial/VKontakte/SQVKontakteHelper.h'
            sss.dependency 'VK-ios-sdk'
        end

        ss.subspec 'Instagram' do |sss|
            sss.source_files = 'Sources/SQSocial/Instagram/*.{h,m}'
            sss.public_header_files = 'Sources/SQSocial/Instagram/SQInstagramHelper.h', 'Sources/SQSocial/Instagram/InstagramLoginViewController.h'
            sss.resources = 'Sources/SQSocial/Instagram/Resources/InstagramLoginViewController.xib'
        end

        ss.subspec 'Facebook' do |sss|
            sss.source_files = 'Sources/SQSocial/Facebook/*.{h,m}'
            sss.public_header_files = 'Sources/SQSocial/Facebook/SQFacebookHelper.h'
            sss.dependency 'FBSDKCoreKit'
            sss.dependency 'FBSDKLoginKit'
            sss.dependency 'FBSDKShareKit'
        end

        ss.subspec 'GooglePlus' do |sss|
            sss.source_files = 'Sources/SQSocial/GooglePlus/*.{h,m}'
            sss.public_header_files = 'Sources/SQSocial/GooglePlus/SQGooglePlusHelper.h'
            sss.dependency 'GoogleSignIn', '~> 4.0.0'
        end
  end

end
