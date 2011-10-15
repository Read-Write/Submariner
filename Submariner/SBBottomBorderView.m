//
//  SBBottomBorderView.m
//  Submariner
//
//  Created by Rafaël Warnault on 13/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBBottomBorderView.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"

#define COLOR_KEY_START [NSColor colorWithDeviceRed:0.659 green:0.659 blue:0.659 alpha:1.00]
#define COLOR_KEY_END [NSColor colorWithDeviceRed:0.812 green:0.812 blue:0.812 alpha:1.00]
#define COLOR_KEY_BOTTOM [NSColor colorWithDeviceRed:0.318 green:0.318 blue:0.318 alpha:1.00]

#define COLOR_NOTKEY_START [NSColor colorWithDeviceRed:0.851 green:0.851 blue:0.851 alpha:1.00]
#define COLOR_NOTKEY_END [NSColor colorWithDeviceRed:0.929 green:0.929 blue:0.929 alpha:1.00]
#define COLOR_NOTKEY_BOTTOM [NSColor colorWithDeviceRed:0.600 green:0.600 blue:0.600 alpha:1.00]

#define CORNER_CLIP_RADIUS 4.0


@implementation SBBottomBorderView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    BOOL key = [[self window] isKeyWindow];
    NSRect drawingRect = [self bounds];
    drawingRect.size.height -= 1.0; // Decrease the height by 1.0px to show the highlight line at the top
    
    NSColor *startColor = COLOR_NOTKEY_START;
    NSColor *endColor = COLOR_NOTKEY_END;
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:drawingRect cornerRadius:CORNER_CLIP_RADIUS inCorners:(OSBottomLeftCorner | OSBottomRightCorner)];
    
    
    [NSGraphicsContext saveGraphicsState];
    [clipPath addClip];
    NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor] autorelease];
    [gradient drawInRect:drawingRect angle:90];
    [NSGraphicsContext restoreGraphicsState];
    
    //NSColor *topColor = key ? COLOR_KEY_BOTTOM : COLOR_NOTKEY_BOTTOM;
    NSRect topRect = NSMakeRect(0.0, NSMaxY(drawingRect), NSWidth(drawingRect), 1.0);
    [[NSColor grayColor] setFill];
    NSRectFill(topRect);
    
    NSRect topHighlightRect = NSMakeRect(0.0, NSMaxY(drawingRect)-1, NSWidth(drawingRect), 1.0);
    [[NSColor colorWithDeviceWhite:0.9 alpha:1.0] setFill];
    NSRectFill(topHighlightRect);
    
    
}

@end
