#import "XMMCoreDataContentBlockType5.h"

@interface XMMCoreDataContentBlockType5 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType5

+(NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
             @"artists":@"artist",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

@end
