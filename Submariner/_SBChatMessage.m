// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBChatMessage.m instead.

#import "_SBChatMessage.h"

@implementation SBChatMessageID
@end

@implementation _SBChatMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ChatMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ChatMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ChatMessage" inManagedObjectContext:moc_];
}

- (SBChatMessageID*)objectID {
	return (SBChatMessageID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"unreadValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"unread"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic unread;



- (BOOL)unreadValue {
	NSNumber *result = [self unread];
	return [result boolValue];
}

- (void)setUnreadValue:(BOOL)value_ {
	[self setUnread:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUnreadValue {
	NSNumber *result = [self primitiveUnread];
	return [result boolValue];
}

- (void)setPrimitiveUnreadValue:(BOOL)value_ {
	[self setPrimitiveUnread:[NSNumber numberWithBool:value_]];
}





@dynamic username;






@dynamic message;






@dynamic date;






@dynamic server;

	





@end
