//
//  XMMOfflineFileManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 14/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMOfflineFileManager : NSObject

- (NSURL *)urlForSavedData:(NSString *)urlString;

- (void)saveFileFromUrl:(NSString *)urlString completion:(void(^)(NSData *data, NSError *error))completion;

- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError **)error;

- (UIImage *)savedImageFromUrl:(NSString *)urlString error:(NSError **)error;

@end
