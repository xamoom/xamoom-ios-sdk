// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlocks.m instead.

#import "_XMMCoreDataContentBlocks.h"

const struct XMMCoreDataContentBlocksAttributes XMMCoreDataContentBlocksAttributes = {
	.artist = @"artist",
	.contentBlockType = @"contentBlockType",
	.contentId = @"contentId",
	.downloadType = @"downloadType",
	.fileId = @"fileId",
	.linkType = @"linkType",
	.linkUrl = @"linkUrl",
	.order = @"order",
	.publicStatus = @"publicStatus",
	.soundcloudUrl = @"soundcloudUrl",
	.spotMapTag = @"spotMapTag",
	.text = @"text",
	.title = @"title",
	.youtubeUrl = @"youtubeUrl",
};

const struct XMMCoreDataContentBlocksRelationships XMMCoreDataContentBlocksRelationships = {
	.content = @"content",
};

@implementation XMMCoreDataContentBlocksID
@end

@implementation _XMMCoreDataContentBlocks

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlocks" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlocks";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlocks" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlocksID*)objectID {
	return (XMMCoreDataContentBlocksID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic artist;

@dynamic contentBlockType;

@dynamic contentId;

@dynamic downloadType;

@dynamic fileId;

@dynamic linkType;

@dynamic linkUrl;

@dynamic order;

- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:[NSNumber numberWithShort:value_]];
}

@dynamic publicStatus;

@dynamic soundcloudUrl;

@dynamic spotMapTag;

@dynamic text;

@dynamic title;

@dynamic youtubeUrl;

@dynamic content;

@end

