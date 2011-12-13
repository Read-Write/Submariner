//
//  MusicTopbar.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBMusicTopbarController.h"
#import "SBDatabaseController.h"
#import "SBMusicController.h"
#import "SBMusicSearchController.h"
#import "SBPlayer.h"




@interface SBMusicTopbarController ()
- (void)topbarItemPressed:(NSDictionary *)item;
@end


@implementation SBMusicTopbarController

+ (NSString *)nibName {
    return @"MusicTopbar";
}


@synthesize databaseController;
@synthesize musicController;


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        musicSearchController = [[SBMusicSearchController alloc] initWithManagedObjectContext:self.managedObjectContext];
    }
    return self;
}


- (void)dealloc {
    [musicSearchController release];
    [musicController release];
    [databaseController release];
    [super dealloc];
}


- (void)loadView {
    [super loadView];
}


- (IBAction)search:(id)sender {
    NSString *query = [sender stringValue];
    
    if(query && [query length] > 0) {
        [databaseController setCurrentView:(SBAnimatedView *)[musicSearchController view]];
        [musicSearchController searchString:query];
    }
}


- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSString *query = [[aNotification object] stringValue];
    
    if(!query || [query length] == 0) {
        [databaseController setCurrentView:(SBAnimatedView *)[musicController view]];
    }
}


- (void)segmentedControl:(ANSegmentedControl *)control selectionDidChange:(NSInteger)index {
    NSLog(@"segmentedControl:selectionDidChange:");
}

- (NSArray *)itemsArrayForTopbarView:(SBTopbarView *)topbar {
    NSMutableArray *results = [NSMutableArray array];
    
    NSInteger i = 0;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"Indentifier %d", i] forKey:kSBTopbarItemIdentifier];
    [dict setValue:[NSImage imageNamed:@"Library"] forKey:kSBTopbarItemImage];
    [dict setValue:[NSValue valueWithPointer:@selector(topbarItemPressed:)] forKey:kSBTopbarItemAction];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:kSBTopbarItemSelected];
    [results addObject:dict];
    
    i++;
    
    dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"Indentifier %d", i] forKey:kSBTopbarItemIdentifier];
    [dict setValue:[NSImage imageNamed:@"Library"] forKey:kSBTopbarItemImage];
    [dict setValue:[NSValue valueWithPointer:@selector(topbarItemPressed:)] forKey:kSBTopbarItemAction];
    [dict setValue:[NSNumber numberWithBool:NO] forKey:kSBTopbarItemSelected];
    [results addObject:dict];
    
    i++;
    
    dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"Indentifier %d", i] forKey:kSBTopbarItemIdentifier];
    [dict setValue:[NSImage imageNamed:@"Library"] forKey:kSBTopbarItemImage];
    [dict setValue:[NSValue valueWithPointer:@selector(topbarItemPressed:)] forKey:kSBTopbarItemAction];
    [dict setValue:[NSNumber numberWithBool:NO] forKey:kSBTopbarItemSelected];
    [results addObject:dict];
    
    i++;
    
    dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"Indentifier %d", i] forKey:kSBTopbarItemIdentifier];
    [dict setValue:[NSImage imageNamed:@"Library"] forKey:kSBTopbarItemImage];
    [dict setValue:[NSValue valueWithPointer:@selector(topbarItemPressed:)] forKey:kSBTopbarItemAction];
    [dict setValue:[NSNumber numberWithBool:NO] forKey:kSBTopbarItemSelected];
    [results addObject:dict];
    
    i++;
    
    return results;
}

- (void)topbarItemPressed:(NSDictionary *)item {
    
}

@end
