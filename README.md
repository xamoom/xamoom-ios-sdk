![](https://storage.googleapis.com/xamoom-files/cb9dcdd940f44b53baf5c27f331c4079.png)

# Welcome iOS Developers

You decided to use the iOS SDK in your app? Then you are exactly right here. In the next few points you will be instructed how to use and implement our iOS SDK smoothly.

But before you start, you should have read through ["Core Concepts](https://github.com/xamoom/xamoom.github.io/wiki/Core-Concepts) and [API Model Specifications](https://github.com/xamoom/xamoom.github.io/wiki/API-Model-Specifications) to better understand our system.

# Getting Started

Before you can start implementing our SDK, start your XCode project .During the project setup please implement CocoaPods. You can find detailed instructions [here](https://cocoapods.org/).

If you've successfully set up CocoaPods, then you're ready to install the xamoom iOS SDK. Before you begin, please check a few little things to get later no problems.
* xamoom iOS SDK Getting Started [guide]()
* xamoom iOS SDK [XMMEnduser Api](https://github.com/xamoom/xamoom-ios-sdk/wiki/XMMEnduserApi-Documentation)
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

If you want to use the [xamoom consumer endpoint](https://github.com/xamoom/xamoom.github.io/wiki) and already have an API-KEY for our system, then you are now so far in your project the first "xammom" steps to put.

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

# XMMContentBlocks

We offer a large number of different ContentBlocks, all of them displays different types of content. For a description of all type check out [this](https://github.com/xamoom/xamoom.github.io/wiki/ContentBlock).
XMMContentBlocks does a lot of things for you. You do not have to worry about a BlockType of type Link or Text, because XMMContentBlock does it automatically. You only have to do a few small implementations to use this functionality. For a detailed description of how to do this, see [Working with XMMContentBlocks(https://github.com/xamoom/xamoom-ios-sdk/wiki/Working-with-XMMContentBlocks).

# iBeacons

You do not have to spend a lot of effort to work with iBeacons. You just have to take a look at the [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager), [CLLocation](https://developer.apple.com/documentation/corelocation/cllocation) and [CLBeaconRegion](https://developer.apple.com/documentation/corelocation/clbeaconregion) classes from Apple and then you're ready to go.
The CLLocationManager just give the settings that fit to you. When you initialize the CLBeaconRegion class you just give your BEACON_UUID, your MAJOR_BEACON_ID and your BEACON_IDENTIFIER.
To respond to the various beacon actions, such as leaving a region or entering a region, the [CLLocationManagerDelegate](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate) with its functions is used.
You can find an implementation statement [here] (https://github.com/xamoom/xamoom-ios-sdk/wiki/iBeacons)

# Push notifications

With our PushNotification service you can either send a notification to every user, or just a selected part of users who are in a certain radius around a point that must be defined when sending a notification. You can submit this in the [CMS](https://xamoom.net) if you select a page and then you select the “Push notification” section on the right side.
But to show them in your app you need to implement a few things. Check out following implementation guides

* Fire Base Cloud Messaging [implementation](https://firebase.google.com/docs/cloud-messaging/ios/client)
* Apple's [APN](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns)

If you have completed the setup as described in the top two points, you just need to register the receiveing devices on our system. This is done with the **pushDevice()** call from [XMMEnduser Api](https://github.com/xamoom/xamoom-ios-sdk/wiki/XMMEnduserApi-Documentation).
What you have exactly to do for registering a device, can be found in our [Push Notifications documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/Push-Notifications).

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
