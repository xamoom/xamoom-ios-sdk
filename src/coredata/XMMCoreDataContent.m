#import "XMMCoreDataContent.h"

@interface XMMCoreDataContent ()

// Private interface goes here.

@end

@implementation XMMCoreDataContent

+ (NSDictionary *)getMapping
{
    return @{@"description":@"descriptionOfContent",
             @"language":@"language",
             @"title":@"title",
             @"image_public_url":@"imagePublicUrl",
             };
}

@end
