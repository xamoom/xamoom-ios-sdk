// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreDataContentBlockType2.m instead.

#import "_XMMCoreDataContentBlockType2.h"

const struct XMMCoreDataContentBlockType2Relationships XMMCoreDataContentBlockType2Relationships = {
	.contentBlock = @"contentBlock",
};

@implementation XMMCoreDataContentBlockType2ID
@end

@implementation _XMMCoreDataContentBlockType2

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreDataContentBlockType2" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreDataContentBlockType2";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreDataContentBlockType2" inManagedObjectContext:moc_];
}

- (XMMCoreDataContentBlockType2ID*)objectID {
	return (XMMCoreDataContentBlockType2ID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contentBlock;

@end

