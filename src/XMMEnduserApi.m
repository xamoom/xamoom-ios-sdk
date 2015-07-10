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

#import "XMMEnduserApi.h"
#import <RestKit/RestKit.h>
#import <dispatch/dispatch.h>

//NSString * const kApiBaseURLString = @"https://xamoom-api-dot-xamoom-cloud.appspot.com/_ah/api/";
NSString * const kApiBaseURLString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_ah/api/";
NSString * const kRSSBaseURLString = @"http://xamoom.com/feed/";

static XMMEnduserApi *sharedInstance;

@interface XMMEnduserApi () <QRCodeReaderDelegate>

@property NSMutableArray *rssEntries;
@property NSMutableString *element;
@property XMMRSSEntry *rssItem;
@property BOOL isQRCodeScanFinished;
@property dispatch_queue_t backgroundQueue;
@property UIViewController *qrCodeParentViewController;

@end

#pragma mark - XMMEnduserApi

@implementation XMMEnduserApi : NSObject

@synthesize apiBaseURL;
@synthesize isCoreDataInitialized;

+ (XMMEnduserApi *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMEnduserApi alloc] init];
  }
  
  return sharedInstance;
}

-(instancetype)init {
  self = [super init];
  apiBaseURL = [NSURL URLWithString:kApiBaseURLString];
  self.rssBaseUrlString = kRSSBaseURLString;
  self.systemLanguage = [NSLocale preferredLanguages][0];
  isCoreDataInitialized = NO;
  self.qrCodeViewControllerCancelButtonTitle = @"Cancel";
  
  //create RKObjectManager
  RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:apiBaseURL];
  [RKObjectManager setSharedManager:objectManager];
  
  //get apikey from file
  NSString* path = [[NSBundle mainBundle] pathForResource:@"api"
                                                   ofType:@"txt"];
  NSString* apiKey = [NSString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
  
  //set JSON-Type and Authorization Header
  [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:apiKey];
  
  apiKey = nil;
  //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    
  return self;
}

#pragma mark public methods
#pragma mark API calls

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetById *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  
  NSDictionary *queryParams = @{@"content_id":contentId,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                };
  
  // Create mappings
  RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
  
  RKObjectMapping* responseMapping = [XMMResponseGetById mapping];
  RKObjectMapping* responseContentMapping = [XMMResponseContent mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem mapping];
  
  // Add dynamic matchers
  [dynamicMapping addMatcher:[XMMResponseContentBlockType0 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType1 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType2 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType3 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType4 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType5 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType6 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType7 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType8 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType9 dynamicMappingMatcher]];
  
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                  toKeyPath:@"content"
                                                                                withMapping:responseContentMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                  toKeyPath:@"content.contentBlocks"
                                                                                withMapping:dynamicMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu.items"
                                                                                  toKeyPath:@"menu"
                                                                                withMapping:responseMenuMapping]];
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id";

  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        XMMResponseGetById *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Hellno: %@", error);
                                        errorHandler([XMMError new]);
                                      }
   ];
}

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full completion:(void(^)(XMMResponseGetById *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  NSDictionary *queryParams = @{@"content_id":contentId,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                @"full":(full) ? @"True" : @"False",
                                };
  
  // Create mappings
  RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
  
  RKObjectMapping* responseMapping = [XMMResponseGetById mapping];
  RKObjectMapping* responseContentMapping = [XMMResponseContent mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem mapping];
  
  // Add dynamic matchers
  [dynamicMapping addMatcher:[XMMResponseContentBlockType0 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType1 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType2 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType3 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType4 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType5 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType6 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType7 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType8 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType9 dynamicMappingMatcher]];
  
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                  toKeyPath:@"content"
                                                                                withMapping:responseContentMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                  toKeyPath:@"content.contentBlocks"
                                                                                withMapping:dynamicMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu.items"
                                                                                  toKeyPath:@"menu"
                                                                                withMapping:responseMenuMapping]];
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id_full";

  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        XMMResponseGetById *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Hellno: %@", error);
                                        errorHandler([XMMError new]);
                                      }
   ];
}

- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocationIdentifier *result))completionHandler error:(void(^)(XMMError *error))errorHandler{
  
  NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                };
  
  // Create mappings
  RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
  
  RKObjectMapping* responseMapping = [XMMResponseGetByLocationIdentifier mapping];
  RKObjectMapping* responseContentMapping = [XMMResponseContent mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem mapping];
  
  // Add dynamic matchers
  [dynamicMapping addMatcher:[XMMResponseContentBlockType0 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType1 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType2 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType3 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType4 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType5 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType6 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType7 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType8 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType9 dynamicMappingMatcher]];
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                  toKeyPath:@"content"
                                                                                withMapping:responseContentMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                  toKeyPath:@"content.contentBlocks"
                                                                                withMapping:dynamicMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu.items"
                                                                                  toKeyPath:@"menu"
                                                                                withMapping:responseMenuMapping]];
  
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location_identifier";
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        XMMResponseGetByLocationIdentifier *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Hellno: %@", error);
                                        errorHandler([XMMError new]);
                                      }
   ];
}

- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocation *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  NSDictionary *queryParams = @{@"location":
                                  @{@"lat":lat,
                                    @"lon":lon,
                                    },
                                @"language":language,
                                };
  
  // Create mappings
  RKObjectMapping* responseMapping = [XMMResponseGetByLocation mapping];
  RKObjectMapping* responseItemMapping = [XMMResponseGetByLocationItem mapping];
  
  // Create relationship
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location";
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        XMMResponseGetByLocation *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Hellno: %@", error);
                                        errorHandler([XMMError new]);
                                      }
   ];
}

- (void)spotMapWithSystemId:(int)systemId withMapTags:(NSArray *)mapTags withLanguage:(NSString *)language completion:(void(^)(XMMResponseGetSpotMap *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  RKObjectMapping* responseMapping = [XMMResponseGetSpotMap mapping];
  RKObjectMapping* responseItemMapping = [XMMResponseGetSpotMapItem mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/spotmap/%i/%@/%@", systemId, [mapTags componentsJoinedByString:@","], language];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"Output: %@", mappingResult.firstObject);
                                       XMMResponseGetSpotMap *result = mappingResult.firstObject;
                                       completionHandler(result);
                                     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                       errorHandler([XMMError new]);
                                     }
   ];
}

- (void)contentListWithPageSize:(int)pageSize withLanguage:(NSString*)language withCursor:(NSString*)cursor withTags:(NSArray*)tags completion:(void(^)(XMMResponseContentList *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  RKObjectMapping* responseMapping = [XMMResponseContentList mapping];
  RKObjectMapping* responseItemMapping = [XMMResponseContent mapping];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  NSString* tagsAsString;
  if (tags != nil)
    tagsAsString = [tags componentsJoinedByString:@","];
  else
    tagsAsString = @"null";
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/content_list/%@/%i/%@/%@", language, pageSize, cursor, tagsAsString];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"Output: %@", mappingResult.firstObject);
                                       XMMResponseContentList *result = mappingResult.firstObject;
                                       completionHandler(result);
                                     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                       errorHandler([XMMError new]);
                                     }
   ];
}

- (void)closestSpotsWithLat:(float)lat withLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language completion:(void(^)(XMMResponseClosestSpot *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  NSDictionary *queryParams = @{@"location":
                                  @{@"lat":[NSString stringWithFormat:@"%f", lat],
                                    @"lon":[NSString stringWithFormat:@"%f", lon],
                                    },
                                @"radius":[NSString stringWithFormat:@"%d", radius],
                                @"limit":[NSString stringWithFormat:@"%d", limit],
                                @"language":language,
                                };
  
  // Create mappings
  RKObjectMapping* responseMapping = [XMMResponseClosestSpot mapping];
  RKObjectMapping* responseItemMapping = [XMMResponseGetSpotMapItem mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  NSString *path = @"xamoomEndUserApi/v1/get_closest_spots";
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        XMMResponseClosestSpot *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Hellno: %@", error);
                                        errorHandler([XMMError new]);
                                      }
   ];
}

- (void)geofenceAnalyticsMessageWithRequestedLanguage:(NSString*)requestedLanguage withDeliveredLanguage:(NSString*)deliveredLanguage withSystemId:(NSString*)systemId withSystemName:(NSString*)sytemName withContentId:(NSString*)contentId withContentName:(NSString*)contentName withSpotId:(NSString*)spotId withSpotName:(NSString*)spotName {
  
  NSDictionary *queryParams = @{@"requested_language":requestedLanguage,
                                @"delivered_language":deliveredLanguage,
                                @"system_id":systemId,
                                @"system_name":sytemName,
                                @"content_id":contentId,
                                @"content_name":contentName,
                                @"spot_id":spotId,
                                @"spot_name":spotName,
                                };
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/queue_geofence_analytics/"];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"queue_geofence_analytics successfull");
                                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSLog(@"queue_geofence_analytics Error: %@", error);
                                     }
   ];
}

#pragma mark - QRCodeReaderViewController

- (void)startQRCodeReaderFromViewController:(UIViewController*)viewController didLoad:(void(^)(NSString *locationIdentifier, NSString *url))completionHandler {
  static QRCodeReaderViewController *reader = nil;
  static dispatch_once_t onceToken;
  
  self.qrCodeParentViewController = viewController;
  
  dispatch_once(&onceToken, ^{
    reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:self.qrCodeViewControllerCancelButtonTitle];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
  });

  reader.delegate = self;
  
  //completionblock
  [reader setCompletionWithBlock:^(NSString *resultAsString) {
    if (!self.isQRCodeScanFinished && resultAsString != nil) {
      self.isQRCodeScanFinished = YES;
      [self.qrCodeParentViewController dismissViewControllerAnimated:YES completion:nil];
      completionHandler([self getLocationIdentifierFromURL:resultAsString], resultAsString);
    }
  }];
  
  self.isQRCodeScanFinished = NO;
  [viewController presentViewController:reader animated:YES completion:NULL];
}

-(void)readerDidCancel:(QRCodeReaderViewController *)reader {
  [self.qrCodeParentViewController dismissViewControllerAnimated:YES completion:nil];
  self.isQRCodeScanFinished = YES;
  self.qrCodeParentViewController = nil;
}

- (NSString*)getLocationIdentifierFromURL:(NSString*)URL {
  NSURL* realUrl = [NSURL URLWithString:[self checkUrlPrefix:URL]];
  NSString *path = [realUrl path];
  path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
  return path;
}

- (NSString*)checkUrlPrefix:(NSString*)URL {
  if ([[URL lowercaseString] hasPrefix:@"http://"]) {
    return URL;
  }
  else if ([[URL lowercaseString] hasPrefix:@"https://"]) {
    return URL;
  }
  else {
    return [NSString stringWithFormat:@"http://%@", URL];
  }
}

@end
