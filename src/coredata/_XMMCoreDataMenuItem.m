// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataMenuItem.m instead.

#import "_XMMCoreDataMenuItem.h"

const struct XMMCoreDataMenuItemAttributes XMMCoreDataMenuItemAttributes = {
	.contentId = @"contentId",
	.itemLabel = @"itemLabel",
};

const struct XMMCoreDataMenuItemRelationships XMMCoreDataMenuItemRelationships = {
	.coreDataGetById = @"coreDataGetById",
};

@implementation XMMCoreDataMenuItemID
@end

@implementation _XMMCoreDataMenuItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataMenuItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataMenuItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataMenuItem" inManagedObjectContext:moc_];
}

- (XMMCoreDataMenuItemID*)objectID {
	return (XMMCoreDataMenuItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentId;

@dynamic itemLabel;

@dynamic coreDataGetById;

@end

