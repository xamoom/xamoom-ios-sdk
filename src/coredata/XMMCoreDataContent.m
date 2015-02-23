#import "XMMCoreDataContent.h"

@interface XMMCoreDataContent ()

// Private interface goes here.

@end

@implementation XMMCoreDataContent

+ (NSDictionary *)getMapping{
    return @{@"description":@"descriptionOfContent",
             @"language":@"language",
             @"title":@"title",
             @"image_public_url":@"imagePublicUrl",
             };
}


-(NSArray *)sortedContentBlocks {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *sorting = [NSArray arrayWithObject:descriptor];
    
    return [self.contentBlocks sortedArrayUsingDescriptors:sorting];
}

- (NSString *)hashableDescription {
    NSString *stringA = self.descriptionOfContent;
    NSString *stringB = self.language;
    NSString *stringC = self.title;
    NSString *stringD = self.imagePublicUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@", stringA, stringB, stringC, stringD];
    return description;
}

@end
