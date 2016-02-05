# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'XamoomSDK'

target 'XamoomSDK' do
	pod 'JSONAPI', '~> 1.0.0'
	pod 'SMCalloutView', '~> 2.0.0'
	pod 'QRCodeReaderViewController', '~> 2.0.0'
	pod 'youtube-ios-player-helper', '= 0.1.4'
	pod 'SDWebImage', '~>3.7'
end

target 'XamoomSDKTests', :exclusive => true do
	pod 'OCMock', '~> 3.2'
  pod 'XamoomSDK', :path => './'
end

target 'Example' do
	xcodeproj 'Example/example.xcodeproj'
	pod 'XamoomSDK', :path => './'
end
