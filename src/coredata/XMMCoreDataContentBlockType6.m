#import "XMMCoreDataContentBlockType6.h"

@interface XMMCoreDataContentBlockType6 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType6

+(NSDictionary *)getMapping
{
    return @{@"content_id":@"contentId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

- (NSString *)hashableDescription {
    NSString *stringA = self.publicStatus;
    NSString *stringB = self.contentBlockType;
    NSString *stringC = self.title;
    NSString *stringD = (NSString*)self.order;
    NSString *stringE = self.contentId;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
