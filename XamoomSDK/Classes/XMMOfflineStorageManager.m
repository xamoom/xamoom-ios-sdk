//
//  XMMOfflineStorageManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineStorageManager.h"
#import "NSString+MD5.h"
#import "XMMCDContent.h"
#import "XMMCDContentBlock.h"
#import "XMMCDMarker.h"
#import "XMMCDMenu.h"
#import "XMMCDMenuItem.h"
#import "XMMCDSpot.h"
#import "XMMCDStyle.h"
#import "XMMCDSystem.h"
#import "XMMCDSystem.h"
#import "XMMCDSystemSettings.h"

@implementation XMMOfflineStorageManager

static XMMOfflineStorageManager *sharedMyManager = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

+ (void)setSharedInstance:(XMMOfflineStorageManager *)offlineStoreManager {
  dispatch_once(&onceToken, ^{
    sharedMyManager = offlineStoreManager;
  });
}

+ (NSURL *)urlForSavedData:(NSString *)urlString {
  return [[self sharedInstance] filePathForSavedObject:urlString];
}

- (id)init {
  self = [super init];
  
  [self initializeCoreData];
  
  return self;
}

- (void)initializeCoreData {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMOfflineStorageManager class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *sdkBundle;
  if (url) {
    sdkBundle = [NSBundle bundleWithURL:url];
  } else {
    sdkBundle = bundle;
  }
  
  NSURL *modelURL = [sdkBundle URLForResource:@"EnduserOfflineDatamodel" withExtension:@"momd"];
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

#pragma mark - CoreData

- (NSError *)save {
  NSError *error = nil;
  [self.managedObjectContext save:&error];
  return error;
}

- (NSArray *)fetchAll:(NSString *)entityType {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityType];
  NSError *error = nil;
  return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray *)fetch:(NSString *)entityType predicate:(NSPredicate *)predicate {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityType];
  request.predicate = predicate;
  NSError *error = nil;
  return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (NSArray *)fetch:(NSString *)entityType jsonID:(NSString *)jsonID {
  return [self fetch:entityType
           predicate:[NSPredicate predicateWithFormat:@"jsonID == %@", jsonID]];
}

- (void)deleteAllEntities {
  NSArray *entityArray = @[[XMMCDContent class],[XMMCDContentBlock class],[XMMCDMarker class],[XMMCDMenu class],[XMMCDMenuItem class],[XMMCDSpot class],[XMMCDStyle class],[XMMCDSystem class],[XMMCDSystemSettings class]];
  for (Class entityClass in entityArray) {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[entityClass coreDataEntityName]];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetch];
    [self.managedObjectContext executeRequest:deleteRequest error:nil];
  }
}

#pragma mark - File handling

- (void)saveFileFromUrl:(NSString *)urlString completion:(void (^)(NSData *, NSError *))completion {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *filePath = [self filePathForSavedObject:urlString];
    NSData *data = [self downloadFileFromUrl:[NSURL URLWithString:urlString] completion:completion];
    NSError *error;
    [data writeToURL:filePath options:NSDataWritingWithoutOverwriting error:&error];
    
    // load existing file
    if (error != nil && error.code == 516) {
      error = nil;
      data = [self savedDataFromUrl:urlString error:&error];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        completion(nil, error);
        return;
      }
      
      completion(data, nil);
    });
  });
}

- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSURL *filePath = [self filePathForSavedObject:urlString];
  NSData *data = [NSData dataWithContentsOfURL:filePath options:0 error:error];
  return data;
}

- (UIImage *)savedImageFromUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSData *data = [self savedDataFromUrl:urlString error:error];
  UIImage *image = [UIImage imageWithData:data];
  return image;
}

#pragma mark - Helper

- (NSData *)downloadFileFromUrl:(NSURL *)url completion:(void (^)(NSData *, NSError *))completion {
  NSError *error = nil;
  NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
  if (error) {
    completion(nil, error);
  }
  return data;
}

- (NSURL *)filePathForSavedObject:(NSString *)urlString {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", documentsPath]];
  NSString *fileName = urlString;
  fileName = [fileName MD5String];
  filePath = [filePath URLByAppendingPathComponent:fileName];
  return filePath;
}

@end
