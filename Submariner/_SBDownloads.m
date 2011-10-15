// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBDownloads.m instead.

#import "_SBDownloads.h"

@implementation SBDownloadsID
@end

@implementation _SBDownloads

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Downloads" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Downloads";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Downloads" inManagedObjectContext:moc_];
}

- (SBDownloadsID*)objectID {
	return (SBDownloadsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}








@end
