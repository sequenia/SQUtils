#
#  Be sure to run `pod spec lint SQUtilites.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SQUtils"
  s.version      = "0.0.4"
  s.summary      = 'Pack of categories and custom classes'
  s.homepage     = 'https://github.com/sequenia/SQUtils'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'sequenia' => 'sequenia@sequenia.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/sequenia/SQUtils", :tag => s.version, :submodules => true }
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit'
  

  s.source_files        = 'Sources/SQUtils.h'
  s.public_header_files = 'Sources/SQUtils.h'
  s.exclude_files = "Sources/SQSocial/*"

  s.subspec 'SQCategories' do |ss|
    ss.source_files = 'Sources/SQCategories/**/*.{h,m}'
    ss.public_header_files = 'Sources/SQCategories/SQCategories.h'
  end

  s.subspec 'SQBehavior' do |ss|
    ss.source_files = 'Sources/SQBehavior/**/*.{h,m}'
    ss.public_header_files = 'Sources/SQBehavior/SQBehaviors.h'
    ss.frameworks = 'AddressBook', 'AddressBookUI'
    ss.dependency 'SQUtilites/SQCategories'
  end

  s.subspec 'SQEdgedCollection' do |ss|
    ss.source_files = 'Sources/SQEdgedCollection/*.{h,m}'
    ss.public_header_files = 'Sources/SQEdgedCollection/SQEdgedCollectionViewController.h'
  end  

  s.subspec 'SQEndlessCollection' do |ss|
    ss.source_files = 'Sources/SQEndlessCollection/*.{h,m}'
    ss.public_header_files = 'Sources/SQEndlessCollection/SQEndlessCollectionView.h'
  end  

  s.subspec 'SQKeyboard' do |ss|
    ss.source_files = 'Sources/SQKeyboard/*.{h,m}'
    ss.public_header_files = 'Sources/SQKeyboard/GSKeyboardManager.h'
  end

  s.subspec 'SQNews' do |ss|
    ss.source_files = 'Sources/SQNews/*.{h,m}'
    ss.resources = 'Sources/SQNews/Resources/*.{xib}'
    ss.public_header_files = 'Sources/SQNews/SQNewsContainerViewController.h', 'Sources/SQNews/SQNewsDetailViewController.h', 'Sources/SQNews/SQNewsListViewController.h'
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

  # s.dependency "JSONKit", "~> 1.4"

end
