#import "XMMCoreDataContentBlockType8.h"

@interface XMMCoreDataContentBlockType8 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType8

+(NSDictionary *)getMapping
{
    return @{@"download_type":@"downloadType",
             @"file_id":@"fileId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"text":@"text",
             @"title":@"title",
             };
}

@end
