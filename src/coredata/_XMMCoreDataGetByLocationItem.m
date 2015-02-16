// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocationItem.m instead.

#import "_XMMCoreDataGetByLocationItem.h"

const struct XMMCoreDataGetByLocationItemAttributes XMMCoreDataGetByLocationItemAttributes = {
	.backgroundColor = @"backgroundColor",
	.contentId = @"contentId",
	.descriptionOfContent = @"descriptionOfContent",
	.foregroundFontColor = @"foregroundFontColor",
	.highlightFontColor = @"highlightFontColor",
	.icon = @"icon",
	.imagePublicUrl = @"imagePublicUrl",
	.language = @"language",
	.lat = @"lat",
	.lon = @"lon",
	.title = @"title",
};

const struct XMMCoreDataGetByLocationItemRelationships XMMCoreDataGetByLocationItemRelationships = {
	.coreDataGetByLocation = @"coreDataGetByLocation",
};

@implementation XMMCoreDataGetByLocationItemID
@end

@implementation _XMMCoreDataGetByLocationItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataGetByLocationItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataGetByLocationItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataGetByLocationItem" inManagedObjectContext:moc_];
}

- (XMMCoreDataGetByLocationItemID*)objectID {
	return (XMMCoreDataGetByLocationItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic backgroundColor;

@dynamic contentId;

@dynamic descriptionOfContent;

@dynamic foregroundFontColor;

@dynamic icon;

@dynamic imagePublicUrl;

@dynamic language;

@dynamic lat;

@dynamic lon;

@dynamic title;

@dynamic coreDataGetByLocation;

@end

