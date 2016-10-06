//
//  XMMCDSpot.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDSpot.h"
#import "XMMCDContent.h"

@implementation XMMCDSpot

@dynamic jsonID;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  XMMSpot *spot = (XMMSpot *)entity;
  XMMCDSpot *savedSpot = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:spot.ID];
  if (objects.count > 0) {
    savedSpot = objects.firstObject;
  } else {
    savedSpot = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                 inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSpot.jsonID = spot.ID;
  savedSpot.content = [XMMCDContent insertNewObjectFrom:spot.content];
  savedSpot.system = [XMMCDSystem insertNewObjectFrom:spot.system];
  NSMutableSet *markers = [[NSMutableSet alloc] init];
  for (XMMMarker *marker in spot.markers) {
    [markers addObject:[XMMCDMarker insertNewObjectFrom:marker]];
  }
  savedSpot.markers = markers;
  savedSpot.name = spot.name;
  savedSpot.spotDescription = spot.spotDescription;
  savedSpot.locationDictionary = spot.locationDictionary;
  savedSpot.image = spot.image;
  savedSpot.category = [NSNumber numberWithInt:spot.category];
  savedSpot.tags = spot.tags;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedSpot;
}

@end
