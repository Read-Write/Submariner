//
//  SBServerHomeController.h
//  Submariner
//
//  Created by Rafaël Warnault on 08/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SBServerViewController.h"
#import "MGScopeBar.h"


@class SBDatabaseController;

@interface SBServerHomeController : SBServerViewController <MGScopeBarDelegate> {
    IBOutlet MGScopeBar *scopeBar;
    IBOutlet NSTableView *tracksTableView;
    IBOutlet IKImageBrowserView *albumsBrowserView;
    IBOutlet NSArrayController *tracksController;
    IBOutlet NSArrayController *albumsController;
    
    NSMutableArray *scopeGroups;
    NSArray *trackSortDescriptor;
    SBDatabaseController *databaseController;
}

@property (readwrite, retain) NSArray *trackSortDescriptor;
@property (readwrite, retain) SBDatabaseController *databaseController;

- (IBAction)trackDoubleClick:(id)sender;
- (IBAction)albumDoubleClick:(id)sender;
- (IBAction)addAlbumToTracklist:(id)sender;
- (IBAction)addTrackToTracklist:(id)sender;
- (IBAction)createNewPlaylistWithSelectedTracks:(id)sender;
- (IBAction)downloadTrack:(id)sender;
- (IBAction)downloadAlbum:(id)sender;

@end
