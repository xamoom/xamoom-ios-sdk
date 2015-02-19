#import "XMMCoreDataContentBlockType7.h"

@interface XMMCoreDataContentBlockType7 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType7

+ (NSDictionary *)getMapping
{
    return @{@"soundcloud_url":@"soundcloudUrl",
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
    NSString *stringE = self.soundcloudUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
