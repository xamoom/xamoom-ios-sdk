//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
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

#import "XMMEnduserApi.h"
#import <dispatch/dispatch.h>

NSString * const kApiBaseURLString = @"https://xamoom-cloud.appspot.com/_api/v2/consumer";
NSString * const kHTTPContentType = @"application/vnd.api+json";
NSString * const kHTTPUserAgent = @"XamoomSDK iOS";
NSString * const kSDKVersion = @"2.2.0";

@interface XMMEnduserApi ()

@end

#pragma mark - XMMEnduserApi

/**
 * Shared instance.
 */
static XMMEnduserApi *sharedInstance;

@implementation XMMEnduserApi : NSObject

#pragma mark - shared instance

+ (instancetype)sharedInstanceWithKey:(NSString *)apikey {
  NSAssert(apikey != nil, @"apikey is nil. Please use an apikey");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] initWithApiKey:apikey];
  });
  return sharedInstance;
}

+ (instancetype)sharedInstance {
  NSAssert(sharedInstance != nil, @"SharedInstance is nil. Use sharedInstanceWithKey:apikey or saveSharedInstance:instance");
  return sharedInstance;
}

+ (void)saveSharedInstance:(XMMEnduserApi *)instance {
  sharedInstance = instance;
}

#pragma mark - init

- (instancetype)initWithApiKey:(NSString *)apikey {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [[XMMOfflineStorageManager sharedInstance] init];
  
  NSString *customUserAgent = [NSString stringWithFormat:@"%@|%@|%@",
                               kHTTPUserAgent,
                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"],
                               kSDKVersion];
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:@{@"Content-Type":kHTTPContentType,
                                     @"User-Agent":customUserAgent,
                                     @"APIKEY":apikey,}];
  
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString: kApiBaseURLString]
                                                   session:[NSURLSession sessionWithConfiguration:config]];
  
  [self setupResources];
  return self;
}

- (instancetype)initWithRestClient:(XMMRestClient *)restClient {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [XMMOfflineStorageManager sharedInstance];
  
  self.restClient = restClient;
  [self setupResources];
  return self;
}

- (NSString *)systemLanguageWithoutRegionCode {
  NSString *preferredLanguage = [NSLocale preferredLanguages][0];
  return [preferredLanguage substringWithRange:NSMakeRange(0, 2)];
}

- (void)setupResources {
  [JSONAPIResourceDescriptor addResource:[XMMSystem class]];
  [JSONAPIResourceDescriptor addResource:[XMMSystemSettings class]];
  [JSONAPIResourceDescriptor addResource:[XMMStyle class]];
  [JSONAPIResourceDescriptor addResource:[XMMMenu class]];
  [JSONAPIResourceDescriptor addResource:[XMMMenuItem class]];
  [JSONAPIResourceDescriptor addResource:[XMMContent class]];
  [JSONAPIResourceDescriptor addResource:[XMMContentBlock class]];
  [JSONAPIResourceDescriptor addResource:[XMMSpot class]];
  [JSONAPIResourceDescriptor addResource:[XMMMarker class]];
}

#pragma mark - public methods

#pragma mark content calls

- (void)contentWithID:(NSString *)contentID completion:(void(^)(XMMContent *content, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithID:contentID completion:completion];
    return;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  [self.restClient fetchResource:[XMMContent class] id:contentID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMContent *content = result.resource;
    
    if (completion) {
      completion(content, error);
    }
  }];
}

- (void)contentWithID:(NSString *)contentID options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithID:contentID completion:completion];
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addContentOptionsToParams:params options:options];
  
  [self.restClient fetchResource:[XMMContent class] id:contentID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMContent *content = result.resource;
    
    if (completion) {
      completion(content, error);
    }
  }];
}

- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *content, NSError *error))completion {
  [self contentWithLocationIdentifier:locationIdentifier options:0 completion:completion];
}

- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithLocationIdentifier:locationIdentifier completion:completion];
    return;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language locationIdentifier:locationIdentifier];
  params = [XMMParamHelper addContentOptionsToParams:params options:options];
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMContent *content = result.resource;
    
    if (completion) {
      completion(content, error);
    }
  }];
}

- (void)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error))completion {
  [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] completion:completion];
}

- (void)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] options:options completion:completion];
}

#pragma mark contents calls

- (void)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, NO, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
}

- (void)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language tags:tags];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, NO, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
}

- (void)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language name:name];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, NO, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
  
}

#pragma mark spot calls

- (void)spotWithID:(NSString *)spotID completion:(void (^)(XMMSpot *, NSError *))completion {
  [self spotWithID:spotID options:XMMSpotOptionsNone completion:completion];
}

- (void)spotWithID:(NSString *)spotID options:(XMMSpotOptions)options completion:(void(^)(XMMSpot *spot, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  
  [self.restClient fetchResource:[XMMSpot class] id:spotID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMSpot *spot = result.resource;
    
    if (completion) {
      completion(spot, error);
    }
  }];
}

#pragma mark spots calls

- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  [self spotsWithLocation:location radius:radius options:options pageSize:0 cursor:nil completion:completion];
}

- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location radius:radius];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, false, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
}

- (void)spotsWithTags:(NSArray *)tags options:(XMMSpotOptions)options completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  [self spotsWithTags:tags pageSize:100 cursor:nil options:options sort:XMMSpotSortOptionsNone completion:completion];
}

- (void)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language tags:tags];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, false, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
}

- (void)spotsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language name:name];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, false, nil, error);
      return;
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    if (completion) {
      completion(result.resources, hasMore, cursor, error);
    }
  }];
}

#pragma mark system calls

- (void)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  [self.restClient fetchResource:[XMMSystem class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMSystem *system = result.resource;
    
    if (completion) {
      completion(system, error);
    }
  }];
}

- (void)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  [self.restClient fetchResource:[XMMSystemSettings class] id:settingsID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMSystemSettings *settings = result.resource;
    
    if (completion) {
      completion(settings, error);
    }
  }];
}

- (void)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *style, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  [self.restClient fetchResource:[XMMStyle class] id:styleID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMStyle *style = result.resource;
    
    if (completion) {
      completion(style, error);
    }
  }];
}

- (void)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *menu, NSError *error))completion {
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  [self.restClient fetchResource:[XMMMenu class] id:menuID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error && completion) {
      completion(nil, error);
      return;
    }
    
    XMMMenu *menu = result.resource;
    
    if (completion) {
      completion(menu, error);
    }
  }];
}

@end
