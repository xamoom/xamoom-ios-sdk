// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType9.m instead.

#import "_XMMCoreDataContentBlockType9.h"

const struct XMMCoreDataContentBlockType9Relationships XMMCoreDataContentBlockType9Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType9ID
@end

@implementation _XMMCoreDataContentBlockType9

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType9" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType9";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType9" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType9ID*)objectID {
	return (XMMCoreDataContentBlockType9ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlock;

@end

