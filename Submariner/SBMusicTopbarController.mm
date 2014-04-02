//
//  MusicTopbar.m
//  Submariner
//
//  Created by Rafaël Warnault on 06/06/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
