// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlocks.m instead.

#import "_XMMCoreDataContentBlocks.h"

const struct XMMCoreDataContentBlocksAttributes XMMCoreDataContentBlocksAttributes = {
	.contentBlockType = @"contentBlockType",
	.publicStatus = @"publicStatus",
	.title = @"title",
};

const struct XMMCoreDataContentBlocksRelationships XMMCoreDataContentBlocksRelationships = {
	.content = @"content",
	.contentBlockType0 = @"contentBlockType0",
	.contentBlockType1 = @"contentBlockType1",
	.contentBlockType2 = @"contentBlockType2",
	.contentBlockType3 = @"contentBlockType3",
	.contentBlockType4 = @"contentBlockType4",
	.contentBlockType5 = @"contentBlockType5",
	.contentBlockType6 = @"contentBlockType6",
};

@implementation XMMCoreDataContentBlocksID
@end

@implementation _XMMCoreDataContentBlocks

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlocks" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlocks";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlocks" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlocksID*)objectID {
	return (XMMCoreDataContentBlocksID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlockType;

@dynamic publicStatus;

@dynamic title;

@dynamic content;

@dynamic contentBlockType0;

@dynamic contentBlockType1;

@dynamic contentBlockType2;

@dynamic contentBlockType3;

@dynamic contentBlockType4;

@dynamic contentBlockType5;

@dynamic contentBlockType6;

@end

