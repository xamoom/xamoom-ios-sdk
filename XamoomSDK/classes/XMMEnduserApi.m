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
@"https://22-dot-xamoom-api-dot-xamoom-cloud.appspot.com/_api/v2/consumer";
NSString * const kHTTPContentType = @"application/vnd.api+json";
NSString * const kHTTPUserAgent = @"XamoomSDK iOS";

typedef NS_OPTIONS(NSUInteger, XMMContentOptions) {
  XMMContentOptionsPreview = 1 << 0,
  XMMContentOptionsPrivate = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, XMMSpotOptions) {
  XMMSpotOptionsIncludeContent = 1 << 0,
  XMMSpotOptionsIncludeMarker = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, XMMSortOptions) {
  XMMSortOptionsName = 1 << 0,
  XMMSortOptionsNameDesc = 1 << 1,
  XMMSortOptionsDistance = 1 << 2,
  XMMSortOptionsDistanceDesc = 1 << 3,
};

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

#pragma deprecated API calls

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

@end
