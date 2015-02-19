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
    //insert contentBlockTypes
    NSString *cbType0 = [self.contentBlockType0 hashableDescription];
    NSString *cbType1 = [self.contentBlockType1 hashableDescription];
    NSString *cbType2 = [self.contentBlockType2 hashableDescription];
    NSString *cbType3 = [self.contentBlockType3 hashableDescription];
    NSString *cbType4 = [self.contentBlockType4 hashableDescription];
    NSString *cbType5 = [self.contentBlockType5 hashableDescription];
    NSString *cbType6 = [self.contentBlockType6 hashableDescription];
    NSString *cbType7 = [self.contentBlockType7 hashableDescription];
    NSString *cbType8 = [self.contentBlockType8 hashableDescription];
    NSString *cbType9 = [self.contentBlockType9 hashableDescription];
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@", cbType0, cbType1, cbType2, cbType3, cbType4, cbType5, cbType6, cbType7, cbType8, cbType9];
    return description;
}

@end
