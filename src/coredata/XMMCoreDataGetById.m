#import "XMMCoreDataGetById.h"

@interface XMMCoreDataGetById ()

// Private interface goes here.

@end

@implementation XMMCoreDataGetById

-(void)willSave {
    self.objectAsHash = [[NSMutableString alloc] init];
    [self.objectAsHash appendString:[self hashableDescription]];
    [self setPrimitiveValue:self.objectAsHash forKey:@"identifier"];
}

- (NSString *)hashableDescription {
    NSString *stringA = self.systemId;
    NSString *stringB = self.systemName;
    NSString *stringC = self.systemUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@", stringA, stringB, stringC];
    return description;
}

@end
