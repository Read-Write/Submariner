//
//  SBServerServerController.m
//  Submariner
//
//  Created by Rafaël Warnault on 25/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBServerSearchController.h"
#import "SBSubsonicParsingOperation.h"
#import "SBDatabaseController.h"
#import "SBPlayer.h"
#import "SBSubsonicDownloadOperation.h"
#import "NSOperationQueue+Shared.h"


@interface SBServerSearchController (Private)
- (void)subsonicSearchResultUpdatedNotification:(NSNotification *)notification;
@end




@implementation SBServerSearchController

+ (NSString *)nibName {
    return @"ServerSearch";
}


@synthesize searchResult;


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SBSubsonicSearchResultUpdatedNotification object:nil];
    [searchResult release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subsonicSearchResultUpdatedNotification:) 
                                                 name:SBSubsonicSearchResultUpdatedNotification 
                                               object:nil];
    
    [tracksTableView setTarget:self];
    [tracksTableView setDoubleAction:@selector(trackDoubleClick:)];
    [tracksTableView registerForDraggedTypes:[NSArray arrayWithObject:SBLibraryTableViewDataType]];
}





#pragma mark - 
#pragma mark Subsonic notification

- (void)subsonicSearchResultUpdatedNotification:(NSNotification *)notification {    
    NSLog(@"setSearchResult");
    [self setSearchResult:[notification object]];
}





#pragma mark - 
#pragma mark IBActions

- (IBAction)trackDoubleClick:(id)sender {
    NSInteger selectedRow = [tracksTableView selectedRow];
    if(selectedRow != -1) {
        SBTrack *clickedTrack = [[tracksController arrangedObjects] objectAtIndex:selectedRow];
        if(clickedTrack) {
            
            // stop current playing tracks
            [[SBPlayer sharedInstance] stop];
            
            // add track to player
            if([[NSUserDefaults standardUserDefaults] integerForKey:@"playerBehavior"] == 1) {
                [[SBPlayer sharedInstance] addTrackArray:[tracksController arrangedObjects] replace:YES];
                // play track
                [[SBPlayer sharedInstance] playTrack:clickedTrack];
            } else {
                [[SBPlayer sharedInstance] addTrackArray:[tracksController arrangedObjects] replace:NO];
                [[SBPlayer sharedInstance] playTrack:clickedTrack];
            }
        }
    }
}

- (IBAction)addTrackToTracklist:(id)sender {
    NSIndexSet *indexSet = [tracksTableView selectedRowIndexes];
    __block NSMutableArray *tracks = [NSMutableArray array];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [tracks addObject:[[tracksController arrangedObjects] objectAtIndex:idx]];
    }];
    
    [[SBPlayer sharedInstance] addTrackArray:tracks replace:NO];
}

- (IBAction)downloadTrack:(id)sender {
    NSInteger selectedRow = [tracksTableView selectedRow];
    
    if(selectedRow != -1) {
        SBTrack *track = [[tracksController arrangedObjects] objectAtIndex:selectedRow];
        if(track != nil) {
            SBSubsonicDownloadOperation *op = [[SBSubsonicDownloadOperation alloc] initWithManagedObjectContext:self.managedObjectContext];
            [op setTrackID:(SBTrackID *)[track objectID]];
            
            [[NSOperationQueue sharedDownloadQueue] addOperation:op];
        }
    }
}




#pragma mark -
#pragma mark NSTableView (Drag & Drop)

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    
    BOOL ret = NO;
    if(tableView == tracksTableView) {
        /*** Internal drop track */
        NSMutableArray *trackURIs = [NSMutableArray array];
        
        // get tracks URIs
        [rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [trackURIs addObject:[[[[tracksController arrangedObjects] objectAtIndex:idx] objectID] URIRepresentation]];
        }];
        
        // encode to data
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:trackURIs];
        
        // register data to pastboard
        [pboard declareTypes:[NSArray arrayWithObject:SBLibraryTableViewDataType] owner:self];
        [pboard setData:data forType:SBLibraryTableViewDataType];
        ret = YES;
    }
    return ret;
}



#pragma mark -
#pragma mark NSTableView (Menu)

- (NSMenu *)tableView:(id)tableView menuForEvent:(NSEvent *)event {
    if(tableView == tracksTableView) {
        NSMenu*  menu = nil;
        NSMenuItem *item = nil;
        
        menu = [[NSMenu alloc] initWithTitle:@"trackMenu"];
        [menu setAutoenablesItems:NO];
        
        item = [[[NSMenuItem alloc] initWithTitle:@"Play Track" action:@selector(trackDoubleClick:) keyEquivalent:@""] autorelease];
        [item setTarget:self];
        [menu addItem:item];
        
        item = [[[NSMenuItem alloc] initWithTitle:@"Add to Tracklist" action:@selector(addTrackToTracklist:) keyEquivalent:@""] autorelease];
        [item setTarget:self];
        [menu addItem:item];
        
        [menu addItem:[NSMenuItem separatorItem]];
        
        item = [[[NSMenuItem alloc] initWithTitle:@"Download Track" action:@selector(downloadTrack:) keyEquivalent:@""] autorelease];
        [item setTarget:self];
        [menu addItem:item];
        
        return menu;
        
    }
    return nil;
}





#pragma mark - 
#pragma mark NSTableView delegate

- (void)tableViewEnterKeyPressedNotification:(NSNotification *)notification {
    [self trackDoubleClick:self];
}



@end
