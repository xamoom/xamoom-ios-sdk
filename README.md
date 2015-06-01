![](https://xamoom.com/wp-inhalte/uploads/2015/02/logo-black-claim1.png)


# xamoom-ios-sdk
xamoom-ios-sdk is a framework for the xamoom-cloud api. So you can write your own applications for the xamoom-cloud.

# Getting Started

* [Download](https://github.com/xamoom/xamoom-ios-sdk/archive/master.zip) and try out example xamoom-ios-sdk
* Read the ["Getting Started"](https://github.com/xamoom/xamoom-ios-sdk/wiki#getting-started) guide in the wiki
* Check out the XMMEnduserApi [documentation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html)
* Check out our sample app: ["pingeborg App"](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

## Manual Installation
Download the xamoom-ios-sdk and add it to your project. Don't forget to install the [dependencies](https://github.com/xamoom/xamoom-ios-sdk/wiki/Installing#dependencies).

## Installation with [CocoaPods](https://cocoapods.org/)

Add in your podfile

    platform :ios, '7.0'
    pod 'xamoom-ios-sdk'

Install pods via terminal

    pod install

### Api Key

Copy your api key in a file named **api.txt** and add it to your bundle.

# Usage
```objective-c
//set your delegate
[[XMMEnduserApi sharedInstance] setDelegate:self];
//make your call
[[XMMEnduserApi sharedInstance] contentListWithSystemId:exampleId withLanguage:@"de" withPageSize:7 withCursor:nil];
```

You don't know what to call? Take a look at the [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html)

# Requirements
* ARC
* Minumum iOS Target: iOS 8
* RestKit 0.24
* QRCodeReaderViewController 2.0.0
