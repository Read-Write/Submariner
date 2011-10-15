// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBMusicItem.m instead.

#import "_SBMusicItem.h"

@implementation SBMusicItemID
@end

@implementation _SBMusicItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MusicItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MusicItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MusicItem" inManagedObjectContext:moc_];
}

- (SBMusicItemID*)objectID {
	return (SBMusicItemID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isLocalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isLocal"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"isLinkedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isLinked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic isLocal;



- (BOOL)isLocalValue {
	NSNumber *result = [self isLocal];
	return [result boolValue];
}

- (void)setIsLocalValue:(BOOL)value_ {
	[self setIsLocal:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsLocalValue {
	NSNumber *result = [self primitiveIsLocal];
	return [result boolValue];
}

- (void)setPrimitiveIsLocalValue:(BOOL)value_ {
	[self setPrimitiveIsLocal:[NSNumber numberWithBool:value_]];
}





@dynamic id;






@dynamic itemName;






@dynamic path;






@dynamic isLinked;



- (BOOL)isLinkedValue {
	NSNumber *result = [self isLinked];
	return [result boolValue];
}

- (void)setIsLinkedValue:(BOOL)value_ {
	[self setIsLinked:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsLinkedValue {
	NSNumber *result = [self primitiveIsLinked];
	return [result boolValue];
}

- (void)setPrimitiveIsLinkedValue:(BOOL)value_ {
	[self setPrimitiveIsLinked:[NSNumber numberWithBool:value_]];
}









@end
