// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType8.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType8Attributes {
	__unsafe_unretained NSString *downloadType;
	__unsafe_unretained NSString *fileId;
	__unsafe_unretained NSString *text;
} XMMCoreDataContentBlockType8Attributes;

extern const struct XMMCoreDataContentBlockType8Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType8Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType8ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType8 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType8ID* objectID;

@property (nonatomic, strong) NSString* downloadType;

//- (BOOL)validateDownloadType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileId;

//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType8 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDownloadType;
- (void)setPrimitiveDownloadType:(NSString*)value;

- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
