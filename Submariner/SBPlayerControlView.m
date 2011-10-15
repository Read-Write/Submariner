//
//  SBPlayerControlsSplitView.m
//  Sub
//
//  Created by nark on 28/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBPlayerControlView.h"


@implementation SBPlayerControlView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self lockFocus];
    
    NSBezierPath *roundPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:10.0f yRadius:10.0f];
    [[NSColor colorWithDeviceWhite:0.0f alpha:0.3f] setFill];
    [roundPath fill];
    
    [self unlockFocus];
}

@end
