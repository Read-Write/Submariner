#import "_SBServer.h"
#import "SBSubsonicParsingOperation.h"

@class SBClientController;
@class SBArtist;
@class SBAlbum;

@interface SBServer : _SBServer {
    SBClientController *clientController;
    NSSet *resources;
    
    NSInteger selectedTabIndex;
}

@property (assign) NSSet *resources;
@property (readonly, retain) SBClientController *clientController;

@property (readwrite) NSInteger selectedTabIndex;


// accessors
- (BOOL)hasUnread;
- (NSInteger)numberOfUnread;
- (NSImage *)licenseImage;


// login management
- (void)connect;
- (void)getServerLicense;


// retrieve server data
- (void)getServerIndexes;
- (void)getAlbumsForArtist:(SBArtist *)artist;
- (void)getAlbumListForType:(SBSubsonicRequestType)type;
- (void)getTracksForAlbum:(SBAlbum *)album;

// playlist management
- (void)getServerPlaylists;
- (void)getPlaylistTracks:(SBPlaylist *)playlist;
- (void)createPlaylistWithName:(NSString *)playlistName tracks:(NSArray *)tracks;
- (void)updatePlaylistWithID:(NSString *)playlistID tracks:(NSArray *)tracks;
- (void)deletePlaylistWithID:(NSString *)playlistID;

// podcasts
- (void)getServerPodcasts;

// chat
- (void)addChatMessage:(NSString *)message;
- (void)getChatMessagesSince:(NSDate *)date;

// now playing
- (void)getNowPlaying;

// search
- (void)searchWithQuery:(NSString *)query;

// rating
- (void)setRating:(NSInteger)rating forID:(NSString *)anID;

@end
