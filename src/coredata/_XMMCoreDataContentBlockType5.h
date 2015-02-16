// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType5.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType5Attributes {
	__unsafe_unretained NSString *artist;
	__unsafe_unretained NSString *fileId;
} XMMCoreDataContentBlockType5Attributes;

extern const struct XMMCoreDataContentBlockType5Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType5Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType5ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType5 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType5ID* objectID;

@property (nonatomic, strong) NSString* artist;

//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileId;

//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType5 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveArtist;
- (void)setPrimitiveArtist:(NSString*)value;

- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
