// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocationIdentifier.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreData.h"

extern const struct XMMCoreDataGetByLocationIdentifierAttributes {
	__unsafe_unretained NSString *hasContent;
	__unsafe_unretained NSString *hasSpot;
} XMMCoreDataGetByLocationIdentifierAttributes;

extern const struct XMMCoreDataGetByLocationIdentifierRelationships {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *menu;
	__unsafe_unretained NSString *style;
} XMMCoreDataGetByLocationIdentifierRelationships;

@class XMMCoreDataContent;
@class XMMCoreDataMenuItem;
@class XMMCoreDataStyle;

@interface XMMCoreDataGetByLocationIdentifierID : XMMCoreDataID {}
@end

@interface _XMMCoreDataGetByLocationIdentifier : XMMCoreData {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataGetByLocationIdentifierID* objectID;

@property (nonatomic, strong) NSString* hasContent;

//- (BOOL)validateHasContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* hasSpot;

//- (BOOL)validateHasSpot:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContent *content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *menu;

- (NSMutableSet*)menuSet;

@property (nonatomic, strong) XMMCoreDataStyle *style;

//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataGetByLocationIdentifier (MenuCoreDataGeneratedAccessors)
- (void)addMenu:(NSSet*)value_;
- (void)removeMenu:(NSSet*)value_;
- (void)addMenuObject:(XMMCoreDataMenuItem*)value_;
- (void)removeMenuObject:(XMMCoreDataMenuItem*)value_;

@end

@interface _XMMCoreDataGetByLocationIdentifier (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveHasContent;
- (void)setPrimitiveHasContent:(NSString*)value;

- (NSString*)primitiveHasSpot;
- (void)setPrimitiveHasSpot:(NSString*)value;

- (XMMCoreDataContent*)primitiveContent;
- (void)setPrimitiveContent:(XMMCoreDataContent*)value;

- (NSMutableSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet*)value;

- (XMMCoreDataStyle*)primitiveStyle;
- (void)setPrimitiveStyle:(XMMCoreDataStyle*)value;

@end
