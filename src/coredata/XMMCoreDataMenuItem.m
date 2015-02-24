#import "XMMCoreDataMenuItem.h"

@interface XMMCoreDataMenuItem ()

// Private interface goes here.

@end

@implementation XMMCoreDataMenuItem

+ (NSDictionary *)getMapping {
    return @{@"item_label":@"itemLabel",
             @"content_id":@"contentId",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

@end
