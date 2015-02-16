// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocation.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataGetByLocationAttributes {
	__unsafe_unretained NSString *kind;
} XMMCoreDataGetByLocationAttributes;

extern const struct XMMCoreDataGetByLocationRelationships {
	__unsafe_unretained NSString *items;
} XMMCoreDataGetByLocationRelationships;

@class XMMCoreDataGetByLocationItem;

@interface XMMCoreDataGetByLocationID : NSManagedObjectID {}
@end

@interface _XMMCoreDataGetByLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataGetByLocationID* objectID;

@property (nonatomic, strong) NSString* kind;

//- (BOOL)validateKind:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;

@end

@interface _XMMCoreDataGetByLocation (ItemsCoreDataGeneratedAccessors)
- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(XMMCoreDataGetByLocationItem*)value_;
- (void)removeItemsObject:(XMMCoreDataGetByLocationItem*)value_;

@end

@interface _XMMCoreDataGetByLocation (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveKind;
- (void)setPrimitiveKind:(NSString*)value;

- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;

@end
