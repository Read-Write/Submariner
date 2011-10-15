//
//  SBSubsonicMessage.h
//  Sub
//
//  Created by nark on 23/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBOperation.h"


extern NSString *SBSubsonicConnectionFailedNotification;
extern NSString *SBSubsonicConnectionSucceededNotification;
extern NSString *SBSubsonicIndexesUpdatedNotification;
extern NSString *SBSubsonicAlbumsUpdatedNotification;
extern NSString *SBSubsonicTracksUpdatedNotification;
extern NSString *SBSubsonicCoversUpdatedNotification;
extern NSString *SBSubsonicPlaylistsUpdatedNotification;
extern NSString *SBSubsonicPlaylistUpdatedNotification;
extern NSString *SBSubsonicChatMessageAddedNotification;
extern NSString *SBSubsonicNowPlayingUpdatedNotification;
extern NSString *SBSubsonicUserInfoUpdatedNotification;
extern NSString *SBSubsonicPlaylistsCreatedNotification;
extern NSString *SBSubsonicCacheDownloadStartedNotification;
extern NSString *SBSubsonicSearchResultUpdatedNotification;
extern NSString *SBSubsonicPodcastsUpdatedNotification;


enum SBSubsonicRequestType {
    SBSubsonicRequestUnknow                 = -1,
    SBSubsonicRequestPing                   = 0,
    SBSubsonicRequestGetLicence             = 1,
    SBSubsonicRequestGetMusicFolders        = 2,
    SBSubsonicRequestGetIndexes             = 3,
    SBSubsonicRequestGetMusicDirectory      = 4,
    SBSubsonicRequestGetAlbumDirectory      = 5, 
    SBSubsonicRequestGetTrackDirectory      = 6, 
    SBSubsonicRequestGetCoverArt            = 7,
    SBSubsonicRequestStream                 = 8,
    SBSubsonicRequestGetPlaylists           = 9,
    SBSubsonicRequestGetAlbumListRandom     = 10,
    SBSubsonicRequestGetAlbumListNewest     = 11,
    SBSubsonicRequestGetAlbumListHighest    = 12,
    SBSubsonicRequestGetAlbumListFrequent   = 13,
    SBSubsonicRequestGetAlbumListRecent     = 14,
    SBSubsonicRequestGetPlaylist            = 15,
    SBSubsonicRequestDeletePlaylist         = 16,
    SBSubsonicRequestCreatePlaylist         = 17,
    SBSubsonicRequestGetChatMessages        = 18,
    SBSubsonicRequestAddChatMessage         = 19,
    SBSubsonicRequestGetNowPlaying          = 20,
    SBSubsonicRequestGetUser                = 21,
    SBSubsonicRequestSearch                 = 22,
    SBSubsonicRequestSetRating              = 23,
    SBSubsonicRequestGetLicense             = 24,
    SBSubsonicRequestGetPodcasts            = 25
} typedef SBSubsonicRequestType;



@class SBClientController;
@class SBServer;
@class SBServerID;
@class SBArtist;
@class SBAlbum;
@class SBPlaylist;
@class SBSearchResult;
@class SBPodcast;


@interface SBSubsonicParsingOperation : SBOperation <NSXMLParserDelegate> {
@protected
    // attribute
    NSNotificationCenter *nc;
    SBClientController *clientController;
    SBSubsonicRequestType requestType;
    SBServerID *serverID;
    SBServer *server;
    NSData *xmlData;
    
    // parsing support
    SBArtist *currentArtist;
    SBAlbum *currentAlbum;
    SBPlaylist *currentPlaylist;
    NSString *currentCoverID;
    SBSearchResult *currentSearch;
    SBPodcast *currentPodcast;
    
    // index counters
    NSInteger numberOfChildrens;
    NSInteger playlistIndex;
    
    BOOL hasUnread;
}

@property (readwrite, retain) SBArtist *currentArtist;
@property (readwrite, retain) SBAlbum  *currentAlbum;
@property (readwrite, retain) SBPlaylist *currentPlaylist;
@property (readwrite, retain) SBPodcast *currentPodcast;
@property (readwrite, retain) NSString *currentCoverID;
@property (readwrite, retain) SBSearchResult *currentSearch;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)mainContext 
                            client:(SBClientController *)client
                       requestType:(SBSubsonicRequestType)type
                            server:(SBServerID *)objectID
                               xml:(NSData *)xml;

@end
