# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'xamoom-ios-sdk'

target 'XamoomSDK' do
  xcodeproj 'xamoom-ios-sdk.xcodeproj'
  pod 'RestKit', '~> 0.25.0'
  pod 'QRCodeReaderViewController', '~> 2.0.0'
  pod 'SMCalloutView'
  pod 'youtube-ios-player-helper', '~> 0.1.5'
  pod 'SDWebImage', '~>3.7'
end

target 'xamoom-ios-sdk' do
  xcodeproj 'xamoom-ios-sdk.xcodeproj'
  pod 'RestKit', '~> 0.25.0'
  pod 'QRCodeReaderViewController', '~> 2.0.0'
  pod 'SMCalloutView'
  pod 'youtube-ios-player-helper', '~> 0.1.5'
  pod 'SDWebImage', '~>3.7'
end

target 'Tests', :exclusive => true do
  pod 'OCMock', '~> 3.2'
end

target 'xamoom-ios-sdk-example' do
  xcodeproj 'example/xamoom-ios-sdk-example.xcodeproj'
  pod 'xamoom-ios-sdk', :path => './'
end
