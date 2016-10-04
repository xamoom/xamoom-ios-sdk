//
//  XMMCDSystemSettings.m
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDSystemSettings.h"

@implementation XMMCDSystemSettings

@dynamic jsonID;
@dynamic googlePlayId;
@dynamic itunesAppId;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  XMMSystemSettings *settings = (XMMSystemSettings *)entity;
  XMMCDSystemSettings *savedSettings = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName] jsonID:settings.ID];
  if (objects.count > 0) {
    savedSettings = objects.firstObject;
  } else {
    savedSettings = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDSystemSettings coreDataEntityName]
                                                  inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSettings.jsonID = settings.ID;
  savedSettings.googlePlayId = settings.googlePlayAppId;
  savedSettings.itunesAppId = settings.itunesAppId;
  
  return savedSettings;
}

@end
