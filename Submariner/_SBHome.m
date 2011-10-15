// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBHome.m instead.

#import "_SBHome.h"

@implementation SBHomeID
@end

@implementation _SBHome

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Home" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Home";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Home" inManagedObjectContext:moc_];
}

- (SBHomeID*)objectID {
	return (SBHomeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic albums;

	
- (NSMutableSet*)albumsSet {
	[self willAccessValueForKey:@"albums"];
	NSMutableSet *result = [self mutableSetValueForKey:@"albums"];
	[self didAccessValueForKey:@"albums"];
	return result;
}
	

@dynamic server;

	





@end
