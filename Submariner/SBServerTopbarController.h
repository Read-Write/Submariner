//
//  SBServerTopbarController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBServerViewController.h"
#import "SBTopbarView.h"

@class SBDatabaseController;
@class SBServerLibraryController;
@class SBServerHomeController;
@class SBServerPodcastController;
@class SBServerUserViewController;
@class SBServerSearchController;

@interface SBServerTopbarController : SBServerViewController <SBTopbarViewDelegate> {
@private
    SBDatabaseController *databaseController;
    SBServerLibraryController *serverLibraryController;
    SBServerHomeController *serverHomeController;
    SBServerPodcastController *serverPodcastController;
    SBServerUserViewController *serverUserController;
    SBServerSearchController *serverSearchController;
    
    IBOutlet NSSegmentedControl *viewSegmentedControl;
    IBOutlet SBTopbarView *topbarView;
    
}

@property (readwrite, retain) SBDatabaseController *databaseController;

- (void)setViewControllerAtIndex:(NSInteger)index;

- (IBAction)viewControllerChange:(id)sender;
- (IBAction)search:(id)sender;

@end
