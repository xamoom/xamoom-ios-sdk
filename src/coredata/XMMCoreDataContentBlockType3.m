#import "XMMCoreDataContentBlockType3.h"

@interface XMMCoreDataContentBlockType3 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType3

+(NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
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
    NSString *stringE = self.fileId;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
