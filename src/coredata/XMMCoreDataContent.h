#import "_XMMCoreDataContent.h"

@interface XMMCoreDataContent : _XMMCoreDataContent {}

+ (NSDictionary *)getMapping;

/**
 Returns the contentBlocks saved in CoreData in the correct order. You should always use the correct order, when you display conent.
 
 @return NSArray
 */
- (NSArray *)sortedContentBlocks;

@end
