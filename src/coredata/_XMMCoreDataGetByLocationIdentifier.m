// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocationIdentifier.m instead.

#import "_XMMCoreDataGetByLocationIdentifier.h"

const struct XMMCoreDataGetByLocationIdentifierAttributes XMMCoreDataGetByLocationIdentifierAttributes = {
	.hasContent = @"hasContent",
	.hasSpot = @"hasSpot",
};

const struct XMMCoreDataGetByLocationIdentifierRelationships XMMCoreDataGetByLocationIdentifierRelationships = {
	.content = @"content",
	.menu = @"menu",
	.style = @"style",
};

@implementation XMMCoreDataGetByLocationIdentifierID
@end

@implementation _XMMCoreDataGetByLocationIdentifier

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataGetByLocationIdentifier" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataGetByLocationIdentifier";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataGetByLocationIdentifier" inManagedObjectContext:moc_];
}

- (XMMCoreDataGetByLocationIdentifierID*)objectID {
	return (XMMCoreDataGetByLocationIdentifierID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic hasContent;

@dynamic hasSpot;

@dynamic content;

@dynamic menu;

- (NSMutableSet*)menuSet {
	[self willAccessValueForKey:@"menu"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"menu"];

	[self didAccessValueForKey:@"menu"];
	return result;
}

@dynamic style;

@end

