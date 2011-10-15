//
//  SBMergeArtistController.m
//  Submariner
//
//  Created by Rafaël Warnault on 24/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBMergeArtistsController.h"
#import "SBArtist.h"
#import "SBAlbum.h"


@implementation SBMergeArtistsController

@synthesize artists;


- (void)openSheet:(id)sender {
    
    if(artists != nil && [artists  count] > 0) {
        for (SBArtist *artist in artists) {
            NSMenuItem *newItem = [[[NSMenuItem alloc] init] autorelease];
            [newItem setTitle:artist.itemName];
            [newItem setRepresentedObject:artist];
            
            [[artistPopUpButton menu] addItem:newItem];
        }
    }
    [super openSheet:sender];
}

- (void)closeSheet:(id)sender {
    
    if(artists != nil && [artists  count] > 0) {
        NSMenuItem *selectedIem = [artistPopUpButton selectedItem];
        if(selectedIem != nil) {
            SBArtist *targetArtist = [selectedIem representedObject];
            NSMutableArray *albums = [NSMutableArray array];
            
            for(SBArtist *otherArtist in artists) {
                if(![otherArtist isEqualTo:targetArtist]) {
                    [albums addObjectsFromArray:[otherArtist.albums allObjects]];
                }
            }
            
            for(SBAlbum *album in albums) {
                [targetArtist addAlbumsObject:album];
            }
            
            for(SBArtist *otherArtist in artists) {
                if(![otherArtist isEqualTo:targetArtist]) {
                    [targetArtist.managedObjectContext deleteObject:otherArtist];
                }
            }
            
            [targetArtist.managedObjectContext save:nil];
        }
    }
    
    [super closeSheet:sender];
}

@end
