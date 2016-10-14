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

+ (NSURL *)urlForSavedData:(NSString *)urlString {
  return [self filePathForSavedObject:urlString];
}

- (void)saveFileFromUrl:(NSString *)urlString completion:(void (^)(NSData *, NSError *))completion {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *filePath = [XMMOfflineFileManager filePathForSavedObject:urlString];
    NSData *data = [self downloadFileFromUrl:[NSURL URLWithString:urlString] completion:completion];
    NSError *error;
    [data writeToURL:filePath options:NSDataWritingWithoutOverwriting error:&error];
    
    // load existing file
    if (error != nil && error.code == 516) {
      error = nil;
      data = [self savedDataFromUrl:urlString error:&error];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error && completion) {
        completion(nil, error);
        return;
      }
      
      if (completion) {
        completion(data, nil);
      }
    });
  });
}

- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSURL *filePath = [XMMOfflineFileManager filePathForSavedObject:urlString];
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
  if (error && completion) {
    completion(nil, error);
  }
  return data;
}

+ (NSURL *)filePathForSavedObject:(NSString *)urlString {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", documentsPath]];
  NSString *fileName = urlString;
  fileName = [fileName MD5String];
  filePath = [filePath URLByAppendingPathComponent:fileName];
  return filePath;
}

@end
