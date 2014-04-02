//
//  SBServerServerController.h
//  Submariner
//
//  Created by Rafaël Warnault on 25/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBServerViewController.h"

@class SBSearchResult;

@interface SBServerSearchController : SBServerViewController {
    SBSearchResult *searchResult;
    
    IBOutlet NSTableView *tracksTableView;
    IBOutlet NSArrayController *tracksController;
}

@property (readwrite, retain) SBSearchResult *searchResult;

- (IBAction)trackDoubleClick:(id)sender;
- (IBAction)addTrackToTracklist:(id)sender;
- (IBAction)downloadTrack:(id)sender;

@end
