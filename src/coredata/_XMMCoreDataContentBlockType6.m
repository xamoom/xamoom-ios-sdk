// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType6.m instead.

#import "_XMMCoreDataContentBlockType6.h"

const struct XMMCoreDataContentBlockType6Relationships XMMCoreDataContentBlockType6Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType6ID
@end

@implementation _XMMCoreDataContentBlockType6

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType6" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType6";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType6" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType6ID*)objectID {
	return (XMMCoreDataContentBlockType6ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlock;

@end

