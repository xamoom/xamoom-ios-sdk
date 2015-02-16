// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType1.m instead.

#import "_XMMCoreDataContentBlockType1.h"

const struct XMMCoreDataContentBlockType1Attributes XMMCoreDataContentBlockType1Attributes = {
	.artist = @"artist",
	.fileId = @"fileId",
};

const struct XMMCoreDataContentBlockType1Relationships XMMCoreDataContentBlockType1Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType1ID
@end

@implementation _XMMCoreDataContentBlockType1

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType1" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType1";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType1" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType1ID*)objectID {
	return (XMMCoreDataContentBlockType1ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic artist;

@dynamic fileId;

@dynamic contentBlock;

@end

