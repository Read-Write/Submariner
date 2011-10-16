//
//  SBPlayer.m
//  Sub
//
//  Created by nark on 22/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#include <libkern/OSAtomic.h>
#import <LRResty/LRResty.h>

#import "SBAppDelegate.h"
#import "SBPlayer.h"
#import "SBTrack.h"
#import "SBServer.h"
#import "SBLibrary.h"
#import "AudioStreamer.h"
#import "SBImportOperation.h"

#import "NSURL+Parameters.h"
#import "NSManagedObjectContext+Fetch.h"
#import "NSOperationQueue+Shared.h"
#import "NSString+Time.h"



// notifications
NSString *SBPlayerPlaylistUpdatedNotification = @"SBPlayerPlaylistUpdatedNotification";




@interface SBPlayer (Private)
- (void)playLocalTrackPath:(NSString *)path;
- (void)playRemoteTrackURL:(NSURL *)url saveLocation:(NSString *)location;
- (void)unplayAllTracks;
- (SBTrack *)getRandomTrackExceptingTrack:(SBTrack *)_track;
- (SBTrack *)nextTrack;
- (SBTrack *)prevTrack;
@end




@implementation SBPlayer


@synthesize currentTrack;
@synthesize playlist;
@synthesize isShuffle;
@synthesize isPlaying;
@synthesize isPaused;
@synthesize repeatMode;




#pragma mark -
#pragma mark Singleton support 

+ (id)sharedInstance {

    static SBPlayer* sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[SBPlayer alloc] init];
    }
    return sharedInstance;
    
}



- (id)init {
    self = [super init];
    if (self) {
        playlist = [[NSMutableArray alloc] init];
        isShuffle = NO;
        isCaching = NO;
        
        repeatMode = SBPlayerRepeatNo;
    }
    return self;
}

- (void)dealloc {
    // remove remote player observers
    [self stop];
    
    [localPlayer release];
    [currentTrack release];
    [playlist release];
    [super dealloc];
}





#pragma mark -
#pragma mark Playlist Management

- (void)addTrack:(SBTrack *)track replace:(BOOL)replace {
    
    if(replace) {
        [playlist removeAllObjects];
    }
    
    [playlist addObject:track];
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
}

- (void)addTrackArray:(NSArray *)array replace:(BOOL)replace {
    
    if(replace) {
        [playlist removeAllObjects];
    }
    
    [playlist addObjectsFromArray:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
}


- (void)removeTrack:(SBTrack *)track {
    if([track isEqualTo:self.currentTrack]) {
        [self stop];
    }
    
    [playlist removeObject:track];
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
}

- (void)removeTrackArray:(NSArray *)tracks {
    [playlist removeObjectsInArray:tracks];
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
}






#pragma mark -
#pragma mark Player Control

- (void)playTrack:(SBTrack *)track {
    
    // stop player
    [self stop];
    
    
    // clean previous playing track
    if(self.currentTrack != nil) {
        [self.currentTrack setIsPlaying:[NSNumber numberWithBool:NO]];
        self.currentTrack = nil;
    }
    
    // set the new current track
    [self setCurrentTrack:track];
    
    // deallox players
//    if(remotePlayer) {
//        [remotePlayer release];
//        remotePlayer = nil;
//    }
    if(localPlayer) {
        [localPlayer release];
        localPlayer = nil;
    }
    
    if([self.currentTrack.isLocal boolValue] ) {
        
#if DEBUG 
        NSLog(@"play with SFBAudioEngine (locally)");
#endif
        
        [self playLocalTrackPath:self.currentTrack.path];
        
        [self.currentTrack setIsPlaying:[NSNumber numberWithBool:YES]];
        [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
        
        
        
    } else {
        
        if(self.currentTrack.localTrack != nil) {
#if DEBUG 
            NSLog(@"play with SFBAudioEngine (locally)");
#endif
            [self playLocalTrackPath:self.currentTrack.localTrack.path];
            
        } else {
#if DEBUG   
            NSLog(@"play with audio streamer (remotely)");
#endif
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableCacheStreaming"] == YES) {
                // create a cache temp file
                NSURL *tempFileURL = [NSURL temporaryFileURL];
                NSString *location = [[[tempFileURL absoluteString] stringByAppendingPathExtension:@"mp3"] retain];
                
                if([[NSFileManager defaultManager] createFileAtPath:location contents:nil attributes:nil]) {
                    
                    [self playRemoteTrackURL:[self.currentTrack streamURL] saveLocation:location];
                    isCaching = YES;
                }
                
            } else {
                [self playRemoteTrackURL:[self.currentTrack streamURL] saveLocation:nil];
                isCaching = NO;
            }
        }
        
        [self.currentTrack setIsPlaying:[NSNumber numberWithBool:YES]];
        [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
    }
    
    self.isPlaying = YES;
    self.isPaused = NO;
}


- (void)playLocalTrackPath:(NSString *)path {
    NSLog(@"path : %@", path);
    
    localPlayer = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
    [localPlayer setDelegate:self];
    [localPlayer setVolume:[self volume]];
    [localPlayer play];
    
    NSLog(@"localPlayer : %@", localPlayer);
}

- (void)playRemoteTrackURL:(NSURL *)url saveLocation:(NSString *)location {

    // register location to app delegate to remove it when app quit
    if(location)
        [[[SBAppDelegate sharedInstance] tmpPaths] addObject:location];
    
    // setup player and play
	if (remotePlayer == nil) {
        remotePlayer = [[AudioStreamer alloc] initWithURL:[self.currentTrack streamURL] saveLocation:location];
        // observer remote player to know stop status
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(streamerStatusChangedNotification:) 
													 name:ASStatusChangedNotification 
												   object:remotePlayer];
        
		[remotePlayer setGain:[self volume]];
		[remotePlayer performSelector:@selector(start) withObject:nil afterDelay:0.0];
    
        return;
    }
    if ([remotePlayer isPlaying]) {
        [remotePlayer stop];
        [remotePlayer release];
    }
    remotePlayer = [[AudioStreamer alloc] initWithURL:[self.currentTrack streamURL] saveLocation:location];
	
	[remotePlayer setGain:[self volume]];
    [remotePlayer performSelector:@selector(start) withObject:nil afterDelay:0.0];
    
    // observer remote player to know stop status
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(streamerStatusChangedNotification:) 
                                                 name:ASStatusChangedNotification 
                                               object:remotePlayer];
}


- (void)playPause {
    
    if([self.currentTrack.isLocal boolValue] || self.currentTrack.localTrack != nil) {
        // stop SFAudiEngine player
        if(self.isPaused == NO) {
            [localPlayer pause];
            self.isPaused = YES;
        } else {
            [localPlayer resume];
            self.isPaused = NO;
        }
    } else {
        // stop audio streamer
        if(self.isPaused == YES) {
            [remotePlayer start];
            self.isPaused = NO;
        } else {
            [remotePlayer pause];
            self.isPaused = YES;
        }
    }
}

- (void)next {
    SBTrack *next = [self nextTrack];
    if(next != nil) {
        @synchronized(self) {
            //[self stop];
            [self playTrack:next];
        }
    }
}

- (void)previous {
    SBTrack *prev = [self prevTrack];
    if(prev != nil) {
        @synchronized(self) {
            //[self stop];
            [self playTrack:prev];
        }
    }
}


- (void)setVolume:(float)volume {
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:@"playerVolume"];
    
    if(self.currentTrack) {
        
        if(localPlayer)
            [localPlayer setVolume:volume];
        
        if(remotePlayer)
            [remotePlayer setGain:volume];
    }
}


- (void)seek:(double)time {
    if(self.currentTrack && ([self.currentTrack.isLocal boolValue] || self.currentTrack.localTrack != nil)) {
        
        [localPlayer setCurrentTime:(time / 100.0) * [localPlayer duration]];
        
    } else if(self.currentTrack && ![self.currentTrack.isLocal boolValue]) {
        
        double newSeekTime = (time / 100.0) * [remotePlayer duration];
        [remotePlayer seekToTime:newSeekTime];
        
        isCaching = NO;
    }
}


- (void)stop {

    @synchronized(self) {
        // stop local player
        [localPlayer performSelectorOnMainThread:@selector(pause) withObject:nil waitUntilDone:YES];
        
        // stop remote player
        [remotePlayer performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:remotePlayer];
        
        // unplay all
        [self unplayAllTracks];
        
        // stop player !!
        self.isPlaying = NO;
        self.isPaused = YES; // for sure
	}
}


- (void)clear {
    //[self stop];
    [self.playlist removeAllObjects];
    [self setCurrentTrack:nil];
}




#pragma mark -
#pragma mark Accessors (Player Properties)

- (NSString *)currentTimeString {
    
    if(self.currentTrack && ([self.currentTrack.isLocal boolValue] || self.currentTrack.localTrack != nil)) {

        return [NSString stringWithTime:[localPlayer currentTime]];
        
    } else if(self.currentTrack && ![self.currentTrack.isLocal boolValue]) {

		return [NSString stringWithTime:[remotePlayer progress]];
    }
    
    return nil;
}

- (NSString *)remainingTimeString {
    
    if(self.currentTrack && ([self.currentTrack.isLocal boolValue] || self.currentTrack.localTrack != nil)) {

        NSTimeInterval currentTime, totalTime;
        
        currentTime = [localPlayer currentTime];
        totalTime = [localPlayer duration];
        
        return [NSString stringWithTime:(-1 * (totalTime - currentTime))];
        
    } else if(self.currentTrack && ![self.currentTrack.isLocal boolValue]) {
        double duration = [remotePlayer duration];
        double progress = [remotePlayer progress]; 
		double reverseDuration = (duration - progress) - (2 * (duration - progress));       
		return [NSString stringWithTime:reverseDuration];
    }
    
    return nil;
}

- (double)progress {
    
    if(self.currentTrack && ([self.currentTrack.isLocal boolValue] || self.currentTrack.localTrack != nil)) {
        
        NSTimeInterval currentTime, totalTime;
        
        currentTime = [localPlayer currentTime];
        totalTime = [localPlayer duration];
        
        return (100 * currentTime / totalTime);
        
    } else if(self.currentTrack && ![self.currentTrack.isLocal boolValue]) {
        double duration = [remotePlayer duration];
        double progress = [remotePlayer progress]; 
    
		return (100 * progress / duration);
    }
    
    return 0;
}


- (float)volume {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"playerVolume"];
}




#pragma mark -
#pragma mark Remote Player Notification 

- (void)streamerStatusChangedNotification:(NSNotification *)notification {
    
    if([[notification object] stopReason] == AS_STOPPING_EOF) {
        NSLog(@"AS_STOPPING_EOF");
        
    } else if([[notification object] stopReason] == AS_STOPPING_USER_ACTION) {
        NSLog(@"AS_STOPPING_USER_ACTION");       
        
    } else if([[notification object] stopReason] == AS_STOPPING_ERROR) {
        NSLog(@"AS_STOPPING_ERROR");
        
    } else if([[notification object] stopReason] == AS_STOPPING_TEMPORARILY) {
        NSLog(@"AS_STOPPING_TEMPORARILY");     
        
    }
    
    if([[notification object] state] == AS_STOPPED) {
		
        NSLog(@"AS_STOPPED");
        
        // check streaming stop reason to manage cache
        if(isCaching) {
            if([[notification object] stopReason] == AS_STOPPING_EOF) {
                NSLog(@"AS_STOPPING_EOF");

                
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableCacheStreaming"] == YES) {
                    NSManagedObjectContext *moc = self.currentTrack.managedObjectContext;
                    SBLibrary *library = [moc fetchEntityNammed:@"Library" withPredicate:nil error:nil];
                    
                    // import audio file
                    SBImportOperation *op = [[SBImportOperation alloc] initWithManagedObjectContext:moc];
                    [op setFilePaths:[NSArray arrayWithObject:[[notification object] saveLocation]]];
                    [op setLibraryID:[library objectID]];
                    [op setRemoteTrackID:[self.currentTrack objectID]];
                    [op setCopy:YES];
                    [op setRemove:YES];
                    
                    [[NSOperationQueue sharedDownloadQueue] addOperation:op];
                }
                
            } else if([[notification object] stopReason] == AS_STOPPING_TEMPORARILY) {
                NSLog(@"AS_STOPPING_TEMPORARILY");
                
            } else if([[notification object] stopReason] == AS_STOPPING_ERROR) {
                NSLog(@"AS_STOPPING_ERROR");
                // clean temp cache file if caching
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm removeItemAtPath:[[notification object] saveLocation] error:nil];
                
            } else if([[notification object] stopReason] == AS_STOPPING_USER_ACTION) {
                NSLog(@"AS_STOPPING_USER_ACTION");
                // ???
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm removeItemAtPath:[[notification object] saveLocation] error:nil];
            }
        }
        // play next track
        [self next];
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_INITIALIZED");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_STARTING_FILE_THREAD");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_WAITING_FOR_DATA");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_FLUSHING_EOF");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_WAITING_FOR_QUEUE_TO_START");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_PLAYING");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_BUFFERING");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_PLAYING");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_STOPPING");
        
    } else if([[notification object] state] == AS_INITIALIZED) {
        NSLog(@"AS_PAUSED");
        
    }
}



#pragma mark -
#pragma mark NSSound Delegate

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)finishedPlaying {
    // play next track
    [self next];
}






#pragma mark -
#pragma mark Private


- (SBTrack *)getRandomTrackExceptingTrack:(SBTrack *)_track {
	
	SBTrack *randomTrack = _track;
	NSArray *sortedTracks = [self playlist];
	
	if([sortedTracks count] > 1) {
		while ([randomTrack isEqualTo:_track]) {
			NSInteger numberOfTracks = [sortedTracks count];
			NSInteger randomIndex = random() % numberOfTracks;
			randomTrack = [sortedTracks objectAtIndex:randomIndex];
		}
	} else {
		randomTrack = nil;
	}
	
	
	return randomTrack;
}


- (SBTrack *)nextTrack {
    
    if(self.playlist) {
        if(!isShuffle) {
            NSInteger index = [self.playlist indexOfObject:self.currentTrack];
            
            if(repeatMode == SBPlayerRepeatNo) {
                
                // no repeat, play next
                if(index > -1 && [self.playlist count]-1 >= index+1) {
                    return [self.playlist objectAtIndex:index+1];
                }
            }
                
            // if repeat one, esay to relaunch the track
            if(repeatMode == SBPlayerRepeatOne)
                return self.currentTrack;
            
            // if repeat all, broken...
             if(repeatMode == SBPlayerRepeatAll)
                 if([self.currentTrack isEqualTo:[self.playlist lastObject]] && index > 0)
                     return [self.playlist objectAtIndex:0];
				else
					if(index > -1 && [self.playlist count]-1 >= index+1) {
						return [self.playlist objectAtIndex:index+1];
					}
            
        } else {
            // if repeat one, get the piority
            if(repeatMode == SBPlayerRepeatOne)
                return self.currentTrack;
            
            // else play random
            return [self getRandomTrackExceptingTrack:self.currentTrack];
        }
    }
    return nil;
}


- (SBTrack *)prevTrack {
    if(self.playlist) {
        if(!isShuffle) {
            NSInteger index = [self.playlist indexOfObject:self.currentTrack];   
            
            if(repeatMode == SBPlayerRepeatOne)
                return self.currentTrack;
            
            if(index == 0)
                if(repeatMode == SBPlayerRepeatAll)
                    return [self.playlist lastObject];
            
            if(index != -1)
                return [self.playlist objectAtIndex:index-1];
        } else {
            // if repeat one, get the piority
            if(repeatMode == SBPlayerRepeatOne)
                return self.currentTrack;
            
            return [self getRandomTrackExceptingTrack:self.currentTrack];
        }
    }
    return nil;
}

- (void)unplayAllTracks {

    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isPlaying == YES)"];
    NSArray *tracks = [[self.currentTrack managedObjectContext] fetchEntitiesNammed:@"Track" withPredicate:predicate error:&error];
    
    for(SBTrack *track in tracks) {
        [track setIsPlaying:[NSNumber numberWithBool:NO]];
//        SBServer *serv = track.server;
//        [serv setCurrentTrack:nil];
    }
}



@end
