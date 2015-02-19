#import "XMMCoreDataMenuItem.h"

@interface XMMCoreDataMenuItem ()

// Private interface goes here.

@end

@implementation XMMCoreDataMenuItem

+ (NSDictionary *)getMapping {
    return @{@"item_label":@"itemLabel",
             @"content_id":@"contentId",
             @"@metadata.mapping.collectionIndex" : @"order",
             };
}

- (NSString *)hashableDescription {
    NSString *stringA = self.itemLabel;
    NSString *stringB = self.contentId;
    NSString *stringC = (NSString*)self.order;

    NSString *description = [NSString stringWithFormat:@"%@,%@,%@", stringA, stringB, stringC];
    return description;
}

@end
