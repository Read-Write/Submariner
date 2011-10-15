//
//  SBPlaylistController.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBPlaylistController.h"
#import "SBDatabaseController.h"
#import "SBServer.h"
#import "SBTrack.h"
#import "SBPlayer.h"
#import "SBPlaylist.h"


@implementation SBPlaylistController


@synthesize playlist;
@synthesize playlistSortDescriptors;



#pragma mark - 
#pragma mark LifeCycle

+ (NSString *)nibName {
    return @"Playlist";
}


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"playlistIndex" ascending:YES];
        playlistSortDescriptors = [[NSArray arrayWithObject:desc] retain];
    }
    return self;
}


- (void)dealloc
{
    [playlistSortDescriptors release];
    [super dealloc];
}


- (void)loadView {
    [super loadView];
    
    [tracksTableView setTarget:self];
    [tracksTableView setDoubleAction:@selector(trackDoubleClick:)];
    [tracksTableView registerForDraggedTypes:[NSArray arrayWithObject:SBLibraryTableViewDataType]];
}




#pragma mark - 
#pragma mark Utils

- (void)clearPlaylist {
    //[tracksController setContent:nil];
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

- (IBAction)removeTrack:(id)sender {
    NSInteger selectedRow = [tracksTableView selectedRow];
    
    if(selectedRow != -1) {
        SBTrack *selectedTrack = [[tracksController arrangedObjects] objectAtIndex:selectedRow];
        if(selectedTrack != nil) {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Remove the selected track ?"];
            [alert setInformativeText:@"The selected track will be removed from this playlist."];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            [alert beginSheetModalForWindow:[[self view] window] 
                              modalDelegate:self 
                             didEndSelector:@selector(removeTrackAlertDidEnd:returnCode:contextInfo:) 
                                contextInfo:nil];
        }
    }
}


- (void)removeTrackAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) { 
        NSInteger selectedRow = [tracksTableView selectedRow];
        
        if(selectedRow != -1) {
            SBTrack *selectedTrack = [[tracksController arrangedObjects] objectAtIndex:selectedRow];
            if(selectedTrack != nil) {
                [playlist removeTracksObject:selectedTrack];
            }
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

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    
    if(row == -1)
        return NSDragOperationNone;
    
    if(op == NSTableViewDropAbove) {
        // internal drop track
        if ([[[info draggingPasteboard] types] containsObject:SBLibraryTableViewDataType] ) {
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
    if ([[pboard types] containsObject:SBLibraryTableViewDataType] ) {
        NSData* rowData = [pboard dataForType:SBLibraryTableViewDataType];
        NSArray *trackURIs = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
        NSMutableArray *tracks = [NSMutableArray array];
        NSArray *reversedArray  = nil;
        NSInteger sourceRow = 0;    
        NSInteger destinationRow = 0;
        
        // compute selected track
        [trackURIs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SBTrack *track = (SBTrack *)[self.managedObjectContext objectWithID:[self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:obj]];
            [tracks addObject:track];
        }];
        
        // update playlist indexes 
        if([[[tracks objectAtIndex:0] playlistIndex] integerValue] < row) {
            sourceRow = [[[tracks objectAtIndex:0] playlistIndex] integerValue];
            destinationRow = row;
            
            // increment interval rows
            NSArray *trackInInterval = [[tracksController arrangedObjects] subarrayWithRange:NSMakeRange(sourceRow, destinationRow-sourceRow)];
            for(SBTrack *track in trackInInterval) {
                NSInteger playlistIndex = [[track playlistIndex] integerValue];
                playlistIndex--;
                
                [track setPlaylistIndex:[NSNumber numberWithInteger:playlistIndex]];
            }
        } else {
            sourceRow = row;
            destinationRow = [[[tracks objectAtIndex:0] playlistIndex] integerValue];
            
            // increment interval rows
            NSArray *trackInInterval = [[tracksController arrangedObjects] subarrayWithRange:NSMakeRange(sourceRow, destinationRow-sourceRow)];
            for(SBTrack *track in trackInInterval) {
                NSInteger playlistIndex = [[track playlistIndex] integerValue];
                playlistIndex++;
                
                [track setPlaylistIndex:[NSNumber numberWithInteger:playlistIndex]];
            }
        }
    
        
        // reverse track array
        reversedArray = [[tracks reverseObjectEnumerator] allObjects];
        
        // add reversed track at index
        for(SBTrack *track in reversedArray) {
            if(row > [[tracksController arrangedObjects] count])
                row--;
            
            [track setPlaylistIndex:[NSNumber numberWithInteger:row]];
        }
        
        
        [tracksController rearrangeObjects];
        [tracksTableView reloadData];
    }
    
    return YES;
}




#pragma mark -
#pragma mark Tracks NSTableView DataSource (Rating)

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    if(aTableView == tracksTableView) {
        if([[aTableColumn identifier] isEqualToString:@"rating"]) {
            
            NSInteger selectedRow = [tracksTableView selectedRow];
            if(selectedRow != -1) {
                SBTrack *clickedTrack = [[tracksController arrangedObjects] objectAtIndex:selectedRow];
                
                if(clickedTrack) {
                    
                    NSInteger rating = [anObject intValue];
                    NSString *trackID = [clickedTrack id];
                    
                    [clickedTrack.server setRating:rating forID:trackID];
                }
            }
        }
    }
}






#pragma mark - 
#pragma mark NSTableView delegate

- (void)tableViewEnterKeyPressedNotification:(NSNotification *)notification {
    [self trackDoubleClick:self];
}

- (void)tableViewDeleteKeyPressedNotification:(NSNotification *)notification {
    [self removeTrack:self];
}


@end
