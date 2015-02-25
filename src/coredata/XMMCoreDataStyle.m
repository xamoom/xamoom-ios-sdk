#import "XMMCoreDataStyle.h"
#import <CommonCrypto/CommonDigest.h>

@interface XMMCoreDataStyle ()

// Private interface goes here.

@end

@implementation XMMCoreDataStyle

+ (NSDictionary *)getMapping {
    return @{@"fg_color":@"foregroundFontColor",
             @"bg_color":@"backgroundColor",
             @"hl_color":@"highlightFontColor",
             @"ch_color":@"chromeHeaderColor",
             @"custom_marker":@"customMarker",
             @"icon":@"icon",
             };
}

@end
