#import "XMMCoreDataContentBlockType0.h"

@interface XMMCoreDataContentBlockType0 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType0

+ (NSDictionary*)getMapping
{
    return @{@"text":@"text",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

@end
