// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataStyle.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataStyleAttributes {
	__unsafe_unretained NSString *backgroundColor;
	__unsafe_unretained NSString *chromeHeaderColor;
	__unsafe_unretained NSString *customMarker;
	__unsafe_unretained NSString *foregroundFontColor;
	__unsafe_unretained NSString *highlightFontColor;
	__unsafe_unretained NSString *icon;
} XMMCoreDataStyleAttributes;

extern const struct XMMCoreDataStyleRelationships {
	__unsafe_unretained NSString *coreDataGetById;
} XMMCoreDataStyleRelationships;

@class XMMCoreDataGetById;

@interface XMMCoreDataStyleID : NSManagedObjectID {}
@end

@interface _XMMCoreDataStyle : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataStyleID* objectID;

@property (nonatomic, strong) NSString* backgroundColor;

//- (BOOL)validateBackgroundColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* chromeHeaderColor;

//- (BOOL)validateChromeHeaderColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* customMarker;

//- (BOOL)validateCustomMarker:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* foregroundFontColor;

//- (BOOL)validateForegroundFontColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* highlightFontColor;

//- (BOOL)validateHighlightFontColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataGetById *coreDataGetById;

//- (BOOL)validateCoreDataGetById:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataStyle (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBackgroundColor;
- (void)setPrimitiveBackgroundColor:(NSString*)value;

- (NSString*)primitiveChromeHeaderColor;
- (void)setPrimitiveChromeHeaderColor:(NSString*)value;

- (NSString*)primitiveCustomMarker;
- (void)setPrimitiveCustomMarker:(NSString*)value;

- (NSString*)primitiveForegroundFontColor;
- (void)setPrimitiveForegroundFontColor:(NSString*)value;

- (NSString*)primitiveHighlightFontColor;
- (void)setPrimitiveHighlightFontColor:(NSString*)value;

- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;

- (XMMCoreDataGetById*)primitiveCoreDataGetById;
- (void)setPrimitiveCoreDataGetById:(XMMCoreDataGetById*)value;

@end
