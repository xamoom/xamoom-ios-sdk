//
//  XMMSystem.h
//  XamoomSDK
//
//  Created by Raphael Seher on 16/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"
#import "XMMSystemSettings.h"
#import "XMMStyle.h"
#import "XMMMenu.h"

@interface XMMSystem : JSONAPIResourceBase  <XMMRestResource>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (nonatomic, getter=isDemo) BOOL demo;
@property (strong, nonatomic) XMMSystemSettings *settings;
@property (strong, nonatomic) XMMStyle *style;
@property (strong, nonatomic) XMMMenu *menu;

@end
