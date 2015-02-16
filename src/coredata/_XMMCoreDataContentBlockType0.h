// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType0.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType0Attributes {
	__unsafe_unretained NSString *text;
} XMMCoreDataContentBlockType0Attributes;

extern const struct XMMCoreDataContentBlockType0Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType0Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType0ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType0 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType0ID* objectID;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType0 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
