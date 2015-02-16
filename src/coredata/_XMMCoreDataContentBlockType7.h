// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType7.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType7Attributes {
	__unsafe_unretained NSString *soundcloudUrl;
} XMMCoreDataContentBlockType7Attributes;

extern const struct XMMCoreDataContentBlockType7Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType7Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType7ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType7 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType7ID* objectID;

@property (nonatomic, strong) NSString* soundcloudUrl;

//- (BOOL)validateSoundcloudUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType7 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveSoundcloudUrl;
- (void)setPrimitiveSoundcloudUrl:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
