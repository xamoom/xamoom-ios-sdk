#import "_XMMCoreDataGetById.h"

@interface XMMCoreDataGetById : _XMMCoreDataGetById {}

- (NSArray *)sortedMenuItem;

+ (NSDictionary *)getMapping;

- (void)willSave;

@end
