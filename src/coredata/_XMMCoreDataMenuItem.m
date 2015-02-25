// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataMenuItem.m instead.

#import "_XMMCoreDataMenuItem.h"

const struct XMMCoreDataMenuItemAttributes XMMCoreDataMenuItemAttributes = {
	.contentId = @"contentId",
	.itemLabel = @"itemLabel",
	.order = @"order",
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

	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic contentId;

@dynamic itemLabel;

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

@dynamic coreDataGetById;

@end

