//
//  DXControlBarView.m
//  DicomX
//
//  Created by nark on 22/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBControlBarView.h"


@implementation SBControlBarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setWantsLayer:YES];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{	    
    NSRect bottomRect = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, 0.5);
    [[NSColor lightGrayColor] setStroke];
    
    // Draw gradient background.
	NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.75 alpha:1.0] 
														  endingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]] autorelease];
	[gradient drawInRect:[self bounds] angle:90.0];

    // draw bottom path
    NSBezierPath *bottomPath = [NSBezierPath bezierPathWithRect:bottomRect];
    [bottomPath stroke];
    
    NSRect toplinetRect = NSMakeRect(0.0, NSMaxY(dirtyRect)-1, NSWidth(dirtyRect), 1.0);
    [[NSColor grayColor] setFill];
    NSRectFill(toplinetRect);
    
    NSRect highlightRect = NSMakeRect(0.0, NSMaxY(dirtyRect)-2, NSWidth(dirtyRect), 1.0);
    [[NSColor colorWithDeviceWhite:0.9 alpha:1.0] setFill];
    NSRectFill(highlightRect);
}

@end
