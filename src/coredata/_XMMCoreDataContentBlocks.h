// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlocks.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataContentBlocksAttributes {
	__unsafe_unretained NSString *contentBlockType;
	__unsafe_unretained NSString *publicStatus;
	__unsafe_unretained NSString *title;
} XMMCoreDataContentBlocksAttributes;

extern const struct XMMCoreDataContentBlocksRelationships {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *contentBlockType0;
	__unsafe_unretained NSString *contentBlockType1;
	__unsafe_unretained NSString *contentBlockType2;
	__unsafe_unretained NSString *contentBlockType3;
} XMMCoreDataContentBlocksRelationships;

@class XMMCoreDataContent;
@class XMMCoreDataContentBlockType0;
@class XMMCoreDataContentBlockType1;
@class XMMCoreDataContentBlockType2;
@class XMMCoreDataContentBlockType3;

@interface XMMCoreDataContentBlocksID : NSManagedObjectID {}
@end

@interface _XMMCoreDataContentBlocks : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlocksID* objectID;

@property (nonatomic, strong) NSString* contentBlockType;

//- (BOOL)validateContentBlockType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* publicStatus;

//- (BOOL)validatePublicStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContent *content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType0 *contentBlockType0;

//- (BOOL)validateContentBlockType0:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType1 *contentBlockType1;

//- (BOOL)validateContentBlockType1:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType2 *contentBlockType2;

//- (BOOL)validateContentBlockType2:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType3 *contentBlockType3;

//- (BOOL)validateContentBlockType3:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlocks (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContentBlockType;
- (void)setPrimitiveContentBlockType:(NSString*)value;

- (NSString*)primitivePublicStatus;
- (void)setPrimitivePublicStatus:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (XMMCoreDataContent*)primitiveContent;
- (void)setPrimitiveContent:(XMMCoreDataContent*)value;

- (XMMCoreDataContentBlockType0*)primitiveContentBlockType0;
- (void)setPrimitiveContentBlockType0:(XMMCoreDataContentBlockType0*)value;

- (XMMCoreDataContentBlockType1*)primitiveContentBlockType1;
- (void)setPrimitiveContentBlockType1:(XMMCoreDataContentBlockType1*)value;

- (XMMCoreDataContentBlockType2*)primitiveContentBlockType2;
- (void)setPrimitiveContentBlockType2:(XMMCoreDataContentBlockType2*)value;

- (XMMCoreDataContentBlockType3*)primitiveContentBlockType3;
- (void)setPrimitiveContentBlockType3:(XMMCoreDataContentBlockType3*)value;

@end
