#import "XMMCoreDataContentBlockType2.h"

@interface XMMCoreDataContentBlockType2 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType2

+ (NSDictionary *)getMapping
{
    return @{@"youtube_url":@"youtubeUrl",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             };
}

@end
