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
  return [self insertNewObjectFrom:entity fileManager:[[XMMOfflineFileManager alloc] init]];
}

+ (instancetype)insertNewObjectFrom:(id)entity fileManager:(XMMOfflineFileManager *)fileManager {
  XMMMenu *menu = (XMMMenu *)entity;
  XMMCDMenu *savedMenu = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:menu.ID];
  if (objects.count > 0) {
    savedMenu = objects.firstObject;
  } else {
    savedMenu = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                              inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedMenu.jsonID = menu.ID;
  
  if (menu.items != nil) {
    [savedMenu addMenuItems:menu.items];
  }
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedMenu;
}

- (void)addMenuItems:(NSArray *)menuItems {
  NSMutableOrderedSet *items = [[NSMutableOrderedSet alloc] init];
  for (XMMMenuItem *item in menuItems) {
    [items addObject:[XMMCDMenuItem insertNewObjectFrom:item]];
  }
  self.items = items;
}

@end
