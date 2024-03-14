#
#  Be sure to run `pod spec lint LMChatUI_iOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = 'LMChatUI_iOS'
  spec.summary      = 'Masterpiece in Making'
  spec.homepage     = 'https://likeminds.community/'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'MIT', :file => '../LICENSE' }
  spec.author             = { "pushpendrasingh" => "pushpendra.singh@likeminds.community" }
  spec.source       = { :git => "https://github.com/LikeMindsCommunity/LikeMinds-iOS-Chat-Sample-App", :tag => "#{spec.version}" }
  spec.source_files = 'LMChatUI_iOS/**/*.swift'
  spec.resource_bundles = {
     'LMChatUI_iOS' => ['LMChatUI_iOS/Assets/*.{xcassets}']
  }
  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.0'
  spec.requires_arc = true
  spec.dependency 'Kingfisher', '~> 7.0'
end
