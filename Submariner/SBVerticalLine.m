//
//  SBVerticalLine.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBVerticalLine.h"


@implementation SBVerticalLine

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:NSMakeRect(frame.origin.x, frame.origin.y, 2, frame.size.height)];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect lightRect = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, 0.5, dirtyRect.size.height+1);
   [[NSColor darkGrayColor] setFill];
    NSFrameRect(lightRect);
    
    NSRect grayRect = NSMakeRect(dirtyRect.origin.x+1, dirtyRect.origin.y, 0.5, dirtyRect.size.height+1);
    [[NSColor colorWithDeviceWhite:0.8 alpha:1.0] setFill];
    NSFrameRect(grayRect);
}

@end
