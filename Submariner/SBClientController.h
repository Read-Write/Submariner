//
//  SBClient.h
//  Sub
//
//  Created by nark on 14/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SBSubsonicParsingOperation.h"


@protocol SBClientDelegate;
@class SBServer;
@class SBSection;
@class SBHome;
@class SBLibrary;
@class SBTrack;
@class SBPlaylist;
@class SBArtist;
@class SBArtistID;
@class SBAlbum;


@interface SBClientController : NSObject  {
@private
    NSManagedObjectContext *managedObjectContext;
    NSOperationQueue *queue;
    NSMutableDictionary *parameters;
    id<SBClientDelegate> delegate;
    
    SBServer    *server;
    SBSection   *librarySection;
    SBSection   *remotePlaylistsSection;
    SBSection   *podcastsSection;
    SBSection   *radiosSection;
    SBSection   *searchsSection;
    SBHome      *home;
    SBLibrary   *library;
    
    BOOL isConnecting;
    BOOL connected;
    NSInteger numberOfElements;
}

@property (readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (readwrite, retain) id<SBClientDelegate> delegate;
@property (readwrite, retain) NSOperationQueue *queue;
@property (readwrite, retain) SBServer *server;
@property (readwrite, retain) SBSection *librarySection;
@property (readwrite, retain) SBSection *remotePlaylistsSection;
@property (readwrite, retain) SBSection *podcastsSection;
@property (readwrite, retain) SBSection *radiosSection;
@property (readwrite, retain) SBSection *searchsSection;
@property (readwrite, retain) SBLibrary *library;
@property (readwrite, retain) SBHome *home;


@property (readwrite) BOOL connected;
@property (readwrite) BOOL isConnecting;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)connectToServer:(SBServer *)aServer;
- (void)getLicense;

- (void)getIndexes;
- (void)getIndexesSince:(NSDate *)date;
- (void)getAlbumsForArtist:(SBArtist *)artist;
- (void)getAlbumListForType:(SBSubsonicRequestType)type;
- (void)getTracksForAlbumID:(NSString *)albumID;
- (void)getCoverWithID:(NSString *)coverID;

- (void)getPlaylists;
- (void)getPlaylist:(SBPlaylist *)playlist;

- (void)getPodcasts;

- (void)deletePlaylistWithID:(NSString *)playlistID;
- (void)createPlaylistWithName:(NSString *)playlistName tracks:(NSArray *)tracks;
- (void)updatePlaylistWithID:(NSString *)playlistID tracks:(NSArray *)tracks;

- (void)getChatMessagesSince:(NSDate *)date;
- (void)addChatMessage:(NSString *)message;

- (void)getNowPlaying;
- (void)getUserWithName:(NSString *)username;

- (void)search:(NSString *)query;
- (void)setRating:(NSInteger)rating forID:(NSString *)anID;

@end


