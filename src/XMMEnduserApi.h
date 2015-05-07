//
// Copyright 2015 by Raphael Seher <raphael@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "XMMRSSEntry.h"
#import "NSString+HTML.h"
#import "QRCodeReaderViewController.h"
#import "XMMResponseGetById.h"
#import "XMMResponseGetByLocationIdentifier.h"
#import "XMMResponseGetByLocation.h"
#import "XMMResponseGetByLocationItem.h"
#import "XMMResponseGetSpotMap.h"
#import "XMMResponseGetSpotMapItem.h"
#import "XMMResponseStyle.h"
#import "XMMResponseMenuItem.h"
#import "XMMResponseContent.h"
#import "XMMResponseContentBlock.h"
#import "XMMResponseContentBlockType0.h"
#import "XMMResponseContentBlockType1.h"
#import "XMMResponseContentBlockType2.h"
#import "XMMResponseContentBlockType3.h"
#import "XMMResponseContentBlockType4.h"
#import "XMMResponseContentBlockType5.h"
#import "XMMResponseContentBlockType6.h"
#import "XMMResponseContentBlockType7.h"
#import "XMMResponseContentBlockType8.h"
#import "XMMResponseContentBlockType9.h"
#import "XMMResponseContentList.h"
#import "XMMResponseClosestSpot.h"
#import "XMMCoreDataGetById.h"
#import "XMMCoreDataStyle.h"
#import "XMMCoreDataMenuItem.h"
#import "XMMCoreDataContent.h"
#import "XMMCoreDataContentBlocks.h"
#import "XMMCoreDataGetByLocation.h"
#import "XMMCoreDataGetByLocationItem.h"

@class XMMResponseGetById;
@class XMMResponseGetByLocation;
@class XMMResponseGetByLocationIdentifier;
@class XMMResponseGetSpotMap;
@class XMMResponseContentList;
@class XMMResponseClosestSpot;

#pragma mark - XMMEnderuserApiDelegate

/**
 `XMMEnderuserApiDelegate` is declared in `XMMEnduserApi`.
 
 It is a collection of delegates for `XMMEnduserApi`.
 */
@protocol XMMEnduserApiDelegate <NSObject>

@optional

/// @name API Call Delegates

/**
 Delegate to return the result from getContentById as XMMResponseGetById as XMMResponseGetByID.
 
 @param result - The result as XMMResponeGetById.
 @return void
 */
- (void)didLoadDataWithContentId:(XMMResponseGetById*)result;

/**
 Delegate to return the result from getContentByLocationIdentifier as XMMResponseGetByLocationIdentifier.
 
 @param result - The result as XMMResponseGetByLocationIdentifier.
 @return void
 */
- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier*)result;

/**
 Delegate to return the result from getContentByLocation as XMMResponseGetByLocation.
 
 @param result - The result as XMMResponseGetByLocation.
 @return void
 */
- (void)didLoadDataWithLocation:(XMMResponseGetByLocation*)result;

/**
 Delegate to return the result from getSpotMap as XMMResponseGetSpotMap.
 
 @param result - The result as XMMResponseGetSpotMap.
 @return void
 */
- (void)didLoadSpotMap:(XMMResponseGetSpotMap*)result;

/**
 Delegate to return the result from getContentList as XMMResponseContentList.
 
 @param result - The result as XMMResponseContentList.
 @return void
 */
- (void)didLoadContentList:(XMMResponseContentList*)result;

/**
 Delegate to return the result from closestSpots as XMMResponseClosestSpot.
 
 @param result - The result as XMMResponseClosestSpot.
 @return void
 */
- (void)didLoadClosestSpots:(XMMResponseClosestSpot*)result;

/// @name Core Data DelegatesXMMResponseClosestSpot

/**
 Delegate to notify that getContentForCoreDataById is finished with core data. Now you can fetch the Core Data.
 
 @return void
 */
- (void)savedContentToCoreDataWithContentId;

/**
 Delegate to notify that getContentForCoreDataByLocationIdentifier is finished with core data. Now you can fetch the Core Data.
 
 @return void
 */
- (void)savedContentToCoreDataWithLocationIdentifier;

/**
 Delegate to notify that getContentForCoreDataByLocation is finished with core data. Now you can fetch the Core Data.
 
 @return void
 */
- (void)savedContentToCoreDataWithLocation;

/// @name RSS Delegate

/**
 Delegate to notifiy that getContentFromRSSFeed are finished with loading and parsing the rss feed from url.
 
 @param result - The result as NSMuteableArray.
 @return void
 */
- (void)didLoadRSS:(NSMutableArray*)result;

/**
 Delegate to notifiy that the qr code scanner scanned a qr code.
 
 @param result - The loaded locationIdentifier.
 @return void
 */
- (void)didScanQR:(NSString*)result;

@end

#pragma mark - XMMEnduserApi

extern NSString * const kXamoomAPIToken;
extern NSString * const kXamoomAPIBaseUrl;
extern NSString * const kApiBaseURLString;

/**
 `XMMEnduserApi` is the main part of the xamoom-ios-sdk. You will need to create a instance of this to communicate with our api and set the delegate.
 If you want to use the build in core data, you must call `initCoreData`.
 
 
 _Set up xamoom-ios-sdk like this:_
 
 api = [[XMMEnduserApi alloc] init];
 api.delegate = self;
 [api initCoreData];
 
 */
@interface XMMEnduserApi : NSObject <NSXMLParserDelegate>

#pragma mark Properties
/// @name Properties

/**
 Some description
 */
@property (nonatomic, weak) id<XMMEnduserApiDelegate> delegate;
/**
 The base url of xamoom api.
 (readonly)
 */
@property (readonly) NSURL *apiBaseURL;
/**
 The base url of xamoom rss feed. You can change this one another url.
 */
@property NSString *rssBaseUrlString;
/**
 The preferred language of the user.
 */
@property NSString *systemLanguage;
/**
 Bool to check if the CoreData is initialized.
 */
@property (readonly) BOOL isCoreDataInitialized;
/**
 String with the title of the qr code view cancel button.
 */
@property NSString* qrCodeViewControllerCancelButtonTitle;
/**
 A shared instance from XMMEnduserApi.
 */
+ (XMMEnduserApi *) sharedInstance;

/// @name Inits

/**
 Inits the XMMEnduserApi: generates the apiBaseUrl and the rssBaseUrl and gets the preferred systemLanguage.
 
 @return id
 */
-(instancetype)init NS_DESIGNATED_INITIALIZER;

#pragma mark - public methods

/// @name API Calls

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param contentId   The id of the content from xamoom backend.
 @param style       True or False for returning the style from xamoom backend.
 @param menu        True of False for returning the menu from xamoom backend.
 @param language    The requested language of the content from xamoom backend.
 @return void
 */
- (void)contentWithContentId:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)menu withLanguage:(NSString*)language;

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param contentId   The id of the content from xamoom backend.
 @param style       True or False for returning the style from xamoom backend.
 @param menu        True or False for returning the menu from xamoom backend.
 @param language    The requested language of the content from xamoom backend.
 @param full        True or false for returning "unsynced" data or not
 @return void
 */
- (void)contentWithContentId:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)menu withLanguage:(NSString*)language full:(NSString*)full;


/**
 Makes an api call to xamoom with a unique locationIdentifier (code saved on NFC or QR). If the selected language is not available the
 default language will be returned.
 
 @param locationIdentifier  The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend.
 @param style               True or False for returning the style from xamoom backend.
 @param menu                True of False for returning the menu from xamoom backend.
 @param language            The requested language of the content from xamoom backend.
 @return void
 */
- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)menu withLanguage:(NSString*)language;
/**
 Makes an api call to xamoom with a location (lat & lon). If the selected language is not available the
 default language will be returned.
 
 @param lat         The latitude of a location.
 @param lon         The longitude of a location.
 @param language    The requested language of the content from xamoom backend.
 @return void
 */
- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language;

/**
 Makes an api call to xamoom with params to get a list of all items, so you can show them on a map.
 
 @param systemId    The id of the wanted system.
 @param mapTags     The Tags of the wanted spots.
 @param language    The requested language of the content from xamoom backend.
 @return void
 */
- (void)spotMapWithSystemId:(NSString*)systemId withMapTags:(NSString*)mapTags withLanguage:(NSString*)language;

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param systemId   The id of the system from xamoom.
 @param language   The requested language of the content from xamoom backend.
 @param pageSize   Number of items you will get returned
 @param cursor     Cursor for paging
 @return void
 */
- (void)contentListWithSystemId:(NSString*)systemId withLanguage:(NSString*)language withPageSize:(int)pageSize withCursor:(NSString*)cursor;

/**
 Makes an api call to xamoom with a location and returns the closest spots.
 If the selected language is not available the default language will be returned.
 
 @param lat     Latitude
 @param lon     Longitude
 @param radius  Radius in decimenter
 @param limit   Limit of the results
 @return void
 */
- (void)closestSpotsWith:(float)lat andLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language;

#pragma mark - Core Data

/// @name Core Data

/**
 Sets up all configurations for RestKit to work with Core Data.
 
 @warning Must be called before using any other core data related method.
 (`getContentForCoreDataById:includeStyle:includeMenu:withLanguage:`,
 `getContentForCoreDataByLocationIdentifier:includeStyle:includeMenu:withLanguage:`,
 `getContentForCoreDataByLocationWithLat:withLon:withLon:`,
 `fetchCoreDataContentByType:`,
 `deleteCoreDataEntityById:`)
 @return void
 */
- (void)initCoreData;

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 Data will be saved in Core Data as `XMMCoreDataGetById`. Use `fetchCoreDataContentByType:` to get saved data.
 
 @param contentId   The id of the content from xamoom backend.
 @param style       True or False for returning the style from xamoom backend.
 @param menu        True of False for returning the menu from xamoom backend.
 @param language    The requested language of the content from xamoom backend.
 @return void
 */
- (void)saveContentToCoreDataWithContentId:(NSString *)contentId includeStyle:(NSString *)style includeMenu:(NSString *)menu withLanguage:(NSString *)language;

/**
 Makes an api call to xamoom with a unique locationIdentifier (code saved on NFC or QR). If the selected language is not
 available the default language will be returned.
 Data will be saved in Core Data as `XMMCoreDataGetById`. Use `fetchCoreDataContentByType:` to get saved data.
 
 @param locationIdentifier  The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend.
 @param style               True or False for returning the style from xamoom backend.
 @param menu                True of False for returning the menu from xamoom backend.
 @param language            The requested language of the content from xamoom backend.
 @return void
 */
- (void)saveContentToCoreDataWithLocationIdentifier:(NSString *)locationIdentifier includeStyle:(NSString *)style includeMenu:(NSString *)menu withLanguage:(NSString *)language;

/**
 Makes an api call to xamoom with a location (lat & lon). If the selected language is not available the
 default language will be returned as `XMMCoreDataGetByLocation`. Data will be saved in Core Data. Use `fetchCoreDataContentByType:` to get saved data.
 
 @param lat         The latitude of a location.
 @param lon         The longitude of a location.
 @param language    The requested language of the content from xamoom backend.
 @return void
 */
- (void)saveContentToCoreDataWithLat:(NSString *)lat withLon:(NSString *)lon withLanguage:(NSString *)language;

/**
 Returns an array of all objects with the specific type from Core Data. Type can be "id" or "location".
 
 @param type    The type of the saved data. Can be "id" or "location".
 @return NSArray*
 */
- (NSArray*)fetchCoreDataContentWithType:(NSString *)type;

/**
 Deletes a entity in Core Data with the given contentId.
 
 @param contentId   The content id from the entity you want to delete in core data
 @return BOOL       Yes if it got deleted, no if not.
 */
- (BOOL)deleteCoreDataEntityWithContentId:(NSString *)contentId;

#pragma mark - RSS

/// @name RSS

/**
 Gets the rss feed and parses it from a specific url (`rssBaseUrl`).
 
 @return void
 */
- (void)rssContentFeed;

#pragma mark - QRCodeReaderViewController

/// @name QRCodeReaderViewController

/**
 Starts the QRCodeReaderViewController to scan qr codes.
 
 There are 2 delegates you can use:
 
 + reader:didScanResult:
 + readerDidCancel:
 
 In code it would be look like this:
 
 - (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
 {
 [self dismissViewControllerAnimated:YES completion:^{
 NSLog(@"Completion with result: %@", result);
 }];
 }
 
 - (void)readerDidCancel:(QRCodeReaderViewController *)reader
 {
 NSLog(@"readerDidCancel");
 [self dismissViewControllerAnimated:YES completion:NULL];
 }
 
 @param viewController          The ViewController from where you want to call the QRCodeReader (usually self)
 @param language                The returned language of the automaticApiRequest
 @return void
 */
- (void)startQRCodeReaderFromViewController:(UIViewController*)viewController withLanguage:(NSString*)language;

@end
