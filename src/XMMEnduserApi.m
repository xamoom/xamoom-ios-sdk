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

NSString * const kXamoomAPIToken = @"f01f9db7-c54d-4117-9161-6f0023b7057e";
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
  
  //set JSON-Type and Authorization Header
  [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:kXamoomAPIToken];
  
  //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    
  return self;
}

#pragma mark public methods
#pragma mark API calls

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language {
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
  
  [self talkToApi:responseMapping
   withParameters:queryParams
         withpath:@"xamoomEndUserApi/v1/get_content_by_content_id"];
}

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full {
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
  
  [self talkToApi:responseMapping
   withParameters:queryParams
         withpath:@"xamoomEndUserApi/v1/get_content_by_content_id_full"];
}

- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language {
  
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
  
  
  [self talkToApi:responseMapping
   withParameters:queryParams
         withpath:@"xamoomEndUserApi/v1/get_content_by_location_identifier"];
}

- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language {
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
  
  [self talkToApi:responseMapping
   withParameters:queryParams
         withpath:@"xamoomEndUserApi/v1/get_content_by_location"];
  
}

- (void)spotMapWithSystemId:(NSString *)systemId withMapTags:(NSArray *)mapTags withLanguage:(NSString *)language {
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
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/spotmap/%@/%@/%@", systemId, [mapTags componentsJoinedByString:@","], language];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"Output: %@", mappingResult.firstObject);
                                       XMMResponseGetSpotMap *result = [XMMResponseGetSpotMap new];
                                       result = mappingResult.firstObject;
                                       if ( [self.delegate respondsToSelector:@selector(didLoadSpotMap:)] ) {
                                         [self.delegate performSelector:@selector(didLoadSpotMap:) withObject:result];
                                       }
                                     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                     }
   ];
}

- (void)contentListWithSystemId:(NSString*)systemId withLanguage:(NSString*)language withPageSize:(int)pageSize withCursor:(NSString*)cursor withTags:(NSArray*)tags {
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
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/content_list/%@/%@/%i/%@/%@", systemId, language, pageSize, cursor, tagsAsString];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"Output: %@", mappingResult.firstObject);
                                       XMMResponseContentList *result = [XMMResponseContentList new];
                                       result = mappingResult.firstObject;
                                       
                                       if ( [self.delegate respondsToSelector:@selector(didLoadContentList:)] ) {
                                         [self.delegate performSelector:@selector(didLoadContentList:) withObject:result];
                                       }
                                     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error: %@", error);
                                     }
   ];
}

- (void)closestSpotsWithLat:(float)lat withLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language {
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
  
  [self talkToApi:responseMapping
   withParameters:queryParams
         withpath:@"xamoomEndUserApi/v1/get_closest_spots"];
}

- (void)talkToApi:(RKObjectMapping*)objectMapping withParameters:(NSDictionary*)parameters withpath:(NSString*)path {
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:parameters
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        
                                        // Perform specific finishLoadData delegates
                                        if (([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id"] || [path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id_full"])) {
                                          XMMResponseGetById *result = [XMMResponseGetById new];
                                          result = mappingResult.firstObject;
                                          
                                          if ([self.delegate respondsToSelector:@selector(didLoadDataWithContentId:)]) {
                                            [self.delegate performSelector:@selector(didLoadDataWithContentId:) withObject:result];
                                          }
                                          else {
                                            NSString *notificationName = [NSString stringWithFormat:@"%@%@", @"getByIdFull", result.content.contentId];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:result ];
                                          }
                                        }
                                        else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location_identifier"] &&  [self.delegate respondsToSelector:@selector(didLoadDataWithLocationIdentifier:)] ) {
                                          XMMResponseGetByLocationIdentifier *result = [XMMResponseGetByLocationIdentifier new];
                                          result = mappingResult.firstObject;
                                          [self.delegate performSelector:@selector(didLoadDataWithLocationIdentifier:) withObject:result];
                                        }
                                        else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location"] && [self.delegate respondsToSelector:@selector(didLoadDataWithLocation:)] ) {
                                          XMMResponseGetByLocation *result;
                                          result = mappingResult.firstObject;
                                          [self.delegate performSelector:@selector(didLoadDataWithLocation:) withObject:result];
                                        } else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_closest_spots"] && [self.delegate respondsToSelector:@selector(didLoadClosestSpots:)] ) {
                                          XMMResponseClosestSpot *result;
                                          result = mappingResult.firstObject;
                                          [self.delegate performSelector:@selector(didLoadClosestSpots:) withObject:result];
                                        }
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error: %@", error);
                                      }
   ];
}

# pragma mark - Core Data

- (void)initCoreData {
  
  // Initialize managed object model from bundle
  NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  // Initialize managed object store
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
  [RKObjectManager sharedManager].managedObjectStore = managedObjectStore;
  
  // Complete Core Data stack initialization
  [managedObjectStore createPersistentStoreCoordinator];
  NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"XMMCoreData.sqlite"];
  NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
  NSError *error;
  NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
  NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
  
  // Create the managed object contexts
  [managedObjectStore createManagedObjectContexts];
  
  // Configure a managed object cache to ensure we do not create duplicate objects
  managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
  
  // Enable Activity Indicator Spinner
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  [self getByIdMapping];
  isCoreDataInitialized = YES;
}

- (void)getByIdMapping {
  // Create mapping
  RKEntityMapping *coreDataMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetById" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetById mapping]];
  
  [coreDataMapping setIdentificationAttributes:@[ @"contentId" ]];
  
  RKEntityMapping *coreDataStyleMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataStyle" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataStyleMapping addAttributeMappingsFromDictionary:[XMMCoreDataStyle mapping]];
  
  RKEntityMapping *coreDataMenuMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataMenuItem" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataMenuMapping addAttributeMappingsFromDictionary:[XMMCoreDataMenuItem mapping]];
  
  RKEntityMapping *coreDataContentMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataContent" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataContentMapping addAttributeMappingsFromDictionary:[XMMCoreDataContent mapping]];
  
  RKEntityMapping *coreDataContentBlocksMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataContentBlocks" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataContentBlocksMapping addAttributeMappingsFromDictionary:[XMMCoreDataContentBlocks mapping]];
  
  // Create relationship
  [coreDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                  toKeyPath:@"content"
                                                                                withMapping:coreDataContentMapping]];
  
  [coreDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                  toKeyPath:@"content.contentBlocks"
                                                                                withMapping:coreDataContentBlocksMapping]];
  
  [coreDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:coreDataStyleMapping]];
  
  [coreDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu.items"
                                                                                  toKeyPath:@"menu"
                                                                                withMapping:coreDataMenuMapping]];
  
  RKResponseDescriptor *coreDataGetByIdResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coreDataMapping
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:nil
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                                             ];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:coreDataGetByIdResponseDescriptor];
}

- (void)saveContentToCoreDataWithContentId:(NSString *)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString *)language {
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id";
  NSDictionary *queryParams = @{@"content_id":contentId,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                };
  
  [self talkToApiCoreDataWithParameters:queryParams
                               withpath:path];
}

- (void)saveContentToCoreDataWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(BOOL)style includeMenu:(BOOL) menu withLanguage:(NSString *)language {
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location_identifier";
  NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language
                                };
  
  [self talkToApiCoreDataWithParameters:queryParams
                               withpath:path];
}

- (void)saveContentToCoreDataWithLat:(NSString *)lat withLon:(NSString *)lon withLanguage:(NSString *)language {
  // Create mapping
  RKEntityMapping *coreDataMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetByLocation" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetByLocation mapping]];
  
  RKEntityMapping *coreDataItemMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetByLocationItem" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
  [coreDataItemMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetByLocationItem mapping]];
  
  // Create relationships
  [coreDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:coreDataItemMapping]];
  
  RKResponseDescriptor *coreDataGetByIdResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:coreDataMapping
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:nil
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                                             ];
  
  [[RKObjectManager sharedManager] addResponseDescriptor:coreDataGetByIdResponseDescriptor];
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location";
  NSDictionary *queryParams = @{@"location":
                                  @{@"lat":lat,
                                    @"lon":lon,
                                    },
                                @"language":language,
                                };
  
  [self talkToApiCoreDataWithParameters:queryParams
                               withpath:path];
}

- (void)talkToApiCoreDataWithParameters:(NSDictionary*)parameters withpath:(NSString*)path {
  if(self.isCoreDataInitialized) {
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager] postObject:nil path:path parameters:parameters
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                          NSLog(@"Output: %@", mappingResult.firstObject);
                                          
                                          // Perform specific savedContentToCoreData delegates
                                          if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id"] && [self.delegate respondsToSelector:@selector(savedContentToCoreDataWithContentId)] ) {
                                            [self.delegate performSelector:@selector(savedContentToCoreDataWithContentId)];
                                          }
                                          else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location_identifier"] &&  [self.delegate respondsToSelector:@selector(savedContentToCoreDataWithLocationIdentifier)] ) {
                                            [self.delegate performSelector:@selector(savedContentToCoreDataWithLocationIdentifier)];
                                          }
                                          else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location"] && [self.delegate respondsToSelector:@selector(savedContentToCoreDataWithLocation)] ) {
                                            [self.delegate performSelector:@selector(savedContentToCoreDataWithLocation)];
                                          }
                                          
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error: %@", error);
                                        }
     ];
  }
  else {
    NSLog(@"CoreData is not initialized.");
  }
}

- (NSArray*)fetchCoreDataContentWithType:(NSString *)type {
  NSFetchRequest *fetchRequest;
  
  if ([type.lowercaseString isEqualToString:@"id"]){
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetById"];
  }
  else if ([type.lowercaseString isEqualToString:@"location"]){
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetByLocation"];
  }
  else {
    NSLog(@"Type not found.");
  }
  
  return [self executeFetch:fetchRequest];
}

- (NSArray *)executeFetch:(NSFetchRequest *)fetchRequest {
  if(self.isCoreDataInitialized) {
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
  }
  else {
    NSLog(@"CoreData is not initialized.");
  }
  return nil;
}

- (BOOL)deleteCoreDataEntityWithContentId:(NSString *)contentId {
  if(self.isCoreDataInitialized) {
    NSFetchRequest *fetchRequest;
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetById"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contentId == %@", contentId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *results = [self executeFetch:fetchRequest];
    
    if ([results count] == 1) {
      [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext deleteObject:[results firstObject]];
      [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext saveToPersistentStore:nil];
      NSLog(@"Entitiy with contentId %@ deleted", contentId);
      return YES;
    }
    else if ([results count] > 1) {
      NSLog(@"Error deleting object. There are objects with the same contentId");
    }
    else {
      NSLog(@"Error deleting object. There is no object with the contentId %@", contentId);
    }
  }
  else {
    NSLog(@"CoreData is not initialized.");
  }
  
  return NO;
}

#pragma mark - RSS

- (void)rssContentFeed {
  NSLog(@"Starting with RSS");
  
  self.backgroundQueue = dispatch_queue_create("com.xamoom.xamoom-ios-sdk", NULL);
  
  self.rssEntries = [NSMutableArray new];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rssBaseUrlString]];
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                           NSLog(@"Data: %@", data);
                           [parser setDelegate:self];
                           dispatch_async(self.backgroundQueue, ^(void) {
                             [parser parse];
                           });
                         }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
  
  self.element = [NSMutableString string];
  if ([elementName isEqualToString:@"item"]) {
    self.rssItem = [XMMRSSEntry new];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if(self.element == nil) {
    self.element = [[NSMutableString alloc] init];
  }
  [self.element appendString:string];
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  if (self.rssItem != nil) {
    if ([elementName isEqualToString:@"title"]) {
      self.rssItem.title = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"link"]) {
      self.rssItem.link = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"comments"]) {
      self.rssItem.comments = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"pubDate"]) {
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
      [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
      [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]]; //This is the Stuff
      NSDate *date = [dateFormat dateFromString:self.element];
      self.rssItem.pubDate = date;
    }
    
    if([elementName isEqualToString:@"category"]) {
      self.rssItem.category = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"guid"]) {
      self.rssItem.guid = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"description"]) {
      self.rssItem.descriptionOfContent = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"content:encoded"]) {
      self.rssItem.content = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"wfw:commentRss"]) {
      self.rssItem.wfw = [self.element stringByDecodingHTMLEntities];
    }
    
    if([elementName isEqualToString:@"slash:comments"]) {
      self.rssItem.slash = [self.element stringByDecodingHTMLEntities];
    }
    
    if ([elementName isEqualToString:@"item"]) {
      [self.rssEntries addObject:self.rssItem];
      self.rssItem = nil;
    }
  }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  if([self.delegate respondsToSelector:@selector(didLoadRSS:)]) {
    dispatch_async(dispatch_get_main_queue(), ^(){
      [self.delegate performSelector:@selector(didLoadRSS:) withObject:self.rssEntries];
    });
  }
}

#pragma mark - QRCodeReaderViewController

- (void)startQRCodeReaderFromViewController:(UIViewController*)viewController withLanguage:(NSString *)language{
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
      if ([self.delegate respondsToSelector:@selector(didScanQR:)] ) {
        [self.delegate performSelector:@selector(didScanQR:) withObject:[self getLocationIdentifierFromURL:resultAsString]];
      }
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
