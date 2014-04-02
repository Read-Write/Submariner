//
//  SBServerPodcastController.h
//  Submariner
//
//  Created by Rafaël Warnault on 23/08/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBServerViewController.h"

@interface SBServerPodcastController : SBServerViewController {
    IBOutlet NSArrayController *podcastsController;
    IBOutlet NSArrayController *episodesController;
    IBOutlet NSTableView *podcastsTableView;
    IBOutlet NSTableView *episodesTableView;
    
    NSArray *podcastsSortDescriptors;
    NSArray *episodesSortDescriptors;
}
@property (readwrite, retain) NSArray *podcastsSortDescriptors;
@property (readwrite, retain) NSArray *episodesSortDescriptors;
@end
