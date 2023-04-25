//
//  XMMContentBlock6Cache.h
//  Pods
//
//  Created by G0yter on 31.03.2021.
//

#import <Foundation/Foundation.h>
#import "XMMContent.h"

@interface ExpiringCacheItem : NSObject

@property (nonatomic, strong) XMMContent *content;
@property (nonatomic, assign) NSDate *expiringCacheItemDate;

@end

@interface XMMContentBlockListsCache : NSObject

@property (nonatomic, strong) NSCache *contentCache;

+ (XMMContentBlockListsCache *) sharedInstance;

- (void)saveContent:(XMMContent *)content key:(NSString *)contentID;
- (XMMContent *)cachedContent:(NSString *)key;
- (void)removeCache;
    
@end