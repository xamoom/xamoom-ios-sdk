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

@end

@implementation XMMContentBlocksCache

+ (XMMContentBlocksCache *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMContentBlocksCache alloc] init];
    sharedInstance.spotMapCache = [[NSCache alloc] init];
  }
  return sharedInstance;
}

-(void)saveSpotMap:(XMMSpotMap *)spotMap key:(NSString *)key {
  [self.spotMapCache setObject:spotMap forKey:key];
}

- (XMMSpotMap *)cachedSpotMap:(NSString *)key {
  return [self.spotMapCache objectForKey:key];
}

@end
