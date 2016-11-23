//
//  XMMOfflineHelper.h
//  XamoomSDK
//
//  Created by Raphael Seher on 21/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"
#import "XMMOfflineStorageManager.h"

@interface XMMOfflineStorageTagModule : NSObject

@property (strong, nonatomic, nonnull) XMMEnduserApi *api;
@property (strong, nonatomic, nonnull) XMMOfflineStorageManager *storeManager;
@property (strong, nonatomic, nonnull, readonly) NSMutableArray *offlineTags;

- (nonnull instancetype)initWithApi:(nonnull XMMEnduserApi *)api;

- (void)downloadAndSaveWithTags:(nonnull NSArray *)tags
             downloadCompletion:(nullable void (^)(NSString * _Null_unspecified url, NSData * _Null_unspecified data, NSError * _Null_unspecified error))downloadCompletion
                     completion:(nullable void (^)( NSArray * _Null_unspecified spots , NSError * _Null_unspecified error))completion;

- (nullable NSError *)deleteSavedDataWithTags:(nonnull NSArray *)tags;

- (void)addOfflineTag:(nullable NSString *)tag;

@end
