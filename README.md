![](https://storage.googleapis.com/xamoom-files/cb9dcdd940f44b53baf5c27f331c4079.png)

# Welcome iOS Developers

In the next steps you will be shown how to use our sdk and what you have to watch out for.

But before you start, you should have read the topics [Core Concepts](https://github.com/xamoom/xamoom.github.io/wiki/Core-Concepts) and [API Model Specifications](https://github.com/xamoom/xamoom.github.io/wiki/API-Model-Specifications) to better understand our system.

# Getting Started

To use the SDK please set up [CocoaPods](https://cocoapods.org/) to your project.

Once you've successfully set up CocoaPods, you're ready to integrate the xamoom iOS SDK. Before you begin, please read a few topics to better understand the world of xamoom.
* xamoom iOS SDK [Getting Started Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Getting-started)
* xamoom iOS SDK [XMMEnduserApi](https://github.com/xamoom/xamoom-ios-sdk/blob/master/XamoomSDK/Classes/XMMEnduserApi.h)
* xamoom Sample App “[pingeborg App”](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

```swift
pod 'XamoomSDK', '~> 3.10.5'
```

After successfully installing the xamoom SDK, you are ready to use xamoom in your app.

# Usage

If you want to use the [xamoom consumer endpoint](https://github.com/xamoom/xamoom.github.io/wiki) and you already have an API-KEY for our system, then you are able to make your the first calls.

## Setup XMMEnduserApi

To get data from our backend you need to use the XMMEnduserApi class. All calls for loading contents, markers or spots are defined in this class and it is very simply to get your first data from the backend. You only have to create an instance of the XMMEnduserApi class with your API_KEY. So that's the way how the implementation works:

First, import our SDK in the class where you want to use it.

```swift
import XamoomSDK
```

After that, create a XMMEnduserApi instance with your API-KEY.

```swift
let api = XMMEnduserApi(apiKey: "API-KEY")
```

## Make your first call

After you have successfully created your XMMEnduserApi instance you can make your first call against the backend.

```swift
api.system(completion: { (system, error) in
   if error == error {
      print("Error: \(error)")
   } else if let system = system {
      print("System name: \(system.name)")
   }
})
```

Here we are calling the **system()** function of XMMEnduserApi. You are either getting back the System or an Error from the function.   

For more detailed description for all of our API Calls, check [API Model Specifications](https://github.com/xamoom/xamoom.github.io/wiki/API-Model-Specifications) and [XMMEnduserApi](https://github.com/xamoom/xamoom-ios-sdk/blob/master/XamoomSDK/Classes/XMMEnduserApi.h).

# XMMContentBlocks

We offer a large number of different ContentBlocks, all of them displays different types of content. For a more detailed description of all types check out [ContentBlock](https://github.com/xamoom/xamoom.github.io/wiki/ContentBlock).
XMMContentBlocks automatically shows all kind of loaded content data. For a detailed description how to use XMMContentBlocks in your UIViewController read [Working with XMMContentBlocks](https://github.com/xamoom/xamoom-ios-sdk/wiki/Working-with-XMMContentBlocks) documentation.

# iBeacons

You do not have to spend a lot of effort to work with iBeacons. First, you have to read [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager), [CLLocation](https://developer.apple.com/documentation/corelocation/cllocation) and [CLBeaconRegion](https://developer.apple.com/documentation/corelocation/clbeaconregion) classes from Apple and then you're ready to go.
The CLLocationManager just need some basic information for working properly. When you initialize the CLBeaconRegion class you just give your **BEACON_UUID**, your **MAJOR_BEACON_ID** and your **BEACON_IDENTIFIER**.
To respond to the various beacon actions, such as leaving a region or entering a region, the [CLLocationManagerDelegate](https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate) with its functions is used.
You can find an implementation statement [here](https://github.com/xamoom/xamoom-ios-sdk/wiki/iBeacons)

# Push notifications

With our push notification service you can either send a notification to every user, or just a selected part of users who are in a certain radius around a point.
To handle them in your app, you have to implement [Fire Base Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/ios/client) and register your app for [APN](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns).

When you successfully set up Firebase to your project and registered your app for APN, you just have to register the receiveing devices in our system. This is would be done with the **pushDevice()** call from [XMMEnduserApi](https://github.com/xamoom/xamoom-ios-sdk/blob/master/XamoomSDK/Classes/XMMEnduserApi.h).
What you exactly have to do for registering a device, can be found in our [Push Notifications documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/Push-Notifications).

# Offline

Our SDK is also designed to work offline. But to use the offline function of our SDK's you have to make a few adjustments.
First, your desired object must save all data offline. For making this work you must call the **saveOffline()** function of the object.

```swift
let pageSize = 10 as Int32
let api = XMMEnduserApi(apiKey: "API-KEY")
api.contents(withTags: ["Tag"], pageSize: pageSize, cursor: "cursor", sort: XMMContentSortOptions.title, completion: { (result, cursor, hasMore, error) in
   if let contents = result as? [XMMContent] {
      if let content = contents.first {
         content.saveOffline({ (url, data, error) in
            if let error = error {
               print("Download error: \(error)")
            } else {
               print("Downloaded file url: \(url)")
               print("Downloaded data: \(data)")
            }
         })
      }    
   }      
})
 ```
Here we are loading a list of contents with the desired tag. When the contents are loaded we want to save the first content in the list to use it offline. 
In order to show the content offline as well, you have to set the **isOffline** parameter of the **XMMEnduderApi** object to **true**.

```swift
api.isOffline = true
 ```

For a detailed descriptin how offline usage works read the [offline documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/Offline-handling).

# Requirements

* ARC
* Minimum iOS Target: iOS 8
