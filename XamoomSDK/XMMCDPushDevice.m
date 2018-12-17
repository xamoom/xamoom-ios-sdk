//
//  XMMCDPushDevice.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 28.06.18.
//

#import "XMMCDPushDevice.h"
#import "XMMPushDevice.h"

@implementation XMMCDPushDevice

@dynamic jsonID;
@dynamic uid;
@dynamic spotDescription;
@dynamic image;
@dynamic category;
@dynamic locationDictionary;
@dynamic tags;

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
  XMMPushDevice *spot = (XMMPushDevice *)entity;
  XMMCDPushDevice *savedSpot = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance]
                      fetch:[[self class] coreDataEntityName]
                      jsonID:spot.ID];
  if (objects.count > 0) {
    savedSpot = objects.firstObject;
  } else {
    savedSpot = [NSEntityDescription
                 insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                 inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSpot.jsonID = spot.ID;
  
  savedSpot.uid = spot.uid;
  savedSpot.spotDescription = spot.spotDescription;
  savedSpot.locationDictionary = spot.locationDictionary;
  savedSpot.image = spot.image;
  if (spot.image) {
    [fileManager saveFileFromUrl:spot.image completion:completion];
  }
  savedSpot.category = [NSNumber numberWithInt:spot.category];
  savedSpot.tags = spot.tags;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedSpot;
}

@end
