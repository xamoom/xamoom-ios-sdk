// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType3.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType3Attributes {
	__unsafe_unretained NSString *fileId;
} XMMCoreDataContentBlockType3Attributes;

extern const struct XMMCoreDataContentBlockType3Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType3Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType3ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType3 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType3ID* objectID;

@property (nonatomic, strong) NSString* fileId;

//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType3 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
