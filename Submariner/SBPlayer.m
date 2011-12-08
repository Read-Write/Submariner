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
#import "SBMovieWindowController.h"
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




@interface QTMovie(IdlingAdditions)
-(QTTime)maxTimeLoaded;
- (void)movieDidEnd:(NSNotification *)notification;
@end



@interface SBPlayer (Private)

- (void)playMovieWithURL:(NSURL *)url;
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
    
    [moviePlayer release];
    [currentTrack release];
    [playlist release];
    [tmpLocation release];
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
    
    NSLog(@"isVideo : %@", [track isVideo] ? @"YES" : @"NO");
    
    // clean previous playing track
    if(self.currentTrack != nil) {
        [self.currentTrack setIsPlaying:[NSNumber numberWithBool:NO]];
        self.currentTrack = nil;
    }
    
    // set the new current track
    [self setCurrentTrack:track];    
    
    // check if cache download enable or not : manage the tmp file
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableCacheStreaming"] == YES) {
        if(tmpLocation) {
            [tmpLocation release];
            tmpLocation = nil;
        }
        
        // create a cache temp file
        NSURL *tempFileURL = [NSURL temporaryFileURL];
        tmpLocation = [[[tempFileURL absoluteString] stringByAppendingPathExtension:@"mp3"] retain];
        
        if([[NSFileManager defaultManager] createFileAtPath:tmpLocation contents:nil attributes:nil]) {
            isCaching = YES;
        }
    } else {
        isCaching = NO;
    }
    
    // play the song
    [self playMovieWithURL:[self.currentTrack streamURL]];
    
    // setup player for playing
    [self.currentTrack setIsPlaying:[NSNumber numberWithBool:YES]];
    [[NSNotificationCenter defaultCenter] postNotificationName:SBPlayerPlaylistUpdatedNotification object:self];
    self.isPlaying = YES;
    self.isPaused = NO;
}


- (void)playMovieWithURL:(NSURL *)url {
    NSLog(@"playMovieWithURL");
    
    NSError *error = nil;
    
    moviePlayer = [[QTMovie alloc] initWithURL:url error:&error];

	if (!moviePlayer || error)
		NSLog(@"Couldn't init movie: %@", error);
    
	else {
        
        [moviePlayer setDelegate:self];
        [moviePlayer setVolume:[self volume]];
        
        NSLog(@"url : %@", url);
        if([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(loadStateDidChange:) 
                                                         name:QTMovieLoadStateDidChangeNotification 
                                                       object:moviePlayer];
        } else {
            [moviePlayer performSelector:@selector(play) withObject:nil afterDelay:0.2f];
        }
    }
}

- (void)playPause {
    
    if((moviePlayer != nil) && ([moviePlayer rate] != 0)) {
        [moviePlayer stop];
    } else {
        [moviePlayer play];
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
    
    if(moviePlayer)
        [moviePlayer setVolume:volume];
}


- (void)seek:(double)time {
    
    NSTimeInterval duration;
    QTGetTimeInterval([moviePlayer duration], &duration);    
    double newSeekTime = (time / 100.0) * duration;     
    QTTime qtTime = QTMakeTimeWithTimeInterval(newSeekTime);
    
    [moviePlayer setCurrentTime:qtTime];

    if(isCaching) {
        isCaching = NO;
    }
}


- (void)stop {

    @synchronized(self) {
        // stop movie player
        [moviePlayer stop];
        
        // unplay current track
        [self.currentTrack setIsPlaying:[NSNumber numberWithBool:NO]];
        
        // unplay all
        [self unplayAllTracks];
        
        // stop player !
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
    
    if(moviePlayer != nil)
    {
        NSTimeInterval currentTime; 
        QTGetTimeInterval([moviePlayer currentTime], &currentTime);
        
        return [NSString stringWithTime:currentTime];
    }
    
    return nil;
}

- (NSString *)remainingTimeString {
    
    
    if(moviePlayer != nil)
    {
        NSTimeInterval currentTime; 
        NSTimeInterval duration;
        
        QTGetTimeInterval([moviePlayer duration], &duration);
        QTGetTimeInterval([moviePlayer currentTime], &currentTime);
        
        NSTimeInterval remainingTime = duration-currentTime;
        return [NSString stringWithTime:-remainingTime];
    }
    return nil;
}

- (double)progress {
    
    if(moviePlayer != nil)
    {
        // typedef struct { long long timeValue; long timeScale; long flags; } QTTime
        QTTime qtCurrentTime = [moviePlayer currentTime];
        QTTime qtDuration    = [moviePlayer duration];
        
        long long currentTime = qtCurrentTime.timeValue;
        long long duration = qtDuration.timeValue;
        
        if(duration > 0) {
            double progress = ((double)currentTime) / ((double)duration) * 100; // make percent
            //NSLog(@"progress : %f", progress);
            
            if(progress == 100) { // movie is at end
                [self next];
            }
            
            return progress;
            
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    return 0;
}


- (float)volume {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"playerVolume"];
}

- (double)percentLoaded {
    NSTimeInterval tMaxLoaded;
    NSTimeInterval tDuration;
    
    QTGetTimeInterval([moviePlayer duration], &tDuration);
    QTGetTimeInterval([moviePlayer maxTimeLoaded], &tMaxLoaded);
    
    return (double) tMaxLoaded/tDuration;
}




#pragma mark -
#pragma mark Remote Player Notification 

- (void)loadStateDidChange:(NSNotification *)notification {
    NSLog(@"loadStateDidChange");
    
    // First make sure that this notification is for our movie.
    if([notification object] == moviePlayer)
    {
        QTMovieLoadState state = [[moviePlayer attributeForKey:QTMovieLoadStateAttribute] integerValue];
        
        if([moviePlayer rate] == 0)
        {   
            if (state >= QTMovieLoadStateLoading) {
                NSLog(@"QTMovieLoadStateLoading");
                
            } else if (state >= QTMovieLoadStateLoaded) {
                NSLog(@"QTMovieLoadStateLoaded");
                
            } else if (state >= QTMovieLoadStatePlayable) {
                NSLog(@"QTMovieLoadStatePlayable");
                [moviePlayer play];
                
            } else if (state == -1) {
                NSLog(@"QTMovieLoadStateError : %@", [notification userInfo]);
                
                [self stop];
                
                NSError *error = [moviePlayer attributeForKey:QTMovieLoadStateErrorAttribute];
                if(error) [NSApp presentError:error];
                
            }
            
        } else {
            
            if (state >= QTMovieLoadStateComplete) {
                NSLog(@"QTMovieLoadStateComplete");
                NSData *data = moviePlayer.movieFormatRepresentation; // <-- data for cache streaming video !!! 
                
                if(isCaching) // is it really usefull ?
                {
                    if([[NSUserDefaults standardUserDefaults] boolForKey:@"enableCacheStreaming"] == YES) 
                    {
                        [data writeToFile:tmpLocation atomically:YES];
                        
                        NSManagedObjectContext *moc = self.currentTrack.managedObjectContext;
                        SBLibrary *library = [moc fetchEntityNammed:@"Library" withPredicate:nil error:nil];
                        
                        // import audio file
                        SBImportOperation *op = [[SBImportOperation alloc] initWithManagedObjectContext:moc];
                        [op setFilePaths:[NSArray arrayWithObject:tmpLocation]];
                        [op setLibraryID:[library objectID]];
                        [op setRemoteTrackID:[self.currentTrack objectID]];
                        [op setCopy:YES];
                        [op setRemove:YES];
                        
                        [[NSOperationQueue sharedDownloadQueue] addOperation:op];
                    }
                }
                
            } else if (state >= QTMovieLoadStateError) {
                NSLog(@"QTMovieLoadStateError : %@", [notification userInfo]);
                NSError *error = [moviePlayer attributeForKey:QTMovieLoadStateErrorAttribute];
                if(error) [NSApp presentError:error];
            } 
        }
    }
}

- (void)movieDidEnd:(NSNotification *)notification {
    NSLog(@"movieDidEnd");
    
    if([notification object] == moviePlayer) //if the player is our player
    {
        if([moviePlayer rate] > 0) // really playing
        {   
            
        }
    }
}

- (BOOL)movie:(QTMovie *)movieshouldContinueOperation :(NSString *)op withPhase:(QTMovieOperationPhase)phase atPercent:(NSNumber *)percent withAttributes:(NSDictionary *)attributes {
    
    NSLog(@"movieshouldContinueOperation");
    return YES;
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
    }
}



@end
