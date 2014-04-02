//
//  SBUserViewController.h
//  Submariner
//
//  Created by Rafaël Warnault on 13/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBServerViewController.h"


@class SBPrioritySplitViewDelegate;

@interface SBServerUserViewController : SBServerViewController {
    IBOutlet NSTextView *chatTextView;
    IBOutlet NSArrayController *chatMessagesController;
    IBOutlet NSArrayController *nowPlayingController;
    IBOutlet NSCollectionView *nowPlayingCollectionView;
    IBOutlet NSSplitView *chatSplitView;
    
    NSTimer *refreshChatTimer;
    NSTimer *refreshNowPlayingTimer;
    NSArray *nowPlayingSortDescriptors;
    SBPrioritySplitViewDelegate *splitViewDelegate;
}

@property (readwrite, retain) NSArray *nowPlayingSortDescriptors;

- (void)viewDidLoad;
- (IBAction)refreshChat:(id)sender;
- (IBAction)clearChat:(id)sender;
- (IBAction)refreshNowPlaying:(id)sender;

@end
