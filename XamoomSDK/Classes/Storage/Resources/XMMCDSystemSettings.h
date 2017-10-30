//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMSystemSettings.h"
#import "XMMOfflineStorageManager.h"

@interface XMMCDSystemSettings : NSManagedObject <XMMCDResource>

@property (strong, nonatomic) NSString *itunesAppId;
@property (strong, nonatomic) NSString *googlePlayId;
@property (strong, nonatomic) NSNumber *socialSharingEnabled;

@end
