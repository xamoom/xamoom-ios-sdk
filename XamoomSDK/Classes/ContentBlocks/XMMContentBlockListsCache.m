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

@implementation ExpiringCacheItem

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
  ExpiringCacheItem *cachedItem = [[ExpiringCacheItem alloc] init];
  cachedItem.content = content;
  cachedItem.expiringCacheItemDate = [NSDate date];
  [self.contentCache setObject:cachedItem forKey:contentID];
}

- (XMMContent *)cachedContent:(NSString *)key {
  @try {
    ExpiringCacheItem *object = [self.contentCache objectForKey:key];

    if (object) {
      NSTimeInterval timeSinceCache = fabs([object.expiringCacheItemDate timeIntervalSinceNow]);
      // default 10 min
      if (timeSinceCache > 600) {
        [self.contentCache removeObjectForKey:key];
        return nil;
      }
    }

    return object.content;
  }

  @catch (NSException *exception) {
    return nil;
  }
  return [self.contentCache objectForKey:key];
}

- (void) removeCache {
//    [self.contentCache removeAllObjects];
}

@end
