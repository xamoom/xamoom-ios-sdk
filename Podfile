# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'XamoomSDK'

target 'XamoomSDK' do
  pod 'HCLineChartView'
	pod 'JSONAPI', '~> 1.0.0'
	pod 'SDWebImage', '~>3.7'
  pod 'JAMSVGImage'
  pod 'Pushwoosh'
  pod 'Mapbox-iOS-SDK'
  pod 'GoogleAnalytics'
  pod 'Firebase', '~> 6.20.0'
  pod 'FirebaseCore', '~> 6.6.4'
  pod 'FirebaseMessaging', '~> 4.3.0'
end

target 'XamoomSDKTests' do
	pod 'OCMock', '~> 3.2'
  pod 'Nocilla'
end

target 'Example' do
	project 'Example/example.xcodeproj'
	pod 'XamoomSDK', :path => './'
end
