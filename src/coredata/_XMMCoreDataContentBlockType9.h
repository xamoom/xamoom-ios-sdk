// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType9.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType9Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType9Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType9ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType9 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType9ID* objectID;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType9 (CoreDataGeneratedPrimitiveAccessors)

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
