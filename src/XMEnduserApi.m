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

- (void) container
{
    
}

- (void) getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language
{
    NSDictionary *queryParams = @{@"content_id":contentId,
                                  @"include_style":style,
                                  @"include_menu":Menu,
                                  @"language":language
                                  };
    
    RKObjectMapping* responseContentMapping = [RKObjectMapping mappingForClass:[XMResponseContent class] ];
    [responseContentMapping addAttributeMappingsFromDictionary:@{@"description":@"descriptionOfContent",
                                                                 @"language":@"language",
                                                                 @"title":@"title",
                                                                 @"image_public_url":@"imagePublicUrl",
                                                                 }];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[XMResponseGetById class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                          @"system_url":@"systemUrl",
                                                          }];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                    toKeyPath:@"content"
                                                                                  withMapping:responseContentMapping]];
    
    //DYNAMIC MAPPING
    RKObjectMapping* responseContentBlockType0Mapping = [RKObjectMapping mappingForClass:[XMResponseContentBlockType0 class] ];
    [responseContentBlockType0Mapping addAttributeMappingsFromDictionary:@{@"text":@"text",
                                                                           @"public":@"publicStatus",
                                                                           @"content_block_type":@"contentBlockType",
                                                                           @"title":@"title",
                                                                           }];
    
    
    
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
        
    // Configure the dynamic mapping via matchers
    [dynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"content_block_type" expectedValue:@"0" objectMapping:responseContentBlockType0Mapping]];
    
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                    toKeyPath:@"content.content_blocks"
                                                                                  withMapping:dynamicMapping]];
    
    [self talkToApi:responseMapping
     withParameters:queryParams
           withpath:@"xamoomEndUserApi/v1/get_content_by_content_id"];
}

- (void) getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)menu language:(NSString*)language
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[XMResponseGetByLocationIdentifier class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                          @"system_url":@"systemUrl",
                                                          @"has_content":@"hasContent",
                                                          @"has_spot":@"hasSpot"
                                                          }];
    
    NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                  @"include_style":style,
                                  @"include_menu":menu,
                                  @"language":language
                                  };
    
    [self talkToApi:responseMapping
     withParameters:queryParams
           withpath:@"xamoomEndUserApi/v1/get_content_by_location_identifier"];
}

- (NSString*) getContentByLocation:(NSString*)request
{
    return request;
}

- (void) talkToApi:(RKObjectMapping*) objectMapping withParameters:(NSDictionary*) parameters withpath:(NSString*) path
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [manager addResponseDescriptor:contentDescriptor];
    
    [manager postObject:nil path:path parameters:parameters
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    XMResponseGetById *resp = [XMResponseGetById new];
                    resp = mappingResult.firstObject;
                    NSLog(@"Output: %@", resp);

                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }
     ];
}

@end
