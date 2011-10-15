// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBTracklist.m instead.

#import "_SBTracklist.h"

@implementation SBTracklistID
@end

@implementation _SBTracklist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tracklist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tracklist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tracklist" inManagedObjectContext:moc_];
}

- (SBTracklistID*)objectID {
	return (SBTracklistID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}








@end
