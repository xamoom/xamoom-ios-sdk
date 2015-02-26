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

#import "XMMEnduserApi.h"
#import <RestKit/RestKit.h>

static NSString * const apiBaseURLString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_ah/api/";
static NSString * const rssBaseURLString = @"http://xamoom.com/feed/";

@implementation XMMEnduserApi : NSObject

XMMRSSEntry *rssItem;
NSMutableString *element;

@synthesize delegate, apiBaseURL, rssEntries;

-(id)init {
    self = [super init];
    self.apiBaseURL = [NSURL URLWithString:apiBaseURLString];
    self.rssBaseUrl = rssBaseURLString;
    return self;
}

#pragma mark - gets from API

- (void)getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)menu language:(NSString*)language {
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    // Create mappings
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    
    RKObjectMapping* responseMapping = [XMMResponseGetById getMapping];
    RKObjectMapping* responseContentMapping = [XMMResponseContent getMapping];
    RKObjectMapping* responseStyleMapping = [XMMResponseStyle getMapping];
    RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem getMapping];
    
    // Add dynamic matchers
    [dynamicMapping addMatcher:[XMMResponseContentBlockType0 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType1 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType2 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType3 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType4 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType5 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType6 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType7 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType8 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType9 getDynamicMappingMatcher]];
    
    
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

- (void)getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)menu language:(NSString*)language
{
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    // Create mappings
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    
    RKObjectMapping* responseMapping = [XMMResponseGetByLocationIdentifier getMapping];
    RKObjectMapping* responseContentMapping = [XMMResponseContent getMapping];
    RKObjectMapping* responseStyleMapping = [XMMResponseStyle getMapping];
    RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem getMapping];
    
    // Add dynamic matchers
    [dynamicMapping addMatcher:[XMMResponseContentBlockType0 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType1 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType2 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType3 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType4 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType5 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType6 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType7 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType8 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMMResponseContentBlockType9 getDynamicMappingMatcher]];
    
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

- (void)getContentByLocation:(NSString*)lat lon:(NSString*)lon language:(NSString*)language
{
    NSDictionary *queryParams = @{@"location":
                                      @{@"lat":lat,
                                        @"lon":lon,
                                        },
                                  @"language":language,
                                  };
    
    // Create mappings
    RKObjectMapping* responseMapping = [XMMResponseGetByLocation getMapping];
    RKObjectMapping* responseItemMapping = [XMMResponseGetByLocationItem getMapping];
    
    // Create relationship
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                    toKeyPath:@"items"
                                                                                  withMapping:responseItemMapping]];
    
    [self talkToApi:responseMapping
     withParameters:queryParams
           withpath:@"xamoomEndUserApi/v1/get_content_by_location"];
    
}

- (void)talkToApi:(RKObjectMapping*)objectMapping withParameters:(NSDictionary*)parameters withpath:(NSString*)path
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    // Create ResponseDescriptor with objectMapping
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    // Create ObjectManager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:apiBaseURL];
    manager.requestSerializationMIMEType = RKMIMETypeJSON; // JSON
    
    [manager addResponseDescriptor:contentDescriptor];
    [manager postObject:nil path:path parameters:parameters
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"Output: %@", mappingResult.firstObject);
                    
                    // Perform finishedLoadData delegate
                    if ( [delegate respondsToSelector:@selector(finishedLoadData:)] ) {
                        [delegate performSelector:@selector(finishedLoadData:) withObject: mappingResult];
                    }
                    
                    // Perform specific finishLoadData delegates
                    if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_content_id"] && [delegate respondsToSelector:@selector(finishedLoadDataById:)] ) {
                        XMMResponseGetById *result = [XMMResponseGetById new];
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(finishedLoadDataById:) withObject:result];
                    }
                    else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location_identifier"] &&  [delegate respondsToSelector:@selector(finishedLoadDataByLocationIdentifier:)] ) {
                        XMMResponseGetByLocationIdentifier *result = [XMMResponseGetByLocationIdentifier new];
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(finishedLoadDataByLocationIdentifier:) withObject:result];
                    }
                    else if ([path isEqualToString:@"xamoomEndUserApi/v1/get_content_by_location"] && [delegate respondsToSelector:@selector(finishedLoadDataByLocation:)] ) {
                        XMMResponseGetByLocation *result;
                        result = mappingResult.firstObject;
                        [delegate performSelector:@selector(finishedLoadDataByLocation:) withObject:result];
                    }
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }
     ];
}

# pragma mark - Core Data

- (void)initRestkitCoreData
{
    // Initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:apiBaseURL];
    [RKObjectManager setSharedManager:objectManager];
    
    // Initialize managed object model from bundle
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
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
}

- (void)getByIdMapping {
    // Create mapping
    RKEntityMapping *coreDataMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetById" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetById getMapping]];
    
    [coreDataMapping setIdentificationAttributes:@[ @"contentId" ]];
    
    RKEntityMapping *coreDataStyleMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataStyle" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataStyleMapping addAttributeMappingsFromDictionary:[XMMCoreDataStyle getMapping]];
    
    RKEntityMapping *coreDataMenuMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataMenuItem" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataMenuMapping addAttributeMappingsFromDictionary:[XMMCoreDataMenuItem getMapping]];
    
    RKEntityMapping *coreDataContentMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataContent" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataContentMapping addAttributeMappingsFromDictionary:[XMMCoreDataContent getMapping]];
    
    RKEntityMapping *coreDataContentBlocksMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataContentBlocks" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataContentBlocksMapping addAttributeMappingsFromDictionary:[XMMCoreDataContentBlocks getMapping]];
    
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

- (void)getContentByIdFromCoreData:(NSString *)contentId includeStyle:(NSString *)style includeMenu:(NSString *)menu language:(NSString *)language
{
    NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id";
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language,
                                  };
    
    [self talkToApiCoreDataWithParameters:queryParams
                                 withpath:path];
}

- (void)getContentByLocationIdentifierFromCoreData:(NSString *)locationIdentifier includeStyle:(NSString *)style includeMenu:(NSString *)menu language:(NSString *)language
{
    NSString *path = @"xamoomEndUserApi/v1/get_content_by_location_identifier";
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    [self talkToApiCoreDataWithParameters:queryParams
                                 withpath:path];
}

- (void)getContentByLocationFromCoreData:(NSString *)lat lon:(NSString *)lon language:(NSString *)language
{
    // Create mapping
    RKEntityMapping *coreDataMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetByLocation" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetByLocation getMapping]];
    
    RKEntityMapping *coreDataItemMapping = [RKEntityMapping mappingForEntityForName:@"XMMCoreDataGetByLocationItem" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [coreDataItemMapping addAttributeMappingsFromDictionary:[XMMCoreDataGetByLocationItem getMapping]];
    
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

- (void)talkToApiCoreDataWithParameters:(NSDictionary*)parameters withpath:(NSString*)path
{
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager] postObject:nil path:path parameters:parameters
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Output: %@", mappingResult.firstObject);
                                            [delegate performSelector:@selector(finishedLoadCoreData)];
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            NSLog(@"Error: %@", error);
                                        }
     ];
}

- (NSArray*)fetchCoreDataContentBy:(NSString *)type {
    NSFetchRequest *fetchRequest;
    
    if ([type.lowercaseString isEqualToString:@"id"]){
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetById"];
    }
    else if ([type.lowercaseString isEqualToString:@"locationidentifier"]){
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMMCoreDataGetByLocationIdentifier"];
    }
    else {
        NSLog(@"Type not found.");
    }
    
    return [self executeFetch:fetchRequest];
}

- (NSArray *)executeFetch:(NSFetchRequest *)fetchRequest {
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (BOOL)deleteCoreDataEntityBy:(NSString *)contentId {
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
    
    return NO;
}

#pragma mark - RSS

- (void)getContentFromRSSFeed {
    NSLog(@"Starting with RSS");
    
    rssEntries = [NSMutableArray new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rssBaseUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                               [parser setDelegate:self];
                               [parser parse];
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
    [delegate performSelector:@selector(finishedLoadRSS:) withObject:rssEntries];
}

#pragma mark - QRCodeReaderViewController

- (void)startQRCodeReader:(UIViewController*)viewController withAPIRequest:(BOOL)automaticAPIRequest {
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    
    reader.delegate = viewController;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        if (automaticAPIRequest) {
            [self getContentByLocationIdentifier:[self getLocationIdentifierFromURL:resultAsString]
                                    includeStyle:@"True"
                                     includeMenu:@"True"
                                        language:@"de"
             ];
        }
    }];
    
    [viewController presentViewController:reader animated:YES completion:NULL];
}

- (NSString*)getLocationIdentifierFromURL:(NSString*)URL {
    NSURL* realUrl = [NSURL URLWithString:URL];
    NSString *path = [realUrl path];
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSLog(@"Path: %@", path);
    return path;
}

@end
