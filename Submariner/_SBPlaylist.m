// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBPlaylist.m instead.

#import "_SBPlaylist.h"

@implementation SBPlaylistID
@end

@implementation _SBPlaylist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Playlist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Playlist" inManagedObjectContext:moc_];
}

- (SBPlaylistID*)objectID {
	return (SBPlaylistID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic server;

	

@dynamic tracks;

	
- (NSMutableSet*)tracksSet {
	[self willAccessValueForKey:@"tracks"];
	NSMutableSet *result = [self mutableSetValueForKey:@"tracks"];
	[self didAccessValueForKey:@"tracks"];
	return result;
}
	





@end
