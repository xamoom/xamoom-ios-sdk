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

static NSString * const XAMOOM_API_TOKEN = @"f01f9db7-c54d-4117-9161-6f0023b7057e";

static NSString * const apiBaseURLString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_ah/api/";
static NSString * const rssBaseURLString = @"http://xamoom.com/feed/";
static XMMEnduserApi *_sharedInstance;

#pragma mark - XMMEnduserApi

@implementation XMMEnduserApi : NSObject

dispatch_queue_t backgroundQueue;

@synthesize delegate;
@synthesize rssEntries;
@synthesize isCoreDataInitialized;
@synthesize apiBaseURL;
@synthesize qrCodeViewControllerCancelButtonTitle;

+ (XMMEnduserApi *)sharedInstance {
    if (!_sharedInstance)
        
    {
        _sharedInstance = [[XMMEnduserApi alloc] init];
    }
    
    return _sharedInstance;
}

-(id)init {
    self = [super init];
    apiBaseURL = [NSURL URLWithString:apiBaseURLString];
    self.rssBaseUrl = rssBaseURLString;
    self.systemLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    isCoreDataInitialized = NO;
    qrCodeViewControllerCancelButtonTitle = @"Cancel";
    
    //create RKObjectManager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:apiBaseURL];
    [RKObjectManager setSharedManager:objectManager];
    
    //set JSON-Type and Authorization Header
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:XAMOOM_API_TOKEN];
    
    return self;
}

#pragma mark public methods
#pragma mark API calls

- (void)getContentFromApiById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)menu withLanguage:(NSString*)language {
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":menu,
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

- (void)getContentFromApiByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)menu withLanguage:(NSString*)language {
    
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
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

- (void)getContentFromApiWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language {
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

- (void)getSpotMapWithSystemId:(NSString *)systemId withMapTag:(NSString *)mapTag withLanguage:(NSString *)language {
    RKObjectMapping* responseMapping = [XMMResponseGetSpotMap mapping];
    RKObjectMapping* responseItemMapping = [XMMResponseGetSpotMapItem mapping];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                    toKeyPath:@"items"
                                                                                  withMapping:responseItemMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    // Create ResponseDescriptor with objectMapping
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/spotmap/%@/%@/%@", systemId, mapTag, language];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
    [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"Output: %@", mappingResult.firstObject);
                   XMMResponseGetSpotMap *result = [XMMResponseGetSpotMap new];
                   result = mappingResult.firstObject;
                   if ( [delegate respondsToSelector:@selector(didLoadDataBySpotMap:)] ) {
                       [delegate performSelector:@selector(didLoadDataBySpotMap:) withObject:result];
                   }
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
               }
     ];
}

- (void)getContentListFromApi:(NSString*)systemId withLanguage:(NSString*)language withPageSize:(int)pageSize withCursor:(NSString*)cursor {
    RKObjectMapping* responseMapping = [XMMResponseContentList mapping];
    RKObjectMapping* responseItemMapping = [XMMResponseContent mapping];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                    toKeyPath:@"items"
                                                                                  withMapping:responseItemMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    // Create ResponseDescriptor with objectMapping
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/content_list/%@/%@/%i/%@", systemId, language, pageSize, cursor];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
    [[RKObjectManager sharedManager] getObject:nil path:path parameters:nil
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           NSLog(@"Output: %@", mappingResult.firstObject);
                                           XMMResponseContentList *result = [XMMResponseContentList new];
                                           result = mappingResult.firstObject;
                                           
                                           if ( [delegate respondsToSelector:@selector(didLoadContentList:)] ) {
                                               [delegate performSelector:@selector(didLoadContentList:) withObject:result];
                                           }
                                       }
                                       failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@", error);
                                       }
     ];
}


- (void)talkToApi:(RKObjectMapping*)objectMapping withParameters:(NSDictionary*)parameters withpath:(NSString*)path {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    // Create ResponseDescriptor with objectMapping
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:contentDescriptor];
    [[RKObjectManager sharedManager] postObject:nil path:path parameters:parameters
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"Output: %@", mappingResult.firstObject);
                    
                    // Perform finishedLoadData delegate
                    if ( [delegate respondsToSelector:@selector(didLoadData:)] ) {
                        [delegate performSelector:@selector(didLoadData:) withObject: mappingResult];
                    }
                    
                    // Perform specific finishLoadData delegates
                    if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id"] && [delegate respondsToSelector:@selector(didLoadDataById:)] ) {
                        XMMResponseGetById *result = [XMMResponseGetById new];
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(didLoadDataById:) withObject:result];
                    }
                    else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location_identifier"] &&  [delegate respondsToSelector:@selector(didLoadDataByLocationIdentifier:)] ) {
                        XMMResponseGetByLocationIdentifier *result = [XMMResponseGetByLocationIdentifier new];
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(didLoadDataByLocationIdentifier:) withObject:result];
                    }
                    else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location"] && [delegate respondsToSelector:@selector(didLoadDataByLocation:)] ) {
                        XMMResponseGetByLocation *result;
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(didLoadDataByLocation:) withObject:result];
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

- (void)getContentForCoreDataById:(NSString *)contentId includeStyle:(NSString *)style includeMenu:(NSString *)menu withLanguage:(NSString *)language {
    NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id";
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language,
                                  };
    
    [self talkToApiCoreDataWithParameters:queryParams
                                 withpath:path];
}

- (void)getContentForCoreDataByLocationIdentifier:(NSString *)locationIdentifier includeStyle:(NSString *)style includeMenu:(NSString *)menu withLanguage:(NSString *)language {
    NSString *path = @"xamoomEndUserApi/v1/get_content_by_location_identifier";
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    [self talkToApiCoreDataWithParameters:queryParams
                                 withpath:path];
}

- (void)getContentForCoreDataByLocationWithLat:(NSString *)lat withLon:(NSString *)lon withLanguage:(NSString *)language {
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
    if(isCoreDataInitialized) {
        [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
        [[RKObjectManager sharedManager] postObject:nil path:path parameters:parameters
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                NSLog(@"Output: %@", mappingResult.firstObject);
                                                
                                                // Perform savedContentToCoreData delegate
                                                if ( [delegate respondsToSelector:@selector(savedContentToCoreData)] ) {
                                                    [delegate performSelector:@selector(savedContentToCoreData)];
                                                }
                                                
                                                // Perform specific savedContentToCoreData delegates
                                                if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id"] && [delegate respondsToSelector:@selector(savedContentToCoreDataById)] ) {
                                                    [delegate performSelector:@selector(savedContentToCoreDataById)];
                                                }
                                                else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location_identifier"] &&  [delegate respondsToSelector:@selector(savedContentToCoreDataByLocationIdentifier)] ) {
                                                    [delegate performSelector:@selector(savedContentToCoreDataByLocationIdentifier)];
                                                }
                                                else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location"] && [delegate respondsToSelector:@selector(savedContentToCoreDataByLocation)] ) {
                                                    [delegate performSelector:@selector(savedContentToCoreDataByLocation)];
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

- (NSArray*)fetchCoreDataContentByType:(NSString *)type {
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
    if(isCoreDataInitialized) {
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

- (BOOL)deleteCoreDataEntityById:(NSString *)contentId {
    if(isCoreDataInitialized) {
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

- (void)getContentFromRSSFeed {
    NSLog(@"Starting with RSS");
    
    backgroundQueue = dispatch_queue_create("com.razeware.imagegrabber.bgqueue", NULL);

    rssEntries = [NSMutableArray new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rssBaseUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                               [parser setDelegate:self];
                               dispatch_async(backgroundQueue, ^(void) {
                                   [parser parse];
                               });
                           }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    element = [NSMutableString string];
    if ([elementName isEqualToString:@"item"]) {
        rssItem = [XMMRSSEntry new];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(element == nil) {
        element = [[NSMutableString alloc] init];
    }
    [element appendString:string];
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (rssItem != nil) {
        if ([elementName isEqualToString:@"title"]) {
            rssItem.title = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"link"]) {
            rssItem.link = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"comments"]) {
            rssItem.comments = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]]; //This is the Stuff
            NSDate *date = [dateFormat dateFromString:element];
            rssItem.pubDate = date;
        }
        
        if([elementName isEqualToString:@"category"]) {
            rssItem.category = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"guid"]) {
            rssItem.guid = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"description"]) {
            rssItem.descriptionOfContent = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"content:encoded"]) {
            rssItem.content = [element stringByDecodingHTMLEntities];
            rssItem.titleImageUrl = [self extractTitleImage:rssItem.content];
            rssItem.content = [self removeTitleImageFromHtml:rssItem.content];
        }
        
        if([elementName isEqualToString:@"wfw:commentRss"]) {
            rssItem.wfw = [element stringByDecodingHTMLEntities];
        }
        
        if([elementName isEqualToString:@"slash:comments"]) {
            rssItem.slash = [element stringByDecodingHTMLEntities];
        }
        
        if ([elementName isEqualToString:@"item"]) {
            [rssEntries addObject:rssItem];
            rssItem = nil;
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if([delegate respondsToSelector:@selector(didLoadRSS:)]) {
        dispatch_async(backgroundQueue, ^(void) {
            [delegate performSelector:@selector(didLoadRSS:) withObject:rssEntries];
        });
    }
}

- (NSString*)extractTitleImage:(NSString*)html {
    NSString *url = nil;
    NSString *htmlString = html;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    // find start of IMG tag
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return url;
}

- (NSString*)removeTitleImageFromHtml:(NSString*)html {
    NSRange r;
    NSString *s = rssItem.content;
    r = [s rangeOfString:@"<img[^>]+>" options:NSRegularExpressionSearch];
    s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

#pragma mark - QRCodeReaderViewController

- (void)startQRCodeReader:(UIViewController*)viewController withAPIRequest:(BOOL)automaticAPIRequest withLanguage:(NSString *)language{
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:qrCodeViewControllerCancelButtonTitle];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    
    reader.delegate = viewController;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        if (automaticAPIRequest && [self getLocationIdentifierFromURL:resultAsString] != nil && resultAsString != nil) {
            [self getContentFromApiByLocationIdentifier:[self getLocationIdentifierFromURL:resultAsString]
                                           includeStyle:@"True"
                                            includeMenu:@"True"
                                           withLanguage:language
             ];
        }
    }];
    
    [viewController presentViewController:reader animated:YES completion:NULL];
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
