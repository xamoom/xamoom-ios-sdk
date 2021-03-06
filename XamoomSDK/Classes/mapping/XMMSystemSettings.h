//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"

/**
 * Settings set in the xamoom cloud.
 */
@interface XMMSystemSettings : JSONAPIResourceBase  <XMMRestResource>

@property (strong, nonatomic) NSString *googlePlayAppId;
@property (strong, nonatomic) NSString *itunesAppId;
@property (nonatomic, getter=isSocialSharingEnabled) BOOL socialSharingEnabled;
@property (nonatomic, getter=isCookieWarningEnabled) BOOL cookieWarningEnabled;
@property (nonatomic, getter=isRecommendationEnabled) BOOL recommendationEnabled;
@property (nonatomic, getter=isEventPackageEnabled) BOOL eventPackageEnabled;
@property (nonatomic, getter=isLanguagePickerEnabled) BOOL languagePickerEnabled;
@property (nonatomic, getter=languages) NSMutableArray<NSString *> *languages;
@property (nonatomic, getter=isFormActive) BOOL isFormActive;
@property (nonatomic, getter=formsBaseUrl) NSString *formsBaseUrl;

@end
