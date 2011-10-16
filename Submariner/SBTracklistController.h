//
//  SBTracklistController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBViewController.h"
#import "SBTableView.h"

#define SBTracklistTableViewDataType @"SBTracklistTableViewDataType"


@class SBDatabaseController;

@interface SBTracklistController : SBViewController <SBTableViewDelegate> {
@private
    IBOutlet NSTableView *playlistTableView;
    SBDatabaseController *databaseController;
}

@property (readwrite, retain) SBDatabaseController *databaseController;

- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)shuffle:(id)sender;
- (IBAction)repeat:(id)sender;

- (IBAction)trackDoubleClick:(id)sender;
- (IBAction)cleanTracklist:(id)sender;
- (IBAction)removeTrack:(id)sender;
- (IBAction)closeTracklist:(id)sender;

@end
