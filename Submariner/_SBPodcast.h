// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBPodcast.h instead.

#import <CoreData/CoreData.h>
#import "SBMusicItem.h"

@class SBEpisode;
@class SBServer;






@interface SBPodcastID : NSManagedObjectID {}
@end

@interface _SBPodcast : SBMusicItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SBPodcastID*)objectID;



@property (nonatomic, retain) NSString *channelDescription;

//- (BOOL)validateChannelDescription:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *channelURL;

//- (BOOL)validateChannelURL:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *channelStatus;

//- (BOOL)validateChannelStatus:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *errorMessage;

//- (BOOL)validateErrorMessage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* episodes;
- (NSMutableSet*)episodesSet;



@property (nonatomic, retain) SBServer* server;
//- (BOOL)validateServer:(id*)value_ error:(NSError**)error_;




@end

@interface _SBPodcast (CoreDataGeneratedAccessors)

- (void)addEpisodes:(NSSet*)value_;
- (void)removeEpisodes:(NSSet*)value_;
- (void)addEpisodesObject:(SBEpisode*)value_;
- (void)removeEpisodesObject:(SBEpisode*)value_;

@end

@interface _SBPodcast (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveChannelDescription;
- (void)setPrimitiveChannelDescription:(NSString*)value;




- (NSString*)primitiveChannelURL;
- (void)setPrimitiveChannelURL:(NSString*)value;




- (NSString*)primitiveChannelStatus;
- (void)setPrimitiveChannelStatus:(NSString*)value;




- (NSString*)primitiveErrorMessage;
- (void)setPrimitiveErrorMessage:(NSString*)value;





- (NSMutableSet*)primitiveEpisodes;
- (void)setPrimitiveEpisodes:(NSMutableSet*)value;



- (SBServer*)primitiveServer;
- (void)setPrimitiveServer:(SBServer*)value;


@end
