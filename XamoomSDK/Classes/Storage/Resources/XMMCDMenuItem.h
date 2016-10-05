//
//  XMMCDMenuItem.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"
#import "XMMMenu.h"

@interface XMMCDMenuItem : NSManagedObject <XMMCDResource>

@property (strong, nonatomic) NSString *contentTitle;
@property (assign, nonatomic) NSNumber *category;

@end
