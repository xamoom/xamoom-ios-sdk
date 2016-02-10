//
//  XMMContentBlocksCache.m
//  Pods
//
//  Created by Raphael Seher on 29.10.15.
//
//

#import "XMMContentBlocksCache.h"

static XMMContentBlocksCache *sharedInstance;

@interface XMMContentBlocksCache()

@property (nonatomic, strong) NSCache *spotMapCache;
@property (nonatomic, strong) NSCache *contentCache;

@end

@implementation XMMContentBlocksCache

+ (XMMContentBlocksCache *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMContentBlocksCache alloc] init];
    sharedInstance.spotMapCache = [[NSCache alloc] init];
    sharedInstance.contentCache = [[NSCache alloc] init];
  }
  return sharedInstance;
}

- (void)saveSpotMap:(NSArray *)spotMap key:(NSString *)key {
  [self.spotMapCache setObject:spotMap forKey:key];
}

- (NSArray *)cachedSpotMap:(NSString *)key {
  return [self.spotMapCache objectForKey:key];
}

- (void)saveContent:(XMMContent *)content key:(NSString *)contentID {
  [self.contentCache setObject:content forKey:contentID];
}

- (XMMContent *)cachedContent:(NSString *)key {
  return [self.contentCache objectForKey:key];
}

@end
