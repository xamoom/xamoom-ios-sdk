# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'XamoomSDK'

target 'XamoomSDK' do
	pod 'JSONAPI', '~> 1.0.0'
	pod 'SDWebImage', '~>3.7'
  pod 'JAMSVGImage'
	pod 'Pushwoosh'
end

target 'XamoomSDKTests' do
	pod 'OCMock', '~> 3.2'
  pod 'Nocilla'
end

target 'Example' do
	xcodeproj 'Example/example.xcodeproj'
	pod 'XamoomSDK', :path => './'
end
