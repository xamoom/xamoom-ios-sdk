#
# Be sure to run `pod lib lint xamoom-ios-sdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "xamoom-ios-sdk"
  s.version          = "1.4.2"
  s.summary          = "xamoom-ios-sdk is a framework for the xamoom-cloud api. So you can write your own applications for the xamoom-cloud."
  s.homepage         = "http://xamoom.github.io/xamoom-ios-sdk/"
  s.license          = 'GNU'
  s.author           = { "Raphael Seher" => "raphael@xamoom.com" }
  s.source           = { :git => "https://github.com/xamoom/xamoom-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xamoom'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'xamoom-ios-sdk/**/*.{h,m}'
  s.public_header_files = 'xamoom-ios-sdk/**/*.h'
  s.resources = 'xamoom-ios-sdk/ContentBlocks/Blocks/*.xib', 'xamoom-ios-sdk/Assets/**.*'
  s.vendored_libraries = 'xamoom-ios-sdk/lib/SVGKit/libSVGKit-iOS.1.2.0.a'

  s.frameworks = 'CoreText', 'CoreImage', 'QuartzCore', 'CoreGraphics',
  'MobileCoreServices', 'Security', 'CFNetwork', 'SystemConfiguration'
  s.libraries = 'xml2'

  s.dependency 'RestKit', '~> 0.25.0'
  s.dependency 'QRCodeReaderViewController', '~> 2.0.0'
  s.dependency 'SMCalloutView'
  s.dependency 'youtube-ios-player-helper', '= 0.1.4'
  s.dependency 'SDWebImage', '~>3.7'

end
