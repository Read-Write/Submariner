//
//  MusicTopbar.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBViewController.h"
#import "ANSegmentedControl.h"
#import "SBTopbarView.h"

@class SBDatabaseController;
@class SBMusicController;
@class SBMusicSearchController;

@interface SBMusicTopbarController : SBViewController <ANSegmentedControlDelegate, NSControlTextEditingDelegate> {
@private
    SBDatabaseController *databaseController;
    SBMusicController *musicController;
    SBMusicSearchController *musicSearchController;
}

@property (readwrite, retain) SBDatabaseController *databaseController;
@property (readwrite, retain) SBMusicController *musicController;

- (IBAction)search:(id)sender;

@end
