// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType8.m instead.

#import "_XMMCoreDataContentBlockType8.h"

const struct XMMCoreDataContentBlockType8Relationships XMMCoreDataContentBlockType8Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType8ID
@end

@implementation _XMMCoreDataContentBlockType8

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType8" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType8";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType8" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType8ID*)objectID {
	return (XMMCoreDataContentBlockType8ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlock;

@end

