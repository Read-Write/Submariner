//
//  SBAddServerPlaylistController.m
//  Submariner
//
//  Created by Rafaël Warnault on 11/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBAddServerPlaylistController.h"
#import "SBWindowController.h"
#import "SBServer.h"
#import "SBPlaylist.h"

@implementation SBAddServerPlaylistController


@synthesize server;
@synthesize trackIDs;

- (id)init {
    self = [super init];
    if (self) {
        trackIDs = [[NSArray alloc] init];
    }
    return self;
}


- (void)dealloc {
    [trackIDs release];
    [super dealloc];
}

- (void)closeSheet:(id)sender {
    
    if(self.server != nil && [[playlistNameField stringValue] length] > 0) {
        
        NSString *playlistName = [playlistNameField stringValue];
        
        // create playlist on server 
        [self.server createPlaylistWithName:playlistName tracks:trackIDs];
        [((SBWindowController *)[parentWindow windowController]) hideVisualCue];
        [super closeSheet:sender];
    }
}

- (void)cancelSheet:(id)sender {
    
    [((SBWindowController *)[parentWindow windowController]) hideVisualCue];
    [super cancelSheet:sender];
}

@end
