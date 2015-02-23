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

- (NSString *)hashableDescription {
    NSString *stringA = self.foregroundFontColor;
    NSString *stringB = self.backgroundColor;
    NSString *stringC = self.highlightFontColor;
    NSString *stringD = self.customMarker;
    NSString *stringE = self.icon;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", stringA, stringB, stringC, stringD, stringE];
    return description;
}

@end
