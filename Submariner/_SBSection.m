// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBSection.m instead.

#import "_SBSection.h"

@implementation SBSectionID
@end

@implementation _SBSection

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Section";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Section" inManagedObjectContext:moc_];
}

- (SBSectionID*)objectID {
	return (SBSectionID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic resources;

	
- (NSMutableSet*)resourcesSet {
	[self willAccessValueForKey:@"resources"];
	NSMutableSet *result = [self mutableSetValueForKey:@"resources"];
	[self didAccessValueForKey:@"resources"];
	return result;
}
	





@end
