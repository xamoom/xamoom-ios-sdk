#import "XMMCoreDataContentBlockType8.h"

@interface XMMCoreDataContentBlockType8 ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlockType8

+(NSDictionary *)getMapping
{
    return @{@"download_type":@"downloadType",
             @"file_id":@"fileId",
             @"public":@"publicStatus",
             @"content_block_type":@"contentBlockType",
             @"text":@"text",
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
    NSString *stringF = self.downloadType;
    NSString *stringG = self.fileId;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE, stringF, stringG];
    return description;
}

@end
