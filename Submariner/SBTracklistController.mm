//
//  SBTracklistController.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBTracklistController.h"
#import "SBDatabaseController.h"
#import "SBPlayer.h"
#import "SBMusicItem.h"
#import "SBTrack.h"
#import "SBAlbum.h"
#import "SBArtist.h"




@interface SBTracklistController ()
- (void)playerPlaylistUpdatedNotification:(NSNotification *)notification;
@end



@implementation SBTracklistController

+ (NSString *)nibName {
    return @"Tracklist";
}


@synthesize databaseController;



- (void)dealloc {
    // remove player observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SBPlayerPlaylistUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"playlist"];
    [super dealloc];
}



- (void)loadView {
    [super loadView];
    
    [playlistTableView setTarget:self];
    [playlistTableView setDoubleAction:@selector(trackDoubleClick:)];
    [playlistTableView registerForDraggedTypes:[NSArray arrayWithObject:SBTracklistTableViewDataType]];
    
    // observer playlist change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerPlaylistUpdatedNotification:)
                                                 name:SBPlayerPlaylistUpdatedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           forKeyPath:@"playlist"  
                                              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                                              context:[SBPlayer sharedInstance]];
}





#pragma mark -
#pragma mark Observers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"playlist"]) {
        [playlistTableView reloadData];
    }
}





#pragma mark -
#pragma mark IBActions

- (IBAction)trackDoubleClick:(id)sender {
    NSInteger selectedRow = [playlistTableView selectedRow];
    if(selectedRow != -1) {
        SBTrack *clickedTrack = [[[SBPlayer sharedInstance] playlist] objectAtIndex:selectedRow];
        if(clickedTrack) {
            
            // stop current playing tracks
            [[SBPlayer sharedInstance] stop];
            
            // play track
            [[SBPlayer sharedInstance] playTrack:clickedTrack];
        }
    }
}




- (IBAction)removeTrack:(id)sender {
    NSInteger selectedRow = [playlistTableView selectedRow];
    
    if(selectedRow != -1) {
        SBTrack *track = [[[SBPlayer sharedInstance] playlist] objectAtIndex:selectedRow];
        if(track) {
            [[SBPlayer sharedInstance] removeTrack:track];
            [playlistTableView reloadData];
        }
    }
}


- (IBAction)cleanTracklist:(id)sender {
    [[SBPlayer sharedInstance] clear];
    [playlistTableView reloadData];
}


- (IBAction)closeTracklist:(id)sender {
    [databaseController toggleTrackList:sender];
}




#pragma mark -
#pragma mark Player Notifications

- (void)playerPlaylistUpdatedNotification:(NSNotification *)notification {

    [playlistTableView reloadData];
}





#pragma mark -
#pragma mark NSTableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[[SBPlayer sharedInstance] playlist] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    id value = nil;
    
    if([[tableColumn identifier] isEqualToString:@"isPlaying"]) {
        SBTrack *track = (SBTrack *)[[[SBPlayer sharedInstance] playlist] objectAtIndex:row];
        if([[track isPlaying] boolValue]) {
            value = [NSImage imageNamed:@"playing_white"];
        }
    }
    if([[tableColumn identifier] isEqualToString:@"title"])
        value = [[[[SBPlayer sharedInstance] playlist] objectAtIndex:row] itemName];
    
    if([[tableColumn identifier] isEqualToString:@"artist"])
        value = [[[[SBPlayer sharedInstance] playlist] objectAtIndex:row] artistString];
    
    if([[tableColumn identifier] isEqualToString:@"duration"])
        value = [[[[SBPlayer sharedInstance] playlist] objectAtIndex:row] durationString];
    
    if([[tableColumn identifier] isEqualToString:@"online"]) {
        SBTrack *track = (SBTrack *)[[[SBPlayer sharedInstance] playlist] objectAtIndex:row];
        if(![[track isLocal] boolValue]) {
            if(track.localTrack != nil) {
                value = [NSImage imageNamed:@"cached_white"];
            } else {
                value = [NSImage imageNamed:@"online_white"];
            }
        }
    }
    return value;
}




#pragma mark -
#pragma mark NSTableView Delegate

- (void)tableViewEnterKeyPressedNotification:(NSNotification *)notification {
    [self trackDoubleClick:self];
}

- (void)tableViewDeleteKeyPressedNotification:(NSNotification *)notification {
    [self removeTrack:self];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
    // internal drop track
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:SBTracklistTableViewDataType] owner:self];
    [pboard setData:data forType:SBTracklistTableViewDataType];
    
    return YES;
}


- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    
    if(row == -1)
        return NSDragOperationNone;
    
    if(op == NSTableViewDropAbove) {
        // internal drop track
        if ([[[info draggingPasteboard] types] containsObject:SBTracklistTableViewDataType] ) {
            return NSDragOperationMove;
        }
    }
    
    return NSDragOperationNone;
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
              row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    
    NSPasteboard* pboard = [info draggingPasteboard];
    
    // internal drop track
    if ([[pboard types] containsObject:SBTracklistTableViewDataType] ) {
        NSData* rowData = [pboard dataForType:SBTracklistTableViewDataType];
        NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];    
        NSMutableArray *tracks = [NSMutableArray array];
        NSArray *reversedArray  = nil;
        
        // get temp rows objects and remove them from the playlist
        [rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [tracks addObject:[[[SBPlayer sharedInstance] playlist] objectAtIndex:idx]];
            [[[SBPlayer sharedInstance] playlist] removeObject:[[[SBPlayer sharedInstance] playlist] objectAtIndex:idx]];
            [playlistTableView reloadData];
        }];
        
        // reverse track array
        reversedArray = [[tracks reverseObjectEnumerator] allObjects];
        
        // add reversed track at index
        for(SBTrack *track in reversedArray) {
            NSLog(@"row : %ld", row);
            if(row > [[[SBPlayer sharedInstance] playlist] count])
                row--;
            
            [[[SBPlayer sharedInstance] playlist] insertObject:track atIndex:row];
        }
        [playlistTableView reloadData];
    }
    
    return YES;
}

@end