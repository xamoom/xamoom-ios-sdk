# Changelog

## [3.10.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.9.0...3.10.0) - 05.02.2018

- Added rtl support

## [3.9.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.8.0...3.9.0) - 05.02.2018

- Added ephemeralId
- Added reasons to content calls

- Changed audioplayerblock to don't interfere with each other & show media info in control center

## [3.8.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.7.1...3.8.0) - 06.12.2017

- Added UIAppearance to Audio-, Link-, Ebook- and Downloadblocks

- Fixed textView spacing on ContentBlock0TableViewCell
- Fixed label spacing on ContentBlock11TableViewCell

- Removed placeholder on ContentBlock11TableViewCell

## [3.7.1](https://github.com/xamoom/xamoom-ios-sdk/compare/3.7.0...3.7.1) - 17.11.2017

- Fixed contentListTags parsing

- Added contentList localization

## [3.7.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.6.0...3.7.0) - 30.10.2017

- Added socialSharing url to content
- Added eventPackage

- Changed phone link color

## [3.6.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.5.4...3.6.0) - 13.10.2017

- Added new content block: content list

## [3.5.4](https://github.com/xamoom/xamoom-ios-sdk/compare/3.5.3...3.5.4) - 22.09.2017

- Added x-datetime condition to getByLocationIdentifier calls

- Changed useragent to get normalized

## [3.5.3](https://github.com/xamoom/xamoom-ios-sdk/compare/3.5.2...3.5.3) - 12.09.2017

- Changed relative margins
- Changed phone link color to match web

- Fixed constraints on contentBlock content
- Fixed autolayout for audioplayer

## [3.5.2](https://github.com/xamoom/xamoom-ios-sdk/compare/3.5.1...3.5.2) - 30.08.2017

- Changed podspec to use subspecs for PushNotifications

## [3.5.1](https://github.com/xamoom/xamoom-ios-sdk/compare/3.5.0...3.5.1) - 29.08.2017

-  Reuploaded podspec

## [3.5.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.4.0...3.5.0) - 28.08.2017

- Added support for youtube timestamps

## [3.4.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.3.0...3.4.0) - 17.07.2017

- Added conditional content support

## [3.3.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.2.2...3.3.0) - 03.06.2017

- Added push notifications

- Changed to MIT License

## [3.2.2](https://github.com/xamoom/xamoom-ios-sdk/compare/3.2.1...3.2.2) - 31.05.2017

- Added italian translations

- Changed design of different contentBlocks

## [3.2.1](https://github.com/xamoom/xamoom-ios-sdk/compare/3.2.0...3.2.1) - 10.05.2017

- Added call as return value to all api calls

## [3.2.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.1.0...3.2.0) - 5.04.2017

- Changed image title to image caption. Is now below the image.
- Changed audio player. New design, forward backward seeking and playing indicator.

## [3.1.0](https://github.com/xamoom/xamoom-ios-sdk/compare/3.0.0...3.1.0) - 25.01.2017

- Added copyright to XMMContentBlock
- Added copyrightLabel to XMMContentBlock3TableViewCell

- Fixed offlineTags in `XMMOfflineStorageTagModule` were not saved. These are now saved to NSUserDefaults.

## [3.0.0](https://github.com/xamoom/xamoom-ios-sdk/compare/2.2.0...3.0.0) - 18.01.2017

- Added offline saving
- Added loading of Assets from XamoomSDK bundle
- Added blockType 00 for title (bigger font)
- Added custom user agent
- Added new integration tests
- Added instagram linkBlock
- Added customMeta to XMMContent & XMMSpot
- Added sorting to `spotsWithLocation` and `spotsWithTags` in `XMMEnduserApi`

- Fixed wrong api callbacks when error occurs
- Fixed loading of all spots in `XMMContentBlock9TableViewCell`

- Changed ContentBlockTableViewCell margins to bottom only

- Removed is-demo field from XMMSystem
- Removed XMMMenuItem

## [2.2.0](https://github.com/xamoom/xamoom-ios-sdk/compare/2.0.0...2.2.0) - 17.08.2016

- Changed youtube contentblock (webview + youtube link)

- Added viewWillAppear to XMMContentBlocks

- Fixed custom map pins

## [2.0.0](https://github.com/xamoom/xamoom-ios-sdk/compare/1.4.0...2.0.0) - 29.02.2016

- Added JSON-API support
- Added new XMMContentBlock layout
- Added new SpotMap Callout
- Added Vimeo support
- Added better image resizing
- Added tests

## 1.4.2 (outdated) - 11.01.2016

- Removed style from XMMClosestSpot

- Fixed bug with youtube-video-player
