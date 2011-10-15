// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBLibrary.m instead.

#import "_SBLibrary.h"

@implementation SBLibraryID
@end

@implementation _SBLibrary

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Library" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Library";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Library" inManagedObjectContext:moc_];
}

- (SBLibraryID*)objectID {
	return (SBLibraryID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic artists;

	
- (NSMutableSet*)artistsSet {
	[self willAccessValueForKey:@"artists"];
	NSMutableSet *result = [self mutableSetValueForKey:@"artists"];
	[self didAccessValueForKey:@"artists"];
	return result;
}
	





@end
