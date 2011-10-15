// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBArtist.m instead.

#import "_SBArtist.h"

@implementation SBArtistID
@end

@implementation _SBArtist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Artist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:moc_];
}

- (SBArtistID*)objectID {
	return (SBArtistID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic library;

	

@dynamic albums;

	
- (NSMutableSet*)albumsSet {
	[self willAccessValueForKey:@"albums"];
	NSMutableSet *result = [self mutableSetValueForKey:@"albums"];
	[self didAccessValueForKey:@"albums"];
	return result;
}
	





@end
