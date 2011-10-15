//
//  SBCoverImageView.m
//  Sub
//
//  Created by nark on 28/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBCoverImageView.h"


@implementation SBCoverImageView

- (void)drawRect:(NSRect)dirtyRect {
    
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    
    [super drawRect:dirtyRect];
}

@end
