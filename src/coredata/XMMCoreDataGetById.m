#import <CommonCrypto/CommonDigest.h>
#import "XMMEnduserApi.h"
#import "XMMCoreDataGetById.h"
#import "XMMCoreDataMenuItem.h"
#import "XMMCoreDataStyle.h"
#import "XMMCoreDataContent.h"
#import "XMMCoreDataContentBlocks.h"

@interface XMMCoreDataGetById ()

// Private interface goes here.

@end

@implementation XMMCoreDataGetById

+ (NSDictionary *)getMapping {
    return @{@"system_name":@"systemName",
             @"system_url":@"systemUrl",
             @"system_id":@"systemId",
             @"has_content":@"hasContent",
             @"has_spot":@"hasSpot",
             @"content.content_id":@"contentId",
             };
}

-(NSArray *)sortedMenuItem {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *sorting = [NSArray arrayWithObject:descriptor];
    
    return [self.menu sortedArrayUsingDescriptors:sorting];
}


@end
