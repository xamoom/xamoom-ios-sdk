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
	__unsafe_unretained NSString *contentBlockType4;
	__unsafe_unretained NSString *contentBlockType5;
	__unsafe_unretained NSString *contentBlockType6;
	__unsafe_unretained NSString *contentBlockType7;
} XMMCoreDataContentBlocksRelationships;

@class XMMCoreDataContent;
@class XMMCoreDataContentBlockType0;
@class XMMCoreDataContentBlockType1;
@class XMMCoreDataContentBlockType2;
@class XMMCoreDataContentBlockType3;
@class XMMCoreDataContentBlockType4;
@class XMMCoreDataContentBlockType5;
@class XMMCoreDataContentBlockType6;
@class XMMCoreDataContentBlockType7;

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

@property (nonatomic, strong) XMMCoreDataContentBlockType4 *contentBlockType4;

//- (BOOL)validateContentBlockType4:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType5 *contentBlockType5;

//- (BOOL)validateContentBlockType5:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType6 *contentBlockType6;

//- (BOOL)validateContentBlockType6:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlockType7 *contentBlockType7;

//- (BOOL)validateContentBlockType7:(id*)value_ error:(NSError**)error_;

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

- (XMMCoreDataContentBlockType4*)primitiveContentBlockType4;
- (void)setPrimitiveContentBlockType4:(XMMCoreDataContentBlockType4*)value;

- (XMMCoreDataContentBlockType5*)primitiveContentBlockType5;
- (void)setPrimitiveContentBlockType5:(XMMCoreDataContentBlockType5*)value;

- (XMMCoreDataContentBlockType6*)primitiveContentBlockType6;
- (void)setPrimitiveContentBlockType6:(XMMCoreDataContentBlockType6*)value;

- (XMMCoreDataContentBlockType7*)primitiveContentBlockType7;
- (void)setPrimitiveContentBlockType7:(XMMCoreDataContentBlockType7*)value;

@end
