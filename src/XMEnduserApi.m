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

#import "XMEnduserApi.h"
#import <RestKit/RestKit.h>

static NSString * const BaseURLString = @"https://xamoom-api-dot-xamoom-cloud-dev.appspot.com/_ah/api/";


@implementation XMEnduserApi : NSObject

NSURL *baseURL;

-(id)init
{
    self = [super init];
    baseURL = [NSURL URLWithString:BaseURLString];
    return self;
}

- (void) getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language
{
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":Menu,
                                  @"language":language
                                  };
    
    //mappings
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    
    RKObjectMapping* responseMapping = [XMResponseGetById getMapping];
    RKObjectMapping* responseContentMapping = [XMResponseContent getMapping];
    RKObjectMapping* responseStyleMapping = [XMResponseStyle getMapping];
    RKObjectMapping* responseMenuMapping = [XMResponseMenuItem getMapping];
    
    //dynamic matcher
    [dynamicMapping addMatcher:[XMResponseContentBlockType0 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType1 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType2 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType3 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType4 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType5 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType6 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType7 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType8 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType9 getDynamicMappingMatcher]];
    
    
    //relationships
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

- (void) getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)menu language:(NSString*)language
{
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    //mappings
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    
    RKObjectMapping* responseMapping = [XMResponseGetByLocationIdentifier getMapping];
    RKObjectMapping* responseContentMapping = [XMResponseContent getMapping];
    RKObjectMapping* responseStyleMapping = [XMResponseStyle getMapping];
    RKObjectMapping* responseMenuMapping = [XMResponseMenuItem getMapping];
    
    //dynamic matcher
    [dynamicMapping addMatcher:[XMResponseContentBlockType0 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType1 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType2 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType3 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType4 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType5 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType6 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType7 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType8 getDynamicMappingMatcher]];
    [dynamicMapping addMatcher:[XMResponseContentBlockType9 getDynamicMappingMatcher]];
    
    //relationships
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

- (void) getContentByLocation:(NSString*)lat lon:(NSString*)lon language:(NSString*)language
{
    NSDictionary *queryParams = @{@"location":
                                    @{@"lat":lat,
                                      @"lon":lon,
                                      },
                                  @"language":language,
                                  };
    
    //mappings
    RKObjectMapping* responseMapping = [XMResponseGetByLocation getMapping];
    RKObjectMapping* responseItemMapping = [XMResponseGetByLocationItem getMapping];
    
    //relationships
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                    toKeyPath:@"items"
                                                                                  withMapping:responseItemMapping]];
    
    [self talkToApi:responseMapping
     withParameters:queryParams
           withpath:@"xamoomEndUserApi/v1/get_content_by_location"];
    
}

- (void) talkToApi:(RKObjectMapping*)objectMapping withParameters:(NSDictionary*)parameters withpath:(NSString*)path
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [manager addResponseDescriptor:contentDescriptor];
    
    [manager postObject:nil path:path parameters:parameters
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"Output: %@", mappingResult.firstObject);
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }
     ];
}

@end
