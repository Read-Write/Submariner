//
//  SBMovieController.m
//  Submariner
//
//  Created by Rafaël Warnault on 18/10/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBMovieWindowController.h"

@implementation SBMovieWindowController


#pragma mark -
#pragma mark SBWindowController

+ (NSString *)nibName {
    return @"MovieWindow";
}

#pragma mark -
#pragma mark Singlton

+ (id)sharedInstance {
    static SBMovieWindowController *sharedInstance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[SBMovieWindowController alloc] initWithWindowNibName:[SBMovieWindowController nibName]];
    });
    return sharedInstance;
}

- (void)dealloc {
    [super dealloc];
}

- (void)windowDidLoad {
    [self.window setDelegate:self];
}

- (void)showWindow {
    [self.window makeKeyAndOrderFront:self];
}

- (void)windowWillClose:(NSNotification *)notification {
    [movieView pause:self];
    [movieView setMovie:nil];
}

- (void)playMovie:(QTMovie *)movie {
    if(movie != movieView.movie) {
        [movieView setMovie:movie];
    }
    [movieView play:self];
}

- (void)pause {
    [movieView pause:self];
}


@end
