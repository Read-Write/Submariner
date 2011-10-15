// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBResource.m instead.

#import "_SBResource.h"

@implementation SBResourceID
@end

@implementation _SBResource

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Resource" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Resource";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Resource" inManagedObjectContext:moc_];
}

- (SBResourceID*)objectID {
	return (SBResourceID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic index;



- (int)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic resourceName;






@dynamic section;

	





@end
