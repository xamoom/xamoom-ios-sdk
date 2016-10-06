//
//  XMMCDContent.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDContent.h"
#import "XMMCDSpot.h"

@implementation XMMCDContent

@dynamic jsonID;
@dynamic title;
@dynamic imagePublicUrl;
@dynamic contentDescription;
@dynamic language;
@dynamic contentBlocks;
@dynamic category;
@dynamic tags;
@dynamic system;
@dynamic spot;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  XMMContent *content = (XMMContent *)entity;
  XMMCDContent *savedContent = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:content.ID];
  if (objects.count > 0) {
    savedContent = objects.firstObject;
  } else {
    savedContent = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedContent.jsonID = content.ID;
  
  NSMutableOrderedSet *contentBlocks = [[NSMutableOrderedSet alloc] init];
  for (XMMContentBlock *block in content.contentBlocks) {
    [contentBlocks addObject:[XMMCDContentBlock insertNewObjectFrom:block]];
  }
  savedContent.contentBlocks = contentBlocks;
  
  if (content.spot != nil) {
    savedContent.spot = [XMMCDSpot insertNewObjectFrom:content.spot];
  }
  savedContent.system = [XMMCDSystem insertNewObjectFrom:content.system];
  savedContent.title = content.title;
  savedContent.imagePublicUrl = content.imagePublicUrl;
  savedContent.contentDescription = content.contentDescription;
  savedContent.language = content.language;
  savedContent.category = [NSNumber numberWithInt:content.category];
  savedContent.tags = content.tags;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedContent;
}

@end
