//
//  XMMOfflineStorageManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineStorageManager.h"

@implementation XMMOfflineStorageManager

- (id)init {
  self = [super init];
  
  [self initializeCoreData];
  
  return self;
}

- (void)initializeCoreData {
  NSBundle *bundle = [NSBundle bundleForClass:self.class];
  NSURL *modelURL = [bundle URLForResource:@"EnduserModel" withExtension:@"momd"];
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  NSAssert(mom != nil, @"Error initializing Managed Object Model");
  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [moc setPersistentStoreCoordinator:psc];
  self.managedObjectContext = moc;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
  NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
  
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    NSError *error = nil;
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
  });
}

- (NSManagedObject *)saveEntity:(id)entity {
  return nil;
}

@end
