#import "XMMCoreDataGetByLocationItem.h"

@interface XMMCoreDataGetByLocationItem ()

// Private interface goes here.

@end

@implementation XMMCoreDataGetByLocationItem

+ (NSDictionary *)getMapping
{
    return @{@"system_name":@"systemName",
             @"system_url":@"systemUrl",
             @"system_id":@"systemId",
             @"content_id":@"contentId",
             @"description":@"descriptionOfContent",
             @"language":@"language",
             @"title":@"title",
             @"style_bg_color":@"backgroundColor",
             @"lat":@"lat",
             @"lon":@"lon",
             @"style_fg_color":@"foregroundFontColor",
             @"style_icon":@"icon",
             @"style_hl_color":@"highlightFontColor",
             @"image_public_url":@"imagePublicUrl",
             };
}

@end
