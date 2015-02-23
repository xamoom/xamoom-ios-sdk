// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType3.m instead.

#import "_XMMCoreDataContentBlockType3.h"

const struct XMMCoreDataContentBlockType3Relationships XMMCoreDataContentBlockType3Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType3ID
@end

@implementation _XMMCoreDataContentBlockType3

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType3" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType3";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType3" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType3ID*)objectID {
	return (XMMCoreDataContentBlockType3ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlock;

@end

