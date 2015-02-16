// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType1.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType1Attributes {
	__unsafe_unretained NSString *artists;
	__unsafe_unretained NSString *fileId;
} XMMCoreDataContentBlockType1Attributes;

extern const struct XMMCoreDataContentBlockType1Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType1Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType1ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType1 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType1ID* objectID;

@property (nonatomic, strong) NSString* artists;

//- (BOOL)validateArtists:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileId;

//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType1 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveArtists;
- (void)setPrimitiveArtists:(NSString*)value;

- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
