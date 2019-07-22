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
@dynamic os;
@dynamic appVersion;
@dynamic appId;
@dynamic location;
@dynamic lastAppOpen;
@dynamic createdAt;
@dynamic updatedAt;

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
  XMMPushDevice *pushDevice = (XMMPushDevice *)entity;
  XMMCDPushDevice *savedPushDevice = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance]
                      fetch:[[self class] coreDataEntityName]
                      jsonID:pushDevice.ID];
  if (objects.count > 0) {
    savedPushDevice = objects.firstObject;
  } else {
    savedPushDevice = [NSEntityDescription
                 insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                 inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedPushDevice.jsonID = pushDevice.ID;
  savedPushDevice.uid = pushDevice.uid;
  savedPushDevice.os = pushDevice.os;
  savedPushDevice.appVersion = pushDevice.appVersion;
  savedPushDevice.appId = pushDevice.appId;
  savedPushDevice.location = pushDevice.location;
  savedPushDevice.lastAppOpen = pushDevice.lastAppOpen;
  savedPushDevice.updatedAt = pushDevice.updatedAt;
  savedPushDevice.createdAt = pushDevice.createdAt;
  savedPushDevice.language = pushDevice.language;
  savedPushDevice.sdkVersion = pushDevice.sdkVersion;
  savedPushDevice.sound = pushDevice.sound;
  savedPushDevice.noNotification = pushDevice.noNotification;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedPushDevice;
}

@end
