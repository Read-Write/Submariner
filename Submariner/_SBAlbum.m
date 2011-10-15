// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBAlbum.m instead.

#import "_SBAlbum.h"

@implementation SBAlbumID
@end

@implementation _SBAlbum

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Album";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Album" inManagedObjectContext:moc_];
}

- (SBAlbumID*)objectID {
	return (SBAlbumID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic tracks;

	
- (NSMutableSet*)tracksSet {
	[self willAccessValueForKey:@"tracks"];
	NSMutableSet *result = [self mutableSetValueForKey:@"tracks"];
	[self didAccessValueForKey:@"tracks"];
	return result;
}
	

@dynamic home;

	

@dynamic cover;

	

@dynamic artist;

	





@end
