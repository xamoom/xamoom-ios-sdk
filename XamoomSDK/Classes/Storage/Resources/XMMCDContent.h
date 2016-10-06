//
//  XMMCDContent.h
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMOfflineStorageManager.h"
#import "XMMCDContentBlock.h"
#import "XMMCDSystem.h"
#import "XMMContent.h"

@class XMMCDSpot;

@interface XMMCDContent : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *contentDescription;
@property (nonatomic, copy) NSString *language;
@property (nonatomic) NSArray *contentBlocks;
@property (nonatomic) NSNumber *category;
@property (nonatomic) NSArray *tags;
@property (nonatomic) XMMCDSystem *system;
@property (nonatomic) XMMCDSpot *spot;

@end
