// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataGetById.m instead.

#import "_XMMCoreDataGetById.h"

const struct XMMCoreDataGetByIdRelationships XMMCoreDataGetByIdRelationships = {
	.content = @"content",
	.menu = @"menu",
	.style = @"style",
};

@implementation XMMCoreDataGetByIdID
@end

@implementation _XMMCoreDataGetById

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataGetById" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataGetById";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataGetById" inManagedObjectContext:moc_];
}

- (XMMCoreDataGetByIdID*)objectID {
	return (XMMCoreDataGetByIdID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

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

