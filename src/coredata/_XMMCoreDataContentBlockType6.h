// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType6.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType6Attributes {
	__unsafe_unretained NSString *contentId;
} XMMCoreDataContentBlockType6Attributes;

extern const struct XMMCoreDataContentBlockType6Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType6Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType6ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType6 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType6ID* objectID;

@property (nonatomic, strong) NSString* contentId;

//- (BOOL)validateContentId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType6 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContentId;
- (void)setPrimitiveContentId:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
