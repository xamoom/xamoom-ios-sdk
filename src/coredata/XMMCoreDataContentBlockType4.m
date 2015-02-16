#import "XMMCoreDataContentBlockType4.h"

@interface XMMCoreDataContentBlockType4 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType4

+ (NSDictionary *)getMapping
{
    return @{@"text":@"text",
             @"link_url":@"linkUrl",
             @"link_type":@"linkType",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             };
}

@end
