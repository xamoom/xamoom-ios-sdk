//
//  XMMOfflineDownloadManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMOfflineDownloadManager : NSObject <NSURLSessionDelegate>

extern NSString *const kXamoomOfflineUpdateDownloadCount;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *currentDownloads;

+ (instancetype)sharedInstance;

- (void)downloadFileFromUrl:(NSURL *)url completion:(void (^)(NSData *, NSError *))completion;

@end
