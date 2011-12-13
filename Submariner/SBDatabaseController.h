//
//  SBLibraryController.h
//  Sub
//
//  Created by nark on 04/06/11.
//  Copyright 2011 read-write. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "SBWindowController.h"
#import "SBSourceList.h"
#import "RWStreamingSlider.h"
#import "MCViewFlipController.h"

@class SBMainSplitViewDelegate;
@class SBSplitView;
@class SBSourceList;
@class SBEditServerController;
@class SBAddServerPlaylistController;
@class SBMusicController;
@class SBMusicTopbarController;
@class SBDownloadsController;
@class SBTracklistController;
@class SBPlaylistController;
@class SBServerTopbarController;
@class SBLibrary;
@class SBAnimatedView;
@class SBSpinningProgressIndicator;
@class SBMovieViewController;
@class MAAttachedWindow;


#define SBLibraryTableViewDataType @"SBLibraryTableViewDataType"


@interface SBDatabaseController : SBWindowController <NSWindowDelegate, SBSourceListDelegate, SBSourceListDataSource> {
@private
    IBOutlet NSView *titleView;
    IBOutlet NSView *hostView;
    IBOutlet SBSplitView *mainSplitView;
    IBOutlet SBSplitView *titleSplitView;   
    IBOutlet NSSplitView *coverSplitView;
    IBOutlet NSImageView *handleSplitView;
    IBOutlet SBSourceList *sourceList;
    IBOutlet NSTreeController *resourcesController;
    IBOutlet SBEditServerController *editServerController;
    SBAddServerPlaylistController *addServerPlaylistController;
    IBOutlet NSBox *mainBox;
    IBOutlet NSBox *topbarBox;
    IBOutlet SBAnimatedView *currentView;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSButton *toggleButton;
    IBOutlet NSTextField *trackTitleTextField;
    IBOutlet NSTextField *trackInfosTextField;
    IBOutlet NSTextField *durationTextField;
    IBOutlet NSTextField *progressTextField;
    IBOutlet RWStreamingSlider *progressSlider;
    IBOutlet NSImageView *onlineImageView;
    IBOutlet NSImageView *coverImageView;
    IBOutlet NSButton *playPauseButton;
    
    SBMusicController *musicController;
    SBMusicTopbarController *musicTopbarController;
    SBDownloadsController *downloadsController;
    SBTracklistController *tracklistController;
    SBPlaylistController *playlistController;
    SBServerTopbarController *serverTopbarController;
    SBMovieViewController *movieViewController;
    SBMainSplitViewDelegate *mainSplitViewDelegate;
    MCViewFlipController *flipController;
    NSArray *resourceSortDescriptors;
    SBLibrary *library;
    
    MAAttachedWindow *attachedWindow;
    CATransition *transition;
    
    NSTimer *progressUpdateTimer;
}

@property (readwrite, retain) NSArray *resourceSortDescriptors;
@property (readwrite, retain) IBOutlet SBAnimatedView *currentView;
@property (readwrite, retain) IBOutlet SBAddServerPlaylistController *addServerPlaylistController;
@property (readwrite, retain) SBLibrary *library;

- (void)setCurrentView:(SBAnimatedView *)newView;
- (BOOL)openImportAlert:(NSWindow *)sender files:(NSArray *)files;
- (void)showDownloadView;

- (IBAction)openAudioFiles:(id)sender;
- (IBAction)toggleTrackList:(id)sender;
- (IBAction)attachDettachTracklist:(id)sender;
- (IBAction)addPlaylist:(id)sender;
- (IBAction)addRemotePlaylist:(id)sender;
- (IBAction)addServer:(id)sender;
- (IBAction)editItem:(id)sender;
- (IBAction)removeItem:(id)sender;
- (IBAction)deleteRemotePlaylist:(id)sender;
- (IBAction)reloadServer:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)seekTime:(id)sender;
- (IBAction)setVolume:(id)sender;
- (IBAction)setMuteOn:(id)sender;
- (IBAction)setMuteOff:(id)sender;
- (IBAction)openHomePage:(id)sender;
- (IBAction)shuffle:(id)sender;
- (IBAction)repeat:(id)sender;
- (IBAction)flip:(id)sender;

@end
