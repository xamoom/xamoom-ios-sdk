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
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

- (NSString *)hashableDescription {
    NSString *stringA = self.publicStatus;
    NSString *stringB = self.contentBlockType;
    NSString *stringC = self.title;
    NSString *stringD = (NSString*)self.order;
    NSString *stringE = self.youtubeUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
