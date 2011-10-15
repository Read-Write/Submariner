//
//  SBNowPlayingViewItem.m
//  Sub
//
//  Created by nark on 05/06/11.
//  Copyright 2011 read-write. All rights reserved.
//

#import "SBNowPlayingViewItem.h"
#import "SBNowPlaying.h"
#import "SBTrack.h"
#import "SBAlbum.h"
#import "SBPlayer.h"

@implementation SBNowPlayingViewItem


- (IBAction)playTrack:(id)sender {
    SBTrack *track = [[self representedObject] track];
    if(track != nil) {
        [[SBPlayer sharedInstance] addTrack:track replace:NO];
        [[SBPlayer sharedInstance] playTrack:track];
    }
}

- (IBAction)userInfo:(id)sender {

}

@end
