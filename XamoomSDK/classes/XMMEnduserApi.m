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

static XMMEnduserApi *sharedInstance;

@interface XMMEnduserApi ()

@end

#pragma mark - XMMEnduserApi

@implementation XMMEnduserApi : NSObject

+ (XMMEnduserApi *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMEnduserApi alloc] init];
  }
  
  return sharedInstance;
}

- (instancetype)initWithApiKey:(NSString *)apikey {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  return self;
}

- (instancetype)initWithApiKey:(NSString *)apikey baseUrl:(NSURL *)url {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  
  return self;
}

- (NSString *)systemLanguageWithoutRegionCode {
  NSString *preferredLanguage = [NSLocale preferredLanguages][0];
  return [preferredLanguage substringWithRange:NSMakeRange(0, 2)];
}

#pragma mark public methods

- (void)test {
  
}

#pragma deprecated API calls

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full preview:(BOOL)preview completion:(void(^)(XMMContentById *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
 
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

- (void)geofenceAnalyticsMessageWithRequestedLanguage:(NSString*)requestedLanguage withDeliveredLanguage:(NSString*)deliveredLanguage withSystemId:(NSString*)systemId withSystemName:(NSString*)systemName withContentId:(NSString*)contentId withContentName:(NSString*)contentName withSpotId:(NSString*)spotId withSpotName:(NSString*)spotName {
 
}

@end
