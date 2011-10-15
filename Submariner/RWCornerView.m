//
//  RWCornerView.m
//  iPlay
//
//  Created by nark on 02/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "RWCornerView.h"


@implementation RWCornerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {

    NSArray* colorArray = [NSArray arrayWithObjects:
						   [NSColor colorWithDeviceWhite:0.9 alpha:1.0],
						   [NSColor colorWithDeviceWhite:0.8 alpha:1.0],
						   [NSColor colorWithDeviceWhite:0.7 alpha:1.0],
						   nil];
    
	NSGradient* gradient = [[[NSGradient alloc] initWithColors:colorArray] autorelease];
	[gradient drawInRect:dirtyRect angle:-90.0];
	
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
	[gc saveGraphicsState];
	[gc setShouldAntialias:NO];
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth:1.0];
	NSPoint p = NSMakePoint(dirtyRect.origin.x, dirtyRect.origin.y+2.0);
	[path moveToPoint:p];
	
	p.y += dirtyRect.size.height-2.0;
	[path lineToPoint:p];
	p.x += dirtyRect.size.width;
	[path lineToPoint:p];
	
	p = NSMakePoint(dirtyRect.origin.x, dirtyRect.origin.y+1.0);
	[path moveToPoint:p];
	p.x += dirtyRect.size.width;
	[path lineToPoint:p];
	
	[[NSColor colorWithDeviceWhite:0.0 alpha:0.2] set];
	[path stroke];
	
	[gc restoreGraphicsState];
}

@end
