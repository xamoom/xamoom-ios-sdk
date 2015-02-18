#import "XMMCoreData.h"

@interface XMMCoreData ()

// Private interface goes here.

@end

@implementation XMMCoreData

@synthesize objectAsHash;

+ (NSDictionary *)getMapping {
    return @{@"system_id" : @"systemId",
             @"system_name" : @"systemName",
             @"system_url" : @"systemUrl"
             };
}

@end
