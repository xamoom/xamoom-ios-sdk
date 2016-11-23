//
//  XMMCDMenuItem.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDMenuItem.h"
#import "XMMContent.h"

@implementation XMMCDMenuItem

@dynamic jsonID;
@dynamic contentTitle;
@dynamic category;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  return [self insertNewObjectFrom:entity fileManager:[[XMMOfflineFileManager alloc] init]];
}

+ (instancetype)insertNewObjectFrom:(id)entity fileManager:(XMMOfflineFileManager *)fileManager {
  return [self insertNewObjectFrom:entity fileManager:fileManager completion:nil];
}

+ (instancetype)insertNewObjectFrom:(id)entity
                        fileManager:(XMMOfflineFileManager *)fileManager
                         completion:(void (^)(NSString *url, NSData *, NSError *))completion {
  XMMContent *menuItem = (XMMContent *)entity;
  XMMCDMenuItem *savedMenuItem = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:menuItem.ID];
  if (objects.count > 0) {
    savedMenuItem = objects.firstObject;
  } else {
    savedMenuItem = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                  inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedMenuItem.jsonID = menuItem.ID;
  savedMenuItem.contentTitle = menuItem.title;
  savedMenuItem.category = [NSNumber numberWithInt:menuItem.category];
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedMenuItem;
}

@end
