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

- (NSString *)hashableDescription {
    NSString *string1 = self.publicStatus;
    NSString *string2 = self.contentBlockType;
    NSString *string3 = [self.order stringValue];
    NSString *string4 = self.title;
    NSString *string5 = self.contentId;
    NSString *string6 = self.downloadType;
    NSString *string7 = self.fileId;
    NSString *string8 = self.linkType;
    NSString *string9 = self.linkUrl;
    NSString *string10 = self.soundcloudUrl;
    NSString *string11 = self.spotMapTag;
    NSString *string12 = self.youtubeUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@", string1, string2, string3, string4, string5, string6, string7, string8, string9, string10, string11, string12];
    return description;
}

@end
