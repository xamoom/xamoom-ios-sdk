#import "_XMMCoreDataGetById.h"

@interface XMMCoreDataGetById : _XMMCoreDataGetById {}

@property NSMutableString* objectAsHash;

- (NSArray *)sortedMenuItem;

+ (NSDictionary *)getMapping;

- (void)willSave;

@end
