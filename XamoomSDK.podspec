Pod::Spec.new do |s|
  s.name             = "XamoomSDK"
  s.version          = "3.2.1"
  s.summary          = "Integrate your app with your xamoom system. More information at www.xamoom.com"
  s.homepage         = "http://xamoom.github.io/xamoom-ios-sdk/"
  s.license          = { :type => 'GPL', :file => 'LICENSE.md' }
  s.author           = { "Raphael Seher" => "raphael@xamoom.com" }
  s.source           = { :git => "https://github.com/xamoom/xamoom-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xamoom'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'XamoomSDK/Classes/**/**/*.{h,m}'
  s.public_header_files = 'XamoomSDK/Classes/**/*.h'

  s.resource = 'XamoomSDK/Assets/Images.xcassets'
  s.resource_bundles = {
    'XamoomSDK' => ['XamoomSDK/Assets/*.xcassets', 'XamoomSDK/Assets/*.lproj',
    'XamoomSDK/Classes/ContentBlocks/**/*.xib', 'XamoomSDK/Assets/*.xcdatamodeld']
  }

  s.dependency 'JSONAPI', '~> 1.0.0'
  s.dependency 'SDWebImage', '~>3.7'
  s.dependency 'JAMSVGImage'
end
