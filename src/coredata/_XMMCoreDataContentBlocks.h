// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlocks.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataContentBlocksAttributes {
	__unsafe_unretained NSString *artist;
	__unsafe_unretained NSString *contentBlockType;
	__unsafe_unretained NSString *contentId;
	__unsafe_unretained NSString *downloadType;
	__unsafe_unretained NSString *fileId;
	__unsafe_unretained NSString *linkType;
	__unsafe_unretained NSString *linkUrl;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *publicStatus;
	__unsafe_unretained NSString *soundcloudUrl;
	__unsafe_unretained NSString *spotMapTag;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *youtubeUrl;
} XMMCoreDataContentBlocksAttributes;

extern const struct XMMCoreDataContentBlocksRelationships {
	__unsafe_unretained NSString *content;
} XMMCoreDataContentBlocksRelationships;

@class XMMCoreDataContent;

@interface XMMCoreDataContentBlocksID : NSManagedObjectID {}
@end

@interface _XMMCoreDataContentBlocks : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataContentBlocksID* objectID;

@property (nonatomic, strong) NSString* artist;

//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* contentBlockType;

//- (BOOL)validateContentBlockType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* contentId;

//- (BOOL)validateContentId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* downloadType;

//- (BOOL)validateDownloadType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileId;

//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* linkType;

//- (BOOL)validateLinkType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* linkUrl;

//- (BOOL)validateLinkUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* publicStatus;

//- (BOOL)validatePublicStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* soundcloudUrl;

//- (BOOL)validateSoundcloudUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* spotMapTag;

//- (BOOL)validateSpotMapTag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* youtubeUrl;

//- (BOOL)validateYoutubeUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) XMMCoreDataContent *content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreDataContentBlocks (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveArtist;
- (void)setPrimitiveArtist:(NSString*)value;

- (NSString*)primitiveContentBlockType;
- (void)setPrimitiveContentBlockType:(NSString*)value;

- (NSString*)primitiveContentId;
- (void)setPrimitiveContentId:(NSString*)value;

- (NSString*)primitiveDownloadType;
- (void)setPrimitiveDownloadType:(NSString*)value;

- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;

- (NSString*)primitiveLinkType;
- (void)setPrimitiveLinkType:(NSString*)value;

- (NSString*)primitiveLinkUrl;
- (void)setPrimitiveLinkUrl:(NSString*)value;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;

- (NSString*)primitivePublicStatus;
- (void)setPrimitivePublicStatus:(NSString*)value;

- (NSString*)primitiveSoundcloudUrl;
- (void)setPrimitiveSoundcloudUrl:(NSString*)value;

- (NSString*)primitiveSpotMapTag;
- (void)setPrimitiveSpotMapTag:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveYoutubeUrl;
- (void)setPrimitiveYoutubeUrl:(NSString*)value;

- (XMMCoreDataContent*)primitiveContent;
- (void)setPrimitiveContent:(XMMCoreDataContent*)value;

@end
