//
//  XMMOfflineStorageManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface XMMOfflineStorageManager : NSObject

@property NSManagedObjectContext *managedObjectContext;

extern NSString *const MANAGED_CONTEXT_READY_NOTIFICATION;

+ (instancetype)sharedInstance;

#pragma mark - CoreData

- (NSError *)save;

- (NSArray *)fetchAll:(NSString *)entityType;

- (NSArray *)fetch:(NSString *)entityType predicate:(NSPredicate *)predicate;

- (NSArray *)fetch:(NSString *)entityType jsonID:(NSString *)jsonID;

- (void)deleteAllEntities;

@end
