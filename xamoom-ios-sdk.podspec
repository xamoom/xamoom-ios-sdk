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
  s.version          = "1.2.1"
  s.summary          = "xamoom-ios-sdk is a framework for the xamoom-cloud api. So you can write your own applications for the xamoom-cloud."
  s.homepage         = "http://xamoom.github.io/xamoom-ios-sdk/"
  s.license          = 'GNU'
  s.author           = { "Raphael Seher" => "raphael@xamoom.com" }
  s.source           = { :git => "https://github.com/xamoom/xamoom-ios-sdk.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'src/**/*.{h,m}'

  s.resource_bundles = {
    'xamoom-ios-sdk' => ['Pod/Assets/*.*']
  }

  s.resources = 'src/ContentBlocks/Blocks/*.xib', 'Pod/Assets/*.*'

  s.vendored_libraries = 'src/lib/SVGKit/libSVGKit-iOS.1.2.0.a'
  s.public_header_files = 'src/lib/SVGKit/usr/local/include/*.h', 'src/*.h','src/mapping/*.h', 'src/ContentBlocks/*.h', 'src/ContentBlocks/Blocks/*.h', 'src/ContentBlocks/MapViews/*.h'

  s.frameworks = 'CoreText', 'CoreImage', 'QuartzCore', 'CoreGraphics', 'MobileCoreServices', 'Security', 'CFNetwork', 'SystemConfiguration'
  s.libraries = 'xml2'
  
  #s.public_header_files = 'Pod/Classes/**/*.h'
  #s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RestKit', '~> 0.24.1'
  s.dependency 'QRCodeReaderViewController', '~> 2.0.0'
  s.dependency 'SMCalloutView'
  s.dependency 'youtube-ios-player-helper', '~> 0.1.1'
  s.dependency 'SDWebImage', '~>3.7'

end
