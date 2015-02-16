#import "XMMCoreDataContentBlockType3.h"

@interface XMMCoreDataContentBlockType3 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType3

+(NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             };
}

@end
