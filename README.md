![](https://storage.googleapis.com/xamoom-files/cb9dcdd940f44b53baf5c27f331c4079.png)

# Welcome iOS Developers

You decided to use the iOS SDK in your app? Then you are exactly right here. In the next few points you will be instructed how to use and implement our iOS SDK smoothly.

But before you start, you should have read through ["Core Concepts](https://github.com/xamoom/xamoom.github.io/wiki/Core-Concepts) and [API Model Specifications](https://github.com/xamoom/xamoom.github.io/wiki/API-Model-Specifications) to better understand our system.

# Getting Started

Before you can start implementing our SDK, start your XCode project .During the project setup please implement CocoaPods. You can find detailed instructions [here] (https://cocoapods.org/).

If you've successfully set up CocoaPods, then you're ready to install the xamoom iOS SDK. Before you begin, please check a few little things to get later no problems.
* xamoom iOS SDK Getting Started [guide]()
* xamoom iOS SDK [XMMEnduser Api]((https://github.com/xamoom/xamoom-ios-sdk/wiki/XMMEnduserApi-Documentation)
* xamoom Sample App “[pingeborg App”](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

The installation of our SDK works like any other Pod installation. Open your podfile in XCode and add the following line

```swift
pod 'XamoomSDK', '~> 3.10.5'
```

Then you open the terminal, navigate to the folder of the podfile and install your pods
```swift
pod install
```

After successfully installing the xamoom SDK, you are now ready to use xamoom in your app.

# Usage

If you want to use the [xamoom consumer endpoint] (https://github.com/xamoom/xamoom.github.io/wiki) and already have an API-KEY for our system, then you are now so far in your project the first "xammom" steps to put.

## Setup XMMEnduserApi

To place a call against the backend, you use the XMMEnduserApi class. In this class, all API calls which run against the backend are defined, no matter if you want to load contents, spots or markers.
To load data from your system you need to create an XMMEnduserApi object with your system's API KEY. 

First, import our SDK in the class where you want to use it.

```swift
import XamoomSDK
```

After that, create a XMMEnduserApi object.

```swift
let api = XMMEnduserApi(apiKey: "API_KEY")
```

Once you have created your XMMEnduserApi object, the world of xamoom is open to you.


## Make your first experience

After you have successfully created your XMMEnduserApi object you can make your first experience with xamoom. The easiest way is to load your system.
For this you use the "system" function of the XMMEnduserApi class.

```swift
api.system(completion: { (system, error) in
   if error == nil, let system = system {
      print("System name: \(system.name)")
   }
})
```

For more detailed description for all of our API Calls, check [API Model Specifications](https://github.com/xamoom/xamoom.github.io/wiki/API-Model-Specifications) and [XMMEnduserApi documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/XMMEnduserApi-Documentation).

# iBeacons

xamoom offers support for iBeacons. We have a [small guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/iBeacons) to implement them in the [wiki](https://github.com/xamoom/xamoom-ios-sdk/wiki).

# XMMContentBlocks

xamoom has a lot of different contentBlocks. With XMMContentBlocks you have a easy way to display them.
How to use it is in our [Step by Step Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Step-by-Step-Guide).

# Push notifications

To use our Push Notifications please check our [Push Notification Documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/Push-Notifications).

# Offline

## Save & get entities Offline

You can save your entities offline and use them even if you are not connected
to the internet.

To save entities offline call its `saveOffline` method.
For example to save a content works like this:

```objective-c
[content saveOffline];

// with completionBlock for automatically downloaded files
// XMMContent & XMMSpot will download their files
[content saveOffline:^(NSString \*url, NSData \*data, NSError \*error) {
  NSLog(@"Downloaded file %@", url);
}];
```

To get offline saved entities use the `XMMEnduserApi` and set the offline property
to true:
```objective-c
enduserApi.offline = YES;
```
All `XMMEnduserApi` calls will now return you the offline saved entities.

# Requirements

* ARC
* Minimum iOS Target: iOS 8
