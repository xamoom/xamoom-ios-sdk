// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataMenuItem.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataMenuItemAttributes {
	__unsafe_unretained NSString *contentId;
	__unsafe_unretained NSString *itemLabel;
} XMMCoreDataMenuItemAttributes;

extern const struct XMMCoreDataMenuItemRelationships {
	__unsafe_unretained NSString *coreDataGetById;
} XMMCoreDataMenuItemRelationships;

@class XMMCoreDataGetById;

@interface XMMCoreDataMenuItemID : NSManagedObjectID {}
@end

@interface _XMMCoreDataMenuItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataMenuItemID* objectID;

@property (nonatomic, strong) NSString* contentId;

//- (BOOL)validateContentId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* itemLabel;

//- (BOOL)validateItemLabel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataGetById *coreDataGetById;

//- (BOOL)validateCoreDataGetById:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataMenuItem (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContentId;
- (void)setPrimitiveContentId:(NSString*)value;

- (NSString*)primitiveItemLabel;
- (void)setPrimitiveItemLabel:(NSString*)value;

- (XMMCoreDataGetById*)primitiveCoreDataGetById;
- (void)setPrimitiveCoreDataGetById:(XMMCoreDataGetById*)value;

@end
