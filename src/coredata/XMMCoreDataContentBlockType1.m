#import "XMMCoreDataContentBlockType1.h"

@interface XMMCoreDataContentBlockType1 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType1

+ (NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"title":@"title",
             @"artists":@"artist",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

- (NSString *)hashableDescription {
    NSString *stringA = self.publicStatus;
    NSString *stringB = self.contentBlockType;
    NSString *stringC = self.title;
    NSString *stringD = (NSString*)self.order;
    NSString *stringE = self.fileId;
    NSString *stringF = self.artist;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE, stringF];
    return description;
}

@end
