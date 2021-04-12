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
@property (nonatomic, nonatomic) NSNumber *cookieWarningEnabled;
@property (nonatomic, nonatomic) NSNumber *recommendationEnabled;
@property (nonatomic, nonatomic) NSNumber *eventPackageEnabled;
@property (nonatomic, nonatomic) NSNumber *languagePickerEnabled;
@property (nonatomic, nonatomic) NSMutableArray<NSString *> *languages;
@property (nonatomic, nonatomic) NSNumber *isFormActive;
@property (nonatomic, nonatomic) NSString *formsBaseUrl;

@end
