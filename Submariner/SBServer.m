#import "SBServer.h"
#import "SBHome.h"
#import "SBClientController.h"
#import "SBArtist.h"
#import "SBAlbum.h"
#import "SBPlaylist.h"
#import "SBChatMessage.h"

#import "EMKeychainItem.h"


@implementation SBServer

@dynamic resources;
@synthesize clientController;
@synthesize selectedTabIndex;


+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *result = nil;
    
    if([key isEqualToString:@"playlists"]) {
        result = [NSSet setWithObjects:@"resources", nil];
    }
    
    if([key isEqualToString:@"resources"]) {
        result = [NSSet setWithObjects:@"playlists", nil];
    }
    
    if([key isEqualToString:@"hasUnread"]) {
        result = [NSSet setWithObjects:@"messages.unread", nil];
    }
    
    if([key isEqualToString:@"numberOfUnread"]) {
        result = [NSSet setWithObjects:@"messages.unread", nil];
    }
    
    if([key isEqualToString:@"licenseImage"]) {
        result = [NSSet setWithObjects:@"isValidLicense", nil];
    }
    
    return result;
}



#pragma mark -
#pragma mark LifeCycle

- (void)dealloc {
    [clientController release];
    [super dealloc];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if(self.home == nil) {
        self.home = [SBHome insertInManagedObjectContext:self.managedObjectContext];
    }

}




#pragma mark -
#pragma mark Custom Accessors (Source List Tree Support)

- (NSSet *)resources {
    NSSet *result = nil;
    
    [self willAccessValueForKey:@"resources"];
    [self willAccessValueForKey:@"playlists"];
    
    result = [self primitiveValueForKey:@"playlists"];
    
    [self didAccessValueForKey:@"playlists"];
    [self didAccessValueForKey:@"resources"];
    
    return result;
}

- (void)setResources:(NSSet *)_resources {
    
    [self willChangeValueForKey:@"resources"];
    [self willChangeValueForKey:@"playlists"];
    
    [self setPrimitiveValue:_resources forKey:@"playlists"];
    
    [self didChangeValueForKey:@"playlists"];
    [self didChangeValueForKey:@"resources"];
}

- (NSSet *)playlists {
    NSSet *result = nil;
    
    [self willAccessValueForKey:@"resources"];
    [self willAccessValueForKey:@"playlists"];
    
    result = [self primitiveValueForKey:@"playlists"];
    
    [self didAccessValueForKey:@"playlists"];
    [self didAccessValueForKey:@"resources"];
    
    return result;
}

- (void)setPlaylists:(NSSet *)playlistsSet {
    
    [self willChangeValueForKey:@"resources"];
    [self willChangeValueForKey:@"playlists"];
    
    [self setPrimitiveValue:playlistsSet forKey:@"playlists"];
    
    [self didChangeValueForKey:@"playlists"];
    [self didChangeValueForKey:@"resources"];
}



- (BOOL)hasUnread {
    return ([self numberOfUnread] > 0 ? YES : NO);
}


- (NSInteger)numberOfUnread {
    NSInteger ret = 0;
    
    for(SBChatMessage *message in self.messages) {
        if([message.unread  boolValue])
            ret++;
    }
    return ret;
}


- (NSImage *)licenseImage {
    NSImage *result = [NSImage imageNamed:@"off"];
    
    if([self.isValidLicense boolValue])
        result = [NSImage imageNamed:@"on"];
    
    return result;
}


#pragma mark -
#pragma mark Custom Accessors (Subsonic Client)

- (SBClientController *)clientController {
    if(!clientController) {
        clientController = [[SBClientController alloc] initWithManagedObjectContext:self.managedObjectContext];
        [clientController setServer:self];
    }
    
    return clientController;
}




#pragma mark -
#pragma mark Custom Accessors (Keychain Support)

//- (NSString *)password {
//    
//    NSString *string = nil;
//    [self willAccessValueForKey: @"password"];
//    
//    // decompose URL
//    if(self.url && self.username) {
//
//        NSURL *anUrl = [NSURL URLWithString:self.url];
//        // protocol scheme
//        uint protocol = kSecProtocolTypeHTTP;
//        if([[anUrl scheme] rangeOfString:@"s"].location != NSNotFound) {
//            protocol = kSecProtocolTypeHTTPS;
//        }
//        // url port
//        NSNumber *port = [NSNumber numberWithInteger:80];
//        if([anUrl port] != nil) {
//            port = [anUrl port];
//        }
//        
//        // get internet keycahin
//        EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:[anUrl host] 
//                                                                                        withUsername:self.username 
//                                                                                                path:@"/"
//                                                                                                port:[port integerValue] 
//                                                                                            protocol:protocol];
//        string = keychainItem.password;
//    }
//    [self didAccessValueForKey: @"password"];
//    return string;
//}

//- (void)setPassword:(NSString *) x {
//    [self willChangeValueForKey: @"password"];
//    
//    // decompose URL
//    if(self.url && self.username) {
//        NSURL *anUrl = [NSURL URLWithString:self.url];
//        // protocol scheme
//        uint protocol = kSecProtocolTypeHTTP;
//        if([[anUrl scheme] rangeOfString:@"s"].location != NSNotFound) {
//            protocol = kSecProtocolTypeHTTPS;
//        }
//        // url port
//        NSNumber *port = [NSNumber numberWithInteger:80];
//        if([anUrl port] != nil) {
//            port = [anUrl port];
//        }
//        
//        // add internet keychain
//        NSLog(@"add internet keychain");
//        [EMInternetKeychainItem addInternetKeychainItemForServer:[anUrl host] 
//                                                    withUsername:self.username
//                                                        password:x
//                                                            path:@"/"
//                                                            port:[port integerValue] 
//                                                        protocol:protocol];
//    }
//    [self didChangeValueForKey: @"password"];
//}





#pragma mark -
#pragma mark Subsonic Client (Login)

- (void)connect {
    [[self clientController] connectToServer:self];
}

- (void)getServerLicense {
    [[self clientController] getLicense];
}




#pragma mark -
#pragma mark Subsonic Client (Server Data)

- (void)getServerIndexes {
    if(self.lastIndexesDate != nil) {
        [[self clientController] getIndexesSince:self.lastIndexesDate];
    } else {
        [[self clientController] getIndexes];
    }
}

- (void)getAlbumsForArtist:(SBArtist *)artist {
    [[self clientController] getAlbumsForArtist:artist];
}

- (void)getTracksForAlbumID:(NSString *)albumID {
    [[self clientController] getTracksForAlbumID:albumID];
}

- (void)getAlbumListForType:(SBSubsonicRequestType)type {
    [[self clientController] getAlbumListForType:type];
}




#pragma mark -
#pragma mark Subsonic Client (Playlists)

- (void)getServerPlaylists {
    [[self clientController] getPlaylists];
}

- (void)createPlaylistWithName:(NSString *)playlistName tracks:(NSArray *)tracks {
    [[self clientController] createPlaylistWithName:playlistName tracks:tracks];
}

- (void)updatePlaylistWithID:(NSString *)playlistID tracks:(NSArray *)tracks {
    [[self clientController] updatePlaylistWithID:playlistID tracks:tracks];
}

- (void)deletePlaylistWithID:(NSString *)playlistID {
    [[self clientController] deletePlaylistWithID:playlistID];
}

- (void)getPlaylistTracks:(SBPlaylist *)playlist {
    [[self clientController] getPlaylist:playlist];
}




#pragma mark -
#pragma mark Subsonic Client (Podcasts)

- (void)getServerPodcasts {
   [[self clientController] getPodcasts]; 
}



#pragma mark -
#pragma mark Subsonic Client (Chat)

- (void)addChatMessage:(NSString *)message {
    [[self clientController] addChatMessage:message]; 
}

- (void)getChatMessagesSince:(NSDate *)date {
    [[self clientController] getChatMessagesSince:date];
}




#pragma mark -
#pragma mark Subsonic Client (Now Playing)

- (void)getNowPlaying {
    [[self clientController] getNowPlaying];
}




#pragma mark -
#pragma mark Subsonic Client (Search)

- (void)searchWithQuery:(NSString *)query {
    [[self clientController] search:query];
}




#pragma mark -
#pragma mark Subsonic Client (Rating)

- (void)setRating:(NSInteger)rating forID:(NSString *)anID {
    [[self clientController] setRating:rating forID:anID];
}



@end
