#import "XMMCoreDataContentBlockType9.h"

@interface XMMCoreDataContentBlockType9 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType9

+ (NSDictionary *)getMapping
{
    return @{@"spot_map_tag":@"spotMapTag",
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
    NSString *stringE = self.spotMapTag;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
