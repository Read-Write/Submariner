//
//  SBMusicSearchController.m
//  Submariner
//
//  Created by Rafaël Warnault on 22/08/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBMusicSearchController.h"
#import "SBTrack.h"
#import "SBPlayer.h"


@implementation SBMusicSearchController


+ (NSString *)nibName {
    return @"MusicSearch";
}


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {

    }
    return self;
}


- (void)searchString:(NSString *)query {    
    NSMutableString *searchText = [NSMutableString stringWithString:query];
    
    // Remove extraenous whitespace
    while ([searchText rangeOfString:@"Â  "].location != NSNotFound) {
        [searchText replaceOccurrencesOfString:@"Â  " withString:@" " options:0 range:NSMakeRange(0, [searchText length])];
    }
    
    //Remove leading space
    if ([searchText length] != 0) [searchText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0,1)];
    
    //Remove trailing space
    if ([searchText length] != 0) [searchText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange([searchText length]-1, 1)];
    
    if ([searchText length] == 0) {
        [tracksController setFilterPredicate:[NSPredicate predicateWithFormat:@"(isLocal == YES)"]];
        return;
    }
    
    NSArray *searchTerms = [searchText componentsSeparatedByString:@" "];
    
    if ([searchTerms count] == 1) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"(isLocal == YES) AND ((itemName contains[cd] %@) OR (albumString contains[cd] %@) OR (artistString contains[cd] %@) OR (genre contains[cd] %@))", searchText, searchText, searchText, searchText];
        [tracksController setFilterPredicate:p];
    } else {
        NSMutableArray *subPredicates = [[NSMutableArray alloc] init];
        for (NSString *term in searchTerms) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"(isLocal == YES) AND ((itemName contains[cd] %@) OR (albumString contains[cd] %@) OR (artistString contains[cd] %@) OR (genre contains[cd] %@))", term, term, term, term];
            [subPredicates addObject:p];
        }
        NSPredicate *cp = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        
        [tracksController setFilterPredicate:cp];
    }
}


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

@end
