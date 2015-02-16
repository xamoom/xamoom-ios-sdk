// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType5.m instead.

#import "_XMMCoreDataContentBlockType5.h"

const struct XMMCoreDataContentBlockType5Attributes XMMCoreDataContentBlockType5Attributes = {
	.artist = @"artist",
	.fileId = @"fileId",
};

const struct XMMCoreDataContentBlockType5Relationships XMMCoreDataContentBlockType5Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType5ID
@end

@implementation _XMMCoreDataContentBlockType5

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType5" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType5";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType5" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType5ID*)objectID {
	return (XMMCoreDataContentBlockType5ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic artist;

@dynamic fileId;

@dynamic contentBlock;

@end

