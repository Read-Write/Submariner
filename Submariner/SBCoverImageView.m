//
//  SBCoverImageView.m
//  Sub
//
//  Created by nark on 28/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBCoverImageView.h"


@implementation SBCoverImageView

- (void)drawRect:(NSRect)dirtyRect {
        
    NSRect rect = [self bounds];
    NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.2853 green:0.2853 blue:0.2853 alpha:1.0000] 
                                                          endingColor:[NSColor colorWithCalibratedRed:0.0514 green:0.0514 blue:0.0514 alpha:1.0000]] autorelease];
    
    [gradient drawInRect:rect angle:-90];
    
    [super drawRect:dirtyRect];
}

@end
