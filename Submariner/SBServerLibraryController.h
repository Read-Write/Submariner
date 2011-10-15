//
//  SBServerController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SBServerViewController.h"
#import "SBTableView.h"

@class SBDatabaseController;
@class SBPrioritySplitViewDelegate;

@interface SBServerLibraryController : SBServerViewController <NSTabViewDelegate, SBTableViewDelegate> {
@private
    IBOutlet NSTableView        *artistsTableView;
    IBOutlet SBTableView        *tracksTableView;
    IBOutlet IKImageBrowserView *albumsBrowserView;
    IBOutlet NSArrayController  *artistsController;
    IBOutlet NSArrayController  *albumsController;
    IBOutlet NSArrayController  *tracksController;
    IBOutlet NSSplitView        *artistSplitView;
    
    SBPrioritySplitViewDelegate *splitViewDelegate;
    SBDatabaseController *databaseController;
    NSArray *artistSortDescriptor;
    NSArray *trackSortDescriptor;
}

@property (readwrite, retain) SBDatabaseController *databaseController;
@property (readwrite, retain) NSArray *artistSortDescriptor;
@property (readwrite, retain) NSArray *trackSortDescriptor;

- (IBAction)trackDoubleClick:(id)sender;
- (IBAction)albumDoubleClick:(id)sender;
- (IBAction)filterArtist:(id)sender;
- (IBAction)createNewPlaylistWithSelectedTracks:(id)sender;
- (IBAction)addArtistToTracklist:(id)sender;
- (IBAction)addAlbumToTracklist:(id)sender;
- (IBAction)addTrackToTracklist:(id)sender;
- (IBAction)downloadTrack:(id)sender;
- (IBAction)downloadAlbum:(id)sender;



@end
