#import "XMMCoreDataContentBlocks.h"

@interface XMMCoreDataContentBlocks ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlocks

+ (NSDictionary *) getMapping {
    return @{ @"public_status":@"publicStatus",
              @"content_block_type":@"contentBlockType",
              @"@metadata.mapping.collectionIndex":@"order",
              @"title":@"title",
              @"content_id":@"contentId",
              @"download_type":@"downloadType",
              @"file_id":@"fileId",
              @"link_type":@"linkType",
              @"link_url":@"linkUrl",
              @"soundcloud_url":@"soundcloudUrl",
              @"spot_map_tag":@"spotMapTag",
              @"youtube_url":@"youtubeUrl",
              };
}

@end
