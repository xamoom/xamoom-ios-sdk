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
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

- (NSString *)hashableDescription {
    NSString *stringA = self.publicStatus;
    NSString *stringB = self.contentBlockType;
    NSString *stringC = self.title;
    NSString *stringD = (NSString*)self.order;
    NSString *stringE = self.text;
    NSString *stringF = self.linkType;
    NSString *stringG = self.linkUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE, stringF, stringG];
    return description;
}

@end
