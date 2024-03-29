Pod::Spec.new do |s|
  s.name             = "XamoomSDK"
  s.version          = "3.11.21"
  s.summary          = "Integrate your app with your xamoom system. More information at www.xamoom.com"
  s.homepage         = "http://xamoom.github.io/xamoom-ios-sdk/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Raphael Seher" => "raphael@xamoom.com" }
  s.source           = { :git => "https://github.com/xamoom/xamoom-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xamoom'
  
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  
  s.default_subspec = 'Core'
  s.static_framework = true
  
  s.subspec 'Core' do |core|
    core.source_files = 'XamoomSDK/Classes/**/**/*.{h,m}'
    core.public_header_files = 'XamoomSDK/Classes/**/*.h'
    
    core.resource = 'XamoomSDK/Assets/*.xcassets'
    core.resource_bundles = {
      'XamoomSDK' => ['XamoomSDK/Assets/*.xcassets', 'XamoomSDK/Assets/*.lproj',
      'XamoomSDK/Classes/ContentBlocks/**/*.xib', 'XamoomSDK/Assets/*.xcdatamodeld']
    }
    
    core.dependency 'JSONAPI', '~> 1.0.7'
    core.dependency 'SDWebImage', '>= 3.7', '< 5.0'
    core.dependency 'JAMSVGImage'
    core.dependency 'Mapbox-iOS-SDK'
    core.dependency 'Firebase', '>= 5.15.0'
    core.dependency 'FirebaseCore', '>= 5.1.0'
    core.dependency 'FirebaseMessaging'
    core.dependency 'HCLineChartView' 
  end
end
