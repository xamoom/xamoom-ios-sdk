// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType7.m instead.

#import "_XMMCoreDataContentBlockType7.h"

const struct XMMCoreDataContentBlockType7Attributes XMMCoreDataContentBlockType7Attributes = {
	.soundcloudUrl = @"soundcloudUrl",
};

const struct XMMCoreDataContentBlockType7Relationships XMMCoreDataContentBlockType7Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType7ID
@end

@implementation _XMMCoreDataContentBlockType7

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType7" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType7";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType7" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType7ID*)objectID {
	return (XMMCoreDataContentBlockType7ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic soundcloudUrl;

@dynamic contentBlock;

@end

