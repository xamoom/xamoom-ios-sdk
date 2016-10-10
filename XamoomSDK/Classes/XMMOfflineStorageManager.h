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

+ (instancetype)sharedInstance;

+ (NSURL *)urlForSavedData:(NSString *)urlString;

- (NSError *)save;

- (NSArray *)fetch:(NSString *)entityType jsonID:(NSString *)jsonID;

- (void)saveFileFromUrl:(NSString *)urlString completion:(void(^)(NSData *data, NSError *error))completion;

- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError **)error;

- (UIImage *)savedImageFromUrl:(NSString *)urlString error:(NSError **)error;

@end
