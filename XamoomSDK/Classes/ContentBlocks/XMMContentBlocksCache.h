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

+ (XMMContentBlocksCache *)sharedInstance;

- (void)saveSpotMap:(NSArray *)spotMap key:(NSString *)key;
- (NSArray *)cachedSpotMap:(NSString *)key;
- (void)saveContent:(XMMContent *)content key:(NSString *)contentID;
- (XMMContent *)cachedContent:(NSString *)key;

@end
