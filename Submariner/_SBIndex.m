// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBIndex.m instead.

#import "_SBIndex.h"

@implementation SBIndexID
@end

@implementation _SBIndex

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Index" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Index";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Index" inManagedObjectContext:moc_];
}

- (SBIndexID*)objectID {
	return (SBIndexID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic server;

	





@end
