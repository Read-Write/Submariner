// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBChatMessage.h instead.

#import <CoreData/CoreData.h>


@class SBServer;






@interface SBChatMessageID : NSManagedObjectID {}
@end

@interface _SBChatMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SBChatMessageID*)objectID;



@property (nonatomic, retain) NSNumber *unread;

@property BOOL unreadValue;
- (BOOL)unreadValue;
- (void)setUnreadValue:(BOOL)value_;

//- (BOOL)validateUnread:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) SBServer* server;
//- (BOOL)validateServer:(id*)value_ error:(NSError**)error_;




@end

@interface _SBChatMessage (CoreDataGeneratedAccessors)

@end

@interface _SBChatMessage (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveUnread;
- (void)setPrimitiveUnread:(NSNumber*)value;

- (BOOL)primitiveUnreadValue;
- (void)setPrimitiveUnreadValue:(BOOL)value_;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;




- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;





- (SBServer*)primitiveServer;
- (void)setPrimitiveServer:(SBServer*)value;


@end
