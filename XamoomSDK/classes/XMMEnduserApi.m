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

#import "XMMEnduserApi.h"
#import <dispatch/dispatch.h>

NSString * const kApiBaseURLString =
@"https://23-dot-xamoom-api-dot-xamoom-cloud.appspot.com/_api/v2/consumer";
NSString * const kHTTPContentType = @"application/vnd.api+json";
NSString * const kHTTPUserAgent = @"XamoomSDK iOS";

@interface XMMEnduserApi ()

@end

#pragma mark - XMMEnduserApi

@implementation XMMEnduserApi : NSObject

- (instancetype)initWithApiKey:(NSString *)apikey {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:@{@"Content-Type":kHTTPContentType,
                                     @"User-Agent":kHTTPUserAgent,
                                     @"APIKEY":apikey,}];
  
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString: kApiBaseURLString] session:[NSURLSession sessionWithConfiguration:config]];
  
  [self setupResources];
  return self;
}

- (instancetype)initWithRestClient:(XMMRestClient *)restClient {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  
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

#pragma mark public methods

- (void)contentWithID:(NSString *)contentID completion:(void(^)(XMMContent *content, NSError *error))completion {
  NSDictionary *params = @{@"lang":self.language};
  
  [self.restClient fetchResource:[XMMContent class] id:contentID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    XMMContent *content = result.resource;
    
    completion(content, error);
  }];
}

- (void)contentWithID:(NSString *)contentID options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  [params setObject:self.language forKey:@"lang"];
  
  if (options & XMMContentOptionsPreview) {
    [params setObject:@"true" forKey:@"preview"];
  }
  if (options & XMMContentOptionsPrivate) {
    [params setObject:@"true" forKey:@"public-only"];
  }
  
  [self.restClient fetchResource:[XMMContent class] id:contentID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    XMMContent *content = result.resource;
    
    completion(content, error);
  }];
}

- (void)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *content, NSError *error))completion {
  NSDictionary *params = @{@"lang":self.language,
                           @"filter[location-identifier]":locationIdentifier};
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    XMMContent *content = result.resource;
    
    completion(content, error);
  }];
}

- (void)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error))completion {
  [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] completion:completion];
}

- (void)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":self.language,
                                                                                  @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                                                  @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                                                  @"page[size]":[@(pageSize) stringValue]}];
  
  if (cursor != nil && ![cursor isEqualToString:@""]) {
    [params setObject:cursor forKey:@"page[cursor]"];
  }
  
  if (sortOptions != XMMContentSortOptionsNone) {
    NSArray *sortParameter = [self contentSortOptionsToArray:sortOptions];
    [params setObject:[sortParameter componentsJoinedByString:@","] forKey:@"sort"];
  }
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, NO, nil, error);
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    completion(result.resources, hasMore, cursor, error);
  }];
}

- (void)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  NSString *tagsAsParamter = [NSString stringWithFormat:@"[\"%@\"]", [tags componentsJoinedByString:@"\",\""]];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"lang":@"en",
                                                                                  @"filter[tags]":tagsAsParamter,
                                                                                  @"page[size]":[@(pageSize) stringValue]}];
  if (cursor != nil && ![cursor isEqualToString:@""]) {
    [params setObject:cursor forKey:@"page[cursor]"];
  }
  
  if (sortOptions != XMMContentSortOptionsNone) {
    NSArray *sortParameter = [self contentSortOptionsToArray:sortOptions];
    [params setObject:[sortParameter componentsJoinedByString:@","] forKey:@"sort"];
  }
  
  [self.restClient fetchResource:[XMMContent class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, NO, nil, error);
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    completion(result.resources, hasMore, cursor, error);
  }];
}

- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options completion:(void (^)(NSArray *spots, NSError *error))completion {
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":self.language,
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":[@(radius) stringValue]}];
  
  if (options & XMMSpotOptionsIncludeMarker) {
    [params setObject:@"true" forKey:@"include_marker"];
  }
  
  if (options & XMMSpotOptionsIncludeContent) {
    [params setObject:@"true" forKey:@"include_content"];
  }
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    completion(result.resources, error);
  }];
}

- (void)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":self.language,
                                                      @"filter[lat]":[@(location.coordinate.latitude) stringValue],
                                                      @"filter[lon]":[@(location.coordinate.longitude) stringValue],
                                                      @"filter[radius]":[@(radius) stringValue],
                                                      @"page[size]":[@(pageSize) stringValue]}];
  
  if (cursor != nil && ![cursor isEqualToString:@""]) {
    [params setObject:cursor forKey:@"page[cursor]"];
  }
  
  if (options & XMMSpotOptionsIncludeMarker) {
    [params setObject:@"true" forKey:@"include_marker"];
  }
  
  if (options & XMMSpotOptionsIncludeContent) {
    [params setObject:@"true" forKey:@"include_content"];
  }
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, false, nil, error);
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    completion(result.resources, hasMore, cursor, error);
  }];
}

- (void)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSString *tagsAsParamter = [NSString stringWithFormat:@"[\"%@\"]", [tags componentsJoinedByString:@"\",\""]];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{@"lang":self.language,
                                                      @"filter[tags]":tagsAsParamter,
                                                      @"page[size]":[@(pageSize) stringValue]}];
  
  if (cursor != nil && ![cursor isEqualToString:@""]) {
    [params setObject:cursor forKey:@"page[cursor]"];
  }
  
  if (options & XMMSpotOptionsIncludeMarker) {
    [params setObject:@"true" forKey:@"include_marker"];
  }
  
  if (options & XMMSpotOptionsIncludeContent) {
    [params setObject:@"true" forKey:@"include_content"];
  }
  
  if (sortOptions != XMMSpotOptionsNone) {
    NSArray *sortParameter = [self spotSortOptionsToArray:sortOptions];
    [params setObject:[sortParameter componentsJoinedByString:@","] forKey:@"sort"];
  }
  
  [self.restClient fetchResource:[XMMSpot class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, false, nil, error);
    }
    
    NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
    bool hasMore = [hasMoreValue boolValue];
    NSString *cursor = [result.meta objectForKey:@"cursor"];
    
    completion(result.resources, hasMore, cursor, error);
  }];
}

- (void)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion {
  NSDictionary *params = @{@"lang":self.language};
  [self.restClient fetchResource:[XMMSystem class] parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    XMMSystem *system = result.resource;
    
    completion(system, error);
  }];
}

- (void)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion {
  NSDictionary *params = @{@"lang":self.language};
  [self.restClient fetchResource:[XMMSystemSettings class] id:settingsID parameters:params completion:^(JSONAPI *result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    
    XMMSystemSettings *settings = result.resource;
    
    completion(settings, error);
  }];
}

#pragma mark - deprecated API calls

- (void)contentWithContentID:(NSString*)contentID includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full preview:(BOOL)preview completion:(void(^)(XMMContentById *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  
}

- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier majorId:(NSString*)majorId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language completion:(void(^)(XMMContentByLocationIdentifier *result))completionHandler error:(void(^)(XMMError *error))errorHandler{
  
}

- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language completion:(void(^)(XMMContentByLocation *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
}

- (void)spotMapWithMapTags:(NSArray *)mapTags withLanguage:(NSString *)language includeContent:(BOOL)includeContent completion:(void(^)(XMMSpotMap *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
}

- (void)contentListWithPageSize:(int)pageSize withLanguage:(NSString*)language withCursor:(NSString*)cursor withTags:(NSArray*)tags completion:(void(^)(XMMContentList *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  
}

- (void)closestSpotsWithLat:(float)lat withLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language completion:(void(^)(XMMClosestSpot *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  
}

#pragma mark - private helpers

- (NSArray *)contentSortOptionsToArray:(XMMContentSortOptions)sortOptions {
  NSMutableArray *sortParameters = [[NSMutableArray alloc] init];
  
  if (sortOptions & XMMContentSortOptionsName) {
    [sortParameters addObject:@"name"];
  }
  
  if (sortOptions & XMMContentSortOptionsNameDesc) {
    [sortParameters addObject:@"-name"];
  }
  
  return sortParameters;
}

- (NSArray *)spotSortOptionsToArray:(XMMSpotSortOptions)sortOptions {
  NSMutableArray *sortParameters = [[NSMutableArray alloc] init];
  
  if (sortOptions & XMMSpotSortOptionsName) {
    [sortParameters addObject:@"name"];
  }
  
  if (sortOptions & XMMSpotSortOptionsNameDesc) {
    [sortParameters addObject:@"-name"];
  }
  
  if (sortOptions & XMMSpotSortOptionsDistance) {
    [sortParameters addObject:@"distance"];
  }
  
  if (sortOptions & XMMSpotSortOptionsDistanceDesc) {
    [sortParameters addObject:@"-distance"];
  }
  
  return sortParameters;
}

@end
