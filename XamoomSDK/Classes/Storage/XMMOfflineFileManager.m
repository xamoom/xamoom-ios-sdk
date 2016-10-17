//
//  XMMOfflineFileManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 14/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMOfflineFileManager.h"
#import "NSString+MD5.h"

@implementation XMMOfflineFileManager

- (NSURL *)urlForSavedData:(NSString *)urlString {
  return [self filePathForSavedObject:urlString];
}

- (void)saveFileFromUrl:(NSString *)urlString completion:(void (^)(NSData *, NSError *))completion {
  NSURL *filePath = [self filePathForSavedObject:urlString];
  [self downloadFileFromUrl:[NSURL URLWithString:urlString] completion:^(NSData *data, NSError *error) {
    if (error != nil && completion) {
      completion(nil, error);
    }
    
    NSError *savingError;
    [data writeToURL:filePath options:NSDataWritingAtomic error:&savingError];
    
    if (savingError && completion) {
      completion(nil, savingError);
      return;
    }
    
    if (completion) {
      completion(data, nil);
    }
  }];
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

- (void)downloadFileFromUrl:(NSURL *)url completion:(void (^)(NSData *, NSError *))completion {
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      completion(nil, error);
      return;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    completion(data, nil);
  }];
  [downloadTask resume];
}

- (NSURL *)filePathForSavedObject:(NSString *)urlString {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", documentsPath]];
  NSString *fileName = urlString;
  NSURL *fileNameUrl = [NSURL URLWithString:fileName];
  fileName = [fileName MD5String];
  filePath = [filePath URLByAppendingPathComponent:fileName];
  filePath = [filePath URLByAppendingPathExtension:fileNameUrl.pathExtension];
  return filePath;
}

@end
