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

@end
