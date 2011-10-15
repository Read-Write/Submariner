// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBEpisode.m instead.

#import "_SBEpisode.h"

@implementation SBEpisodeID
@end

@implementation _SBEpisode

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Episode" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Episode";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Episode" inManagedObjectContext:moc_];
}

- (SBEpisodeID*)objectID {
	return (SBEpisodeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic publishDate;






@dynamic episodeDescription;






@dynamic streamID;






@dynamic episodeStatus;






@dynamic track;

	

@dynamic podcast;

	





@end
