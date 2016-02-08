//
//  XMMEnduserApi.m
//  XamoomSDK
//
//  Created by Raphael Seher on 14/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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
#import <CoreLocation/CoreLocation.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import "XMMRestClient.h"
#import "XMMError.h"
#import "XMMSpotMap.h"
#import "XMMSpot.h"
#import "XMMStyle.h"
#import "XMMSystem.h"
#import "XMMMenu.h"
#import "XMMMenuItem.h"
#import "XMMContent.h"
#import "XMMContentBlock.h"
#import "XMMMarker.h"

@class XMMContentById;
@class XMMContentByLocation;
@class XMMContentByLocationIdentifier;
@class XMMSpotMap;
@class XMMContentList;
@class XMMClosestSpot;

#pragma mark - XMMEnduserApi

extern NSString * const kApiBaseURLString;

typedef NS_OPTIONS(NSUInteger, XMMContentOptions) {
  XMMContentOptionsNone = 1 << 0,
  /**
   * Will not save statistics.
   */
  XMMContentOptionsPreview = 1 << 0,
  /**
   * Wont return ContentBlocks with "Hide Online" flag.
   */
  XMMContentOptionsPrivate = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, XMMSpotOptions) {
  XMMSpotOptionsNone = 0 << 0,
  XMMSpotOptionsIncludeContent = 1 << 0,
  XMMSpotOptionsIncludeMarker = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, XMMContentSortOptions) {
  XMMContentSortOptionsNone = 0 << 0,
  XMMContentSortOptionsName = 1 << 0,
  XMMContentSortOptionsNameDesc = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, XMMSpotSortOptions) {
  XMMSpotSortOptionsNone = 0 << 0,
  XMMSpotSortOptionsName = 1 << 0,
  XMMSpotSortOptionsNameDesc = 1 << 1,
  XMMSpotSortOptionsDistance = 1 << 2,
  XMMSpotSortOptionsDistanceDesc = 1 << 3,
};

/**
 *`XMMEnduserApi` is the main part of the xamoom-ios-sdk. You can use it to send api request to the xamoom-api.
 *
 * For everything just use the shared instance: [XMMEnduserApi sharedInstance].
 *
 * Before you can start you have to set a API key: [[XMMEnduserApi sharedInstance] setApiKey:apiKey];
 */
@interface XMMEnduserApi : NSObject

#pragma mark Properties
/// @name Properties

/**
 * The preferred language of the user.
 */
@property (strong, nonatomic) NSString *systemLanguage;
/**
 * Language used in api calls.
 */
@property (strong, nonatomic) NSString *language;
/**
 * XMMRestClient used to call rest api.
 */
@property (strong, nonatomic) XMMRestClient *restClient;

/// @name Inits

/**
 * Initializes with a apikey. You find your apikey in your xamoom system under
 * xamoom.net - Settings.
 * 
 * @param apikey Your xamoom api key
 */
- (instancetype)initWithApiKey:(NSString *)apikey;

/**
 * Initializes with a custom base url and custom configuration for NSURLSession.
 * 
 * @param url Custom url to xamoom system
 * @param config Custom NSURLConfiguration
 */
- (instancetype)initWithRestClient:(XMMRestClient *)restClient;

#pragma mark - public methods

/**
 * API call to get content with specific ID.
 *
 * @param contentID ContentID of xamoom content
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)contentWithID:(NSString *)contentID completion:(void(^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with specific ID and options.
 *
 * @param contentID ContentID of xamoom content
 * @param options XMMContentOptions for call
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)contentWithID:(NSString *)contentID options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with specific location-identifier.
 *
 * @param locationIdentifier Locationidentifier from xamoom marker
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with beacon.
 *
 * @param major Major of the beacon
 * @param minor Minor of the beacon
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get contents around location (40m).
 *
 * @param location Location of the user
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param sort XMMContentSortOptions to sort result
 * @param completion Completion block called after finishing network request
 * - *param1* contents Contents from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 */
- (void)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get contents with specific tags.
 * 
 * @param tags Array of tags
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param sort XMMContentSortOptions to sort result
 * @param completion Completion block called after finishing network request
 * - *param1* contents Contents from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 */
- (void)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get spots inside radius of a location.
 * 
 * @param location Location of the user
 * @param radius Radius in meter
 * @param options XMMSpotOptions to get markers or content
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options completion:(void (^)(NSArray *spots, NSError *error))completion;

/**
 * API call to get spots inside radius of a location.
 *
 * @param location Location of the user
 * @param radius Radius in meter
 * @param options XMMSpotOptions to get markers or content
 * @param completion Completion block called after finishing network request
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 */
- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get spots with specific tags.
 *
 * @param tags Array of tags
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param options XMMSpotOptions to get markers or content
 * @param sort XMMSpotSortOptions to sort results
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 */
- (void)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call that returns your system.
 * 
 * @param completion Completion block called after finishing network request
 * - *param1* system System from xamoom system
 * - *param2* error NSError, can be null
 */
- (void)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion;

/**
 * API call that returns your system settings.
 *
 * @param settingsID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* settings System settings from your xamoom system
 * - *param2* error NSError, can be null
 */
- (void)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion;

/**
 * API call that returns your system style.
 *
 * @param styleID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* style System style from your xamoom system
 * - *param2* error NSError, can be null
 */
- (void)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *style, NSError *error))completion;

/**
 * API call that returns your menu.
 *
 * @param menuID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* style System style from your xamoom system
 * - *param2* error NSError, can be null
 */
- (void)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *menu, NSError *error))completion;

@end
