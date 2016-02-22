//
//  XMMContentBlocksCache.h
//  Pods
//
//  Created by Raphael Seher on 29.10.15.
//
//

#import <Foundation/Foundation.h>
#import <XMMContent.h>

@interface XMMContentBlocksCache : NSObject

@property (nonatomic, strong) NSCache *spotMapCache;
@property (nonatomic, strong) NSCache *contentCache;

+ (XMMContentBlocksCache *)sharedInstance;

- (void)saveSpots:(NSArray *)spotMap key:(NSString *)key;
- (NSArray *)cachedSpotMap:(NSString *)key;
- (void)saveContent:(XMMContent *)content key:(NSString *)contentID;
- (XMMContent *)cachedContent:(NSString *)key;

@end
