// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContent.m instead.

#import "_XMMCoreDataContent.h"

const struct XMMCoreDataContentAttributes XMMCoreDataContentAttributes = {
	.descriptionOfContent = @"descriptionOfContent",
	.imagePublicUrl = @"imagePublicUrl",
	.language = @"language",
	.title = @"title",
};

const struct XMMCoreDataContentRelationships XMMCoreDataContentRelationships = {
	.contentBlocks = @"contentBlocks",
	.coreDataGetById = @"coreDataGetById",
};

@implementation XMMCoreDataContentID
@end

@implementation _XMMCoreDataContent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContent" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentID*)objectID {
	return (XMMCoreDataContentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic descriptionOfContent;

@dynamic imagePublicUrl;

@dynamic language;

@dynamic title;

@dynamic contentBlocks;

- (NSMutableSet*)contentBlocksSet {
	[self willAccessValueForKey:@"contentBlocks"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"contentBlocks"];

	[self didAccessValueForKey:@"contentBlocks"];
	return result;
}

@dynamic coreDataGetById;

@end

