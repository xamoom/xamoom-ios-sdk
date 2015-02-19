// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataStyle.m instead.

#import "_XMMCoreDataStyle.h"

const struct XMMCoreDataStyleAttributes XMMCoreDataStyleAttributes = {
	.backgroundColor = @"backgroundColor",
	.changeHash = @"changeHash",
	.chromeHeaderColor = @"chromeHeaderColor",
	.customMarker = @"customMarker",
	.foregroundFontColor = @"foregroundFontColor",
	.highlightFontColor = @"highlightFontColor",
	.icon = @"icon",
};

const struct XMMCoreDataStyleRelationships XMMCoreDataStyleRelationships = {
	.coreDataGetById = @"coreDataGetById",
};

@implementation XMMCoreDataStyleID
@end

@implementation _XMMCoreDataStyle

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataStyle" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataStyle";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataStyle" inManagedObjectContext:moc_];
}

- (XMMCoreDataStyleID*)objectID {
	return (XMMCoreDataStyleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic backgroundColor;

@dynamic changeHash;

@dynamic chromeHeaderColor;

@dynamic customMarker;

@dynamic foregroundFontColor;

@dynamic highlightFontColor;

@dynamic icon;

@dynamic coreDataGetById;

@end

