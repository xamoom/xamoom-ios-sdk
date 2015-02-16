// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetByLocation.m instead.

#import "_XMMCoreDataGetByLocation.h"

const struct XMMCoreDataGetByLocationAttributes XMMCoreDataGetByLocationAttributes = {
	.kind = @"kind",
};

const struct XMMCoreDataGetByLocationRelationships XMMCoreDataGetByLocationRelationships = {
	.items = @"items",
};

@implementation XMMCoreDataGetByLocationID
@end

@implementation _XMMCoreDataGetByLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataGetByLocation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataGetByLocation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataGetByLocation" inManagedObjectContext:moc_];
}

- (XMMCoreDataGetByLocationID*)objectID {
	return (XMMCoreDataGetByLocationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic kind;

@dynamic items;

- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];

	[self didAccessValueForKey:@"items"];
	return result;
}

@end

