// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType4.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreDataContentBlocks.h"

extern const struct XMMCoreDataContentBlockType4Attributes {
	__unsafe_unretained NSString *linkType;
	__unsafe_unretained NSString *linkUrl;
	__unsafe_unretained NSString *text;
} XMMCoreDataContentBlockType4Attributes;

extern const struct XMMCoreDataContentBlockType4Relationships {
	__unsafe_unretained NSString *contentBlock;
} XMMCoreDataContentBlockType4Relationships;

@class XMMCoreDataContentBlocks;

@interface XMMCoreDataContentBlockType4ID : XMMCoreDataContentBlocksID {}
@end

@interface _XMMCoreDataContentBlockType4 : XMMCoreDataContentBlocks {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlockType4ID* objectID;

@property (nonatomic, strong) NSString* linkType;

//- (BOOL)validateLinkType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* linkUrl;

//- (BOOL)validateLinkUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContentBlocks *contentBlock;

//- (BOOL)validateContentBlock:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlockType4 (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveLinkType;
- (void)setPrimitiveLinkType:(NSString*)value;

- (NSString*)primitiveLinkUrl;
- (void)setPrimitiveLinkUrl:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (XMMCoreDataContentBlocks*)primitiveContentBlock;
- (void)setPrimitiveContentBlock:(XMMCoreDataContentBlocks*)value;

@end
