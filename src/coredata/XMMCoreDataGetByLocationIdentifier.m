#import "XMMCoreDataGetByLocationIdentifier.h"

@interface XMMCoreDataGetByLocationIdentifier ()

// Private interface goes here.

@end

@implementation XMMCoreDataGetByLocationIdentifier

+ (NSDictionary *)getMapping
{
    return @{@"system_name":@"systemName",
             @"system_url":@"systemUrl",
             @"system_id":@"systemId",
             @"has_content":@"hasContent",
             @"has_spot":@"hasSpot",
             };
}

@end
