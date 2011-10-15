// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBNowPlaying.m instead.

#import "_SBNowPlaying.h"

@implementation SBNowPlayingID
@end

@implementation _SBNowPlaying

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NowPlaying" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NowPlaying";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NowPlaying" inManagedObjectContext:moc_];
}

- (SBNowPlayingID*)objectID {
	return (SBNowPlayingID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"minutesAgoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minutesAgo"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic username;






@dynamic minutesAgo;



- (int)minutesAgoValue {
	NSNumber *result = [self minutesAgo];
	return [result intValue];
}

- (void)setMinutesAgoValue:(int)value_ {
	[self setMinutesAgo:[NSNumber numberWithInt:value_]];
}

- (int)primitiveMinutesAgoValue {
	NSNumber *result = [self primitiveMinutesAgo];
	return [result intValue];
}

- (void)setPrimitiveMinutesAgoValue:(int)value_ {
	[self setPrimitiveMinutesAgo:[NSNumber numberWithInt:value_]];
}





@dynamic track;

	

@dynamic server;

	





@end
