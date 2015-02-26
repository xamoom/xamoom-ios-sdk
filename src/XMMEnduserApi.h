/**
 *
 *  Copyright 2015 by Raphael Seher <raphael@xamoom.com>
 *
 * This file is part of some open source application.
 *
 * Some open source application is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either
 * version 2 of the License, or (at your option) any later version.
 *
 * Some open source application is distributed in the hope that it will
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
 *
 */

#pragma mark imports

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

//Core Data
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

#pragma mark - Protocol / Delegate

@protocol XMEnderuserApiDelegate <NSObject>

@optional

/**
 Delegate to return the results from getContentById, getContentByLocation and getContentByLocationIdentifier as RKMappingResult.
 
 @param result - The result as RKMappingResult.
 @return void
 */
- (void)finishedLoadData:(RKMappingResult*)result;

/**
 Delegate to return the result from getContentById as XMMResponseGetById as XMMResponseGetByID.
 
 @param result - The result as XMMResponeGetById.
 @return void
 */
- (void)finishedLoadDataById:(XMMResponseGetById*)result;

/**
 Delegate to return the result from getContentByLocationIdentifier as XMMResponseGetByLocationIdentifier.
 
 @param result - The result as XMMResponseGetByLocationIdentifier.
 @return void
 */
- (void)finishedLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier*)result;

/**
 Delegate to return the result from getContentByLocation as XMMResponseGetByLocation.
 
 @param result - The result as XMMResponseGetByLocation.
 @return void
 */
- (void)finishedLoadDataByLocation:(XMMResponseGetByLocation*)result;

/**
 Delegate to notify that getContentByIdFromCoreData, getContentByLocationFromCoreData, getContentByLocationIdentifierFromCoreData
 are finished with core data. Now you can fetch the Core Data.
 
 @return void
 */
- (void)finishedLoadCoreData;

/**
 Delegate to notifiy that getContentFromRSSFeed are finished with loading and parsing the rss feed from url.
 
 @param result - The result as NSMuteableArray.
 @return void
 */
- (void)finishedLoadRSS:(NSMutableArray*)result;


@end

#pragma mark - XMMEnduserApi

@interface XMMEnduserApi : NSObject <NSXMLParserDelegate>

@property (nonatomic, assign) id<XMEnderuserApiDelegate> delegate;
@property NSURL *apiBaseURL;
@property NSString *rssBaseUrl;
@property NSMutableArray *rssEntries;

-(id)init;

#pragma mark - public methods

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Makes an api call to xamoom with a unique locationIdentifier (code saved on NFC or QR). If the selected language is not available the
 default language will be returned.
 
 @param locationIdentifier - The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Makes an api call to xamoom with a location (lat & lon). If the selected language is not available the
 default language will be returned.
 
 @param lat - The latitude of a location.
 @param lon - The longitude of a location.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocation:(NSString*)lat lon:(NSString*)lon language:(NSString*)language;

/**
 Sets up all configurations for RestKit to work with Core Data.
 
 @return void
 */
- (void)initRestkitCoreData;

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 Data will be saved in Core Data. Use -(NSArray*)fetchCoreDataContentBy:(NSString *)type to get saved data.
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByIdFromCoreData:(NSString *)contentId includeStyle:(NSString *)style includeMenu:(NSString *)menu language:(NSString *)language;

/**
 Makes an api call to xamoom with a unique locationIdentifier (code saved on NFC or QR). If the selected language is not 
 available the default language will be returned.
 Data will be saved in Core Data. Use -(NSArray*)fetchCoreDataContentBy:(NSString *)type to get saved data.
 
 @param locationIdentifier - The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocationIdentifierFromCoreData:(NSString *)locationIdentifier includeStyle:(NSString *)style includeMenu:(NSString *)menu language:(NSString *)language;

/**
 Makes an api call to xamoom with a location (lat & lon). If the selected language is not available the
 default language will be returned. Data will be saved in Core Data. Use -(NSArray*)fetchCoreDataContentBy:(NSString *)type 
 to get saved data.
 
 @param lat - The latitude of a location.
 @param lon - The longitude of a location.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocationFromCoreData:(NSString *)lat lon:(NSString *)lon language:(NSString *)language;

/**
 Returns an array of all objects with the specific type from Core Data. Type can be "id", "locationidentifier" or "location".
 
 @param type - The type of the saved data. Can be "id" or "location".
 @return NSArray*
 */
- (NSArray*)fetchCoreDataContentBy:(NSString *)type;

/**
 Description
 
 @param contentId - The content id from the entity you want to delete in core data
 @return BOOL - Yes if it got deleted, no if not.
 */
- (BOOL)deleteCoreDataEntityBy:(NSString *)contentId;

/**
 Gets the rss feed and parses it from a specific url.
 
 @return void
 */
- (void)getContentFromRSSFeed;

/**
 Gets the rss feed and parses it from a specific url.
 
 @return void
 */
- (void)startQRCodeReader:(UIViewController*)viewController withAPIRequest:(BOOL)automaticAPIRequest;

@end
