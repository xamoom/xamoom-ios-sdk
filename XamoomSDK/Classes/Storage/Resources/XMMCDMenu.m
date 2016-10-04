//
//  XMMCDMenu.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDMenu.h"

@implementation XMMCDMenu

@dynamic jsonID;
@dynamic items;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  XMMMenu *menu = (XMMMenu *)entity;
  XMMCDMenu *savedMenu = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:menu.ID];
  if (objects.count > 0) {
    savedMenu = objects.firstObject;
  } else {
    savedMenu = [NSEntityDescription insertNewObjectForEntityForName:[XMMCDMenu coreDataEntityName]
                                               inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedMenu.jsonID = menu.ID;
  
  NSMutableOrderedSet *items = [[NSMutableOrderedSet alloc] init];
  for (XMMMenuItem *item in menu.items) {
    [items addObject:[XMMCDMenuItem insertNewObjectFrom:item]];
  }
  savedMenu.items = items;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedMenu;
}

@end
