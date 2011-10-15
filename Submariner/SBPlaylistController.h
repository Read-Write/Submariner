//
//  SBPlaylistController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBViewController.h"
#import "SBTableView.h"


@class SBPlaylist;

@interface SBPlaylistController : SBViewController <SBTableViewDelegate> {
@private
    SBPlaylist *playlist;
    
    IBOutlet SBTableView *tracksTableView;
    IBOutlet NSArrayController *tracksController;
    
    NSArray *playlistSortDescriptors;
}

@property (readwrite, retain) SBPlaylist *playlist; 
@property (readwrite, retain) NSArray *playlistSortDescriptors;

- (void)clearPlaylist;
- (IBAction)removeTrack:(id)sender;
- (IBAction)trackDoubleClick:(id)sender;

@end
