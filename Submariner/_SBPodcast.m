// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBPodcast.m instead.

#import "_SBPodcast.h"

@implementation SBPodcastID
@end

@implementation _SBPodcast

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Podcast" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Podcast";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Podcast" inManagedObjectContext:moc_];
}

- (SBPodcastID*)objectID {
	return (SBPodcastID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic channelDescription;






@dynamic channelURL;






@dynamic channelStatus;






@dynamic errorMessage;






@dynamic episodes;

	
- (NSMutableSet*)episodesSet {
	[self willAccessValueForKey:@"episodes"];
	NSMutableSet *result = [self mutableSetValueForKey:@"episodes"];
	[self didAccessValueForKey:@"episodes"];
	return result;
}
	

@dynamic server;

	





@end
