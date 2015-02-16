#import "XMMCoreDataContentBlockType1.h"

@interface XMMCoreDataContentBlockType1 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType1

+ (NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             @"artists":@"artist",
             };
}


@end
