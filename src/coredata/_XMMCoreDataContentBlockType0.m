// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType0.m instead.

#import "_XMMCoreDataContentBlockType0.h"

const struct XMMCoreDataContentBlockType0Attributes XMMCoreDataContentBlockType0Attributes = {
	.text = @"text",
};

const struct XMMCoreDataContentBlockType0Relationships XMMCoreDataContentBlockType0Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType0ID
@end

@implementation _XMMCoreDataContentBlockType0

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType0" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType0";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType0" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType0ID*)objectID {
	return (XMMCoreDataContentBlockType0ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic text;

@dynamic contentBlock;

@end

