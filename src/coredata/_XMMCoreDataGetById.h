// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetById.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreData.h"

extern const struct XMMCoreDataGetByIdRelationships {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *menu;
	__unsafe_unretained NSString *style;
} XMMCoreDataGetByIdRelationships;

@class NSManagedObject;
@class XMMCoreDataMenuItem;
@class XMMCoreDataStyle;

@interface XMMCoreDataGetByIdID : XMMCoreDataID {}
@end

@interface _XMMCoreDataGetById : XMMCoreData {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataGetByIdID* objectID;

@property (nonatomic, strong) NSManagedObject *content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *menu;

- (NSMutableSet*)menuSet;

@property (nonatomic, strong) XMMCoreDataStyle *style;

//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataGetById (MenuCoreDataGeneratedAccessors)
- (void)addMenu:(NSSet*)value_;
- (void)removeMenu:(NSSet*)value_;
- (void)addMenuObject:(XMMCoreDataMenuItem*)value_;
- (void)removeMenuObject:(XMMCoreDataMenuItem*)value_;

@end

@interface _XMMCoreDataGetById (CoreDataGeneratedPrimitiveAccessors)

- (NSManagedObject*)primitiveContent;
- (void)setPrimitiveContent:(NSManagedObject*)value;

- (NSMutableSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet*)value;

- (XMMCoreDataStyle*)primitiveStyle;
- (void)setPrimitiveStyle:(XMMCoreDataStyle*)value;

@end
