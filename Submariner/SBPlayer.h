//
//  SBPlayer.h
//  Sub
//
//  Created by nark on 22/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>



// notifications
extern NSString *SBPlayerPlaylistUpdatedNotification;




// repeat modes
enum SBPlayerRepeatMode {
    SBPlayerRepeatNo    = 0, // no repeat
    SBPlayerRepeatOne   = 1, // repeat the current track 
    SBPlayerRepeatAll   = 2  // repeat the current playlist
} typedef SBPlayerRepeatMode;




@class SBTrack;
@class AudioStreamer;


@interface SBPlayer : NSObject <NSSoundDelegate> {
@private
    AudioStreamer *remotePlayer;
    NSSound       *localPlayer;
    
    NSMutableArray *playlist;
    SBTrack *currentTrack;
    
    SBPlayerRepeatMode repeatMode; // the player repeat mode
    BOOL isShuffle;
    BOOL isPlaying;
    BOOL isPaused;
    
    BOOL isCaching;
}

@property (readwrite, retain) NSMutableArray *playlist;
@property (readwrite, retain) SBTrack *currentTrack;
@property (readwrite) BOOL isShuffle;
@property (readwrite) BOOL isPlaying;
@property (readwrite) BOOL isPaused;
@property (readwrite) SBPlayerRepeatMode repeatMode;

+ (id)sharedInstance;

- (void)addTrack:(SBTrack *)track replace:(BOOL)replace;
- (void)addTrackArray:(NSArray *)array replace:(BOOL)replace;
- (void)removeTrack:(SBTrack *)track;
- (void)removeTrackArray:(NSArray *)tracks;

- (void)playTrack:(SBTrack *)track;
- (void)playPause;
- (void)next;
- (void)previous;
- (void)seek:(double)time;
- (void)setVolume:(float)volume; // 0.0 - 1.0
- (void)stop; // unplay all tracks
- (void)clear;

- (NSString *)currentTimeString;
- (NSString *)remainingTimeString;
- (double)progress;
- (float)volume; // 0.0 - 1.0

@end