//
//  XMMOfflineDownloadManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineDownloadManager.h"

static XMMOfflineDownloadManager *sharedInstance;

@implementation XMMOfflineDownloadManager

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[XMMOfflineDownloadManager alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.currentDownloads = [[NSMutableArray alloc] init];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
  }
  return self;
}

- (void)downloadFileFromUrl:(NSURL *)url completion:(void (^)(NSData *data, NSError *error))completion {
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    [self.currentDownloads removeObject:downloadTask];
    
    if (error) {
      completion(nil, error);
      return;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    completion(data, nil);
  }];
  
  [self.currentDownloads addObject:downloadTask];
  
  [downloadTask resume];
}

@end
