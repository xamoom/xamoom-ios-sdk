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

@property (strong, nonatomic) XMMEnduserApi *api;
@property (strong, nonatomic) XMMOfflineStorageManager *storeManager;
@property (strong, nonatomic, readonly) NSMutableArray *offlineTags;

- (instancetype)initWithApi:(XMMEnduserApi * __nonnull)api;

- (void)downloadAndSaveWithTags:(NSArray *)tags completion:(void (^)(NSArray *spots, NSError *error))completion;

- (NSError *)deleteSavedDataWithTags:(NSArray *)tags;

- (void)addOfflineTag:(NSString *)tag;

@end
