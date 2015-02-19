// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContent.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataContentAttributes {
	__unsafe_unretained NSString *descriptionOfContent;
	__unsafe_unretained NSString *imagePublicUrl;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *title;
} XMMCoreDataContentAttributes;

extern const struct XMMCoreDataContentRelationships {
	__unsafe_unretained NSString *contentBlocks;
	__unsafe_unretained NSString *coreDataGetById;
} XMMCoreDataContentRelationships;

@class XMMCoreDataContentBlocks;
@class XMMCoreDataGetById;

@interface XMMCoreDataContentID : NSManagedObjectID {}
@end

@interface _XMMCoreDataContent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentID* objectID;

@property (nonatomic, strong) NSString* descriptionOfContent;

//- (BOOL)validateDescriptionOfContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imagePublicUrl;

//- (BOOL)validateImagePublicUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* language;

//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *contentBlocks;

- (NSMutableSet*)contentBlocksSet;

@property (nonatomic, strong) XMMCoreDataGetById *coreDataGetById;

//- (BOOL)validateCoreDataGetById:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContent (ContentBlocksCoreDataGeneratedAccessors)
- (void)addContentBlocks:(NSSet*)value_;
- (void)removeContentBlocks:(NSSet*)value_;
- (void)addContentBlocksObject:(XMMCoreDataContentBlocks*)value_;
- (void)removeContentBlocksObject:(XMMCoreDataContentBlocks*)value_;

@end

@interface _XMMCoreDataContent (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDescriptionOfContent;
- (void)setPrimitiveDescriptionOfContent:(NSString*)value;

- (NSString*)primitiveImagePublicUrl;
- (void)setPrimitiveImagePublicUrl:(NSString*)value;

- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveContentBlocks;
- (void)setPrimitiveContentBlocks:(NSMutableSet*)value;

- (XMMCoreDataGetById*)primitiveCoreDataGetById;
- (void)setPrimitiveCoreDataGetById:(XMMCoreDataGetById*)value;

@end
