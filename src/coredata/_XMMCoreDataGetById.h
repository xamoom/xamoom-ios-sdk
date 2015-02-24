// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetById.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataGetByIdAttributes {
	__unsafe_unretained NSString *checksum;
	__unsafe_unretained NSString *hasContent;
	__unsafe_unretained NSString *hasSpot;
	__unsafe_unretained NSString *systemId;
	__unsafe_unretained NSString *systemName;
	__unsafe_unretained NSString *systemUrl;
} XMMCoreDataGetByIdAttributes;

extern const struct XMMCoreDataGetByIdRelationships {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *menu;
	__unsafe_unretained NSString *style;
} XMMCoreDataGetByIdRelationships;

@class XMMCoreDataContent;
@class XMMCoreDataMenuItem;
@class XMMCoreDataStyle;

@interface XMMCoreDataGetByIdID : NSManagedObjectID {}
@end

@interface _XMMCoreDataGetById : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataGetByIdID* objectID;

@property (nonatomic, strong) NSString* checksum;

//- (BOOL)validateChecksum:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* hasContent;

//- (BOOL)validateHasContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* hasSpot;

//- (BOOL)validateHasSpot:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemId;

//- (BOOL)validateSystemId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemName;

//- (BOOL)validateSystemName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemUrl;

//- (BOOL)validateSystemUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContent *content;

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

- (NSString*)primitiveChecksum;
- (void)setPrimitiveChecksum:(NSString*)value;

- (NSString*)primitiveHasContent;
- (void)setPrimitiveHasContent:(NSString*)value;

- (NSString*)primitiveHasSpot;
- (void)setPrimitiveHasSpot:(NSString*)value;

- (NSString*)primitiveSystemId;
- (void)setPrimitiveSystemId:(NSString*)value;

- (NSString*)primitiveSystemName;
- (void)setPrimitiveSystemName:(NSString*)value;

- (NSString*)primitiveSystemUrl;
- (void)setPrimitiveSystemUrl:(NSString*)value;

- (XMMCoreDataContent*)primitiveContent;
- (void)setPrimitiveContent:(XMMCoreDataContent*)value;

- (NSMutableSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet*)value;

- (XMMCoreDataStyle*)primitiveStyle;
- (void)setPrimitiveStyle:(XMMCoreDataStyle*)value;

@end
