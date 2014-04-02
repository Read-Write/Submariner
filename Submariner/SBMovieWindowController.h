//
//  SBMovieController.h
//  Submariner
//
//  Created by Rafaël Warnault on 18/10/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "SBWindowController.h"


@interface SBMovieWindowController : SBWindowController <NSWindowDelegate> {
    IBOutlet QTMovieView *movieView;
}

+ (id)sharedInstance;

- (void)showWindow;
- (void)closeWindow;

- (void)playMovie:(QTMovie *)movie;
- (void)pause;

@end
