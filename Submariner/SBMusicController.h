//
//  SBMusicController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SBViewController.h"
#import "SBTableView.h"


@class SBDatabaseController;
@class SBPrioritySplitViewDelegate;
@class SBMergeArtistsController;

@interface SBMusicController : SBViewController <SBTableViewDelegate>  {
@private
    IBOutlet SBMergeArtistsController *mergeArtistsController;
    IBOutlet NSTableView        *artistsTableView;
    IBOutlet IKImageBrowserView *albumsBrowserView;
    IBOutlet NSTableView        *tracksTableView;
    IBOutlet NSArrayController  *artistsController;
    IBOutlet NSArrayController  *albumsController;
    IBOutlet NSArrayController  *tracksController;
    IBOutlet NSSplitView        *artistSplitView;
    
    SBDatabaseController *databaseController;
    SBPrioritySplitViewDelegate *splitViewDelegate;
    NSArray *artistSortDescriptor;
    NSArray *trackSortDescriptor;
    NSDictionary *artistCellSelectedAttributes;
    NSDictionary *artistCellUnselectedAttributes;
}
@property (readonly, retain) NSDictionary *artistCellSelectedAttributes;
@property (readonly, retain) NSDictionary *artistCellUnselectedAttributes;
@property (readwrite, retain) SBDatabaseController *databaseController;
@property (readwrite, retain) NSArray *artistSortDescriptor;
@property (readwrite, retain) NSArray *trackSortDescriptor;


- (IBAction)filterArtist:(id)sender;
- (IBAction)trackDoubleClick:(id)sender;

- (IBAction)addArtistToTracklist:(id)sender;
- (IBAction)addAlbumToTracklist:(id)sender;
- (IBAction)addTrackToTracklist:(id)sender;

- (IBAction)removeArtist:(id)sender;
- (IBAction)removeAlbum:(id)sender;
- (IBAction)removeTrack:(id)sender;

- (IBAction)showArtistInFinder:(in)sender;
- (IBAction)showAlbumInFinder:(in)sender;
- (IBAction)showTrackInFinder:(in)sender;

- (IBAction)mergeArtists:(id)sender;

@end
