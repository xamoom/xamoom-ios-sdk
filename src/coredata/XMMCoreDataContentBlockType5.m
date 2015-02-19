#import "XMMCoreDataContentBlockType5.h"

@interface XMMCoreDataContentBlockType5 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType5

+(NSDictionary *)getMapping
{
    return @{@"file_id":@"fileId",
             @"artists":@"artist",
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
    NSString *stringF = self.artist;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE, stringF];
    return description;
}

@end
