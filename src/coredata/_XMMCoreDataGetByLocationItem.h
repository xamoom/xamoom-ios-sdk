// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocationItem.h instead.

#import <CoreData/CoreData.h>
#import "XMMCoreData.h"

extern const struct XMMCoreDataGetByLocationItemAttributes {
	__unsafe_unretained NSString *backgroundColor;
	__unsafe_unretained NSString *contentId;
	__unsafe_unretained NSString *descriptionOfContent;
	__unsafe_unretained NSString *foregroundFontColor;
	__unsafe_unretained NSString *highlightFontColor;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *imagePublicUrl;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lon;
	__unsafe_unretained NSString *title;
} XMMCoreDataGetByLocationItemAttributes;

extern const struct XMMCoreDataGetByLocationItemRelationships {
	__unsafe_unretained NSString *coreDataGetByLocation;
} XMMCoreDataGetByLocationItemRelationships;

@class XMMCoreDataGetByLocation;

@interface XMMCoreDataGetByLocationItemID : XMMCoreDataID {}
@end

@interface _XMMCoreDataGetByLocationItem : XMMCoreData {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataGetByLocationItemID* objectID;

@property (nonatomic, strong) NSString* backgroundColor;

//- (BOOL)validateBackgroundColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* contentId;

//- (BOOL)validateContentId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* descriptionOfContent;

//- (BOOL)validateDescriptionOfContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* foregroundFontColor;

//- (BOOL)validateForegroundFontColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imagePublicUrl;

//- (BOOL)validateImagePublicUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* language;

//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lat;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lon;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataGetByLocation *coreDataGetByLocation;

//- (BOOL)validateCoreDataGetByLocation:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataGetByLocationItem (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBackgroundColor;
- (void)setPrimitiveBackgroundColor:(NSString*)value;

- (NSString*)primitiveContentId;
- (void)setPrimitiveContentId:(NSString*)value;

- (NSString*)primitiveDescriptionOfContent;
- (void)setPrimitiveDescriptionOfContent:(NSString*)value;

- (NSString*)primitiveForegroundFontColor;
- (void)setPrimitiveForegroundFontColor:(NSString*)value;

- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;

- (NSString*)primitiveImagePublicUrl;
- (void)setPrimitiveImagePublicUrl:(NSString*)value;

- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;

- (NSString*)primitiveLat;
- (void)setPrimitiveLat:(NSString*)value;

- (NSString*)primitiveLon;
- (void)setPrimitiveLon:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (XMMCoreDataGetByLocation*)primitiveCoreDataGetByLocation;
- (void)setPrimitiveCoreDataGetByLocation:(XMMCoreDataGetByLocation*)value;

@end
