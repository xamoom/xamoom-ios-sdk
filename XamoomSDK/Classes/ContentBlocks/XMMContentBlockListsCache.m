//
//  XMMContentBlock6Cache.m
//  abseil
//
//  Created by G0yter on 31.03.2021.
//

#import "XMMContentBlockListsCache.h"

static XMMContentBlockListsCache *sharedInstance;

@interface XMMContentBlockListsCache()

@end

@implementation XMMContentBlockListsCache


+ (XMMContentBlockListsCache *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMContentBlockListsCache alloc] init];
    sharedInstance.contentCache = [[NSCache alloc] init];
  }
  return sharedInstance;
}

- (void)saveContent:(XMMContent *)content key:(NSString *)contentID {
  [self.contentCache setObject:content forKey:contentID];
}

- (XMMContent *)cachedContent:(NSString *)key {
  return [self.contentCache objectForKey:key];
}

- (void) removeCache {
    [self.contentCache removeAllObjects];
}

@end
