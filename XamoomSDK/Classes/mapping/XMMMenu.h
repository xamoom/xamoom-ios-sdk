//
//  XMMMenu.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"
#import "XMMMenuItem.h"

@interface XMMMenu : JSONAPIResourceBase  <XMMRestResource>

@property (strong, nonatomic) NSArray *items;

@end
