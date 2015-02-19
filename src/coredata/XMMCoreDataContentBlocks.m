#import "XMMCoreDataContentBlocks.h"
#import "XMMCoreDataContentBlockType0.h"
#import "XMMCoreDataContentBlockType1.h"
#import "XMMCoreDataContentBlockType2.h"
#import "XMMCoreDataContentBlockType3.h"
#import "XMMCoreDataContentBlockType4.h"
#import "XMMCoreDataContentBlockType5.h"
#import "XMMCoreDataContentBlockType6.h"
#import "XMMCoreDataContentBlockType7.h"
#import "XMMCoreDataContentBlockType8.h"
#import "XMMCoreDataContentBlockType9.h"

@interface XMMCoreDataContentBlocks ()

// Private interface goes here.

@end

@implementation XMMCoreDataContentBlocks

- (NSString *)hashableDescription {
    NSString *stringA = self.publicStatus;
    NSString *stringB = self.contentBlockType;
    NSString *stringC = self.title;
    NSString *stringD = (NSString*)self.order;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@", stringA, stringB, stringC, stringD];
    return description;
}

@end
