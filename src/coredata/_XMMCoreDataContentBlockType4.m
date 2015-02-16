// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType4.m instead.

#import "_XMMCoreDataContentBlockType4.h"

const struct XMMCoreDataContentBlockType4Attributes XMMCoreDataContentBlockType4Attributes = {
	.linkType = @"linkType",
	.linkUrl = @"linkUrl",
	.text = @"text",
};

const struct XMMCoreDataContentBlockType4Relationships XMMCoreDataContentBlockType4Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType4ID
@end

@implementation _XMMCoreDataContentBlockType4

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType4" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType4";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType4" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType4ID*)objectID {
	return (XMMCoreDataContentBlockType4ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic linkType;

@dynamic linkUrl;

@dynamic text;

@dynamic contentBlock;

@end

