#
# Be sure to run `pod lib lint xamoom-ios-sdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XamoomSDK"
  s.version          = "2.0.0"
  s.summary          = "Integrate your app with your xamoom system. More information at www.xamoom.com"
  s.homepage         = "http://xamoom.github.io/xamoom-ios-sdk/"
  s.license          = 'GPL'
  s.author           = { "Raphael Seher" => "raphael@xamoom.com" }
  s.source           = { :git => "https://github.com/xamoom/xamoom-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xamoom'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'XamoomSDK/classes/**/*.{h,m}'
  s.public_header_files = 'XamoomSDK/classes/**/*.h'
  s.resources = 'XamoomSDK/Assets/**/**.*'

  s.dependency 'SMCalloutView', '~> 2.0.0'
	s.dependency 'QRCodeReaderViewController', '~> 2.0.0'
	s.dependency 'youtube-ios-player-helper', '= 0.1.4'
	s.dependency 'SDWebImage', '~>3.7'
end
