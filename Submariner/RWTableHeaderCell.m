//
//  RWTableHeaderCell.m
//  iPlay
//
//  Created by Rafaël Warnault on 02/03/11.
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

#import "RWTableHeaderCell.h"
#import "CTGradient.h"

@implementation RWTableHeaderCell



#define TRIANGLE_WIDTH	8
#define TRIANGLE_HEIGHT	7
#define MARGIN_X		4
#define MARGIN_Y		5

#define LINE_MARGIN_Y	1.8
#define LINE_MARGIN_X	5



- (id)initWithCell:(NSTableHeaderCell*)cell
{
	self = [super initTextCell:[cell stringValue]];
	if (self) {
		
		NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
		[shadow setShadowColor:[NSColor lightGrayColor]];
		[shadow setShadowOffset:NSMakeSize(0, 1)];
		[shadow setShadowBlurRadius:0.0f];
		
		NSDictionary *attr = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSColor blackColor], shadow, [NSFont systemFontOfSize:11.0f], nil]
														 forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSShadowAttributeName, NSFontAttributeName, nil]];
		
		NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithAttributedString:[cell attributedStringValue]] autorelease];
		[attributedString addAttributes: attr range:NSMakeRange(0, [attributedString length])];
		
		[self setAttributedStringValue: attributedString];
		
		_ascending = YES;
		_priority = 1;
	}
	return self;
	
}

- (void)_drawInRect:(NSRect)rect hilighted:(BOOL)hilighted
{
	CGFloat delta = hilighted ? -0.1 : 0;
	NSArray* colorArray = [NSArray arrayWithObjects:
						   [NSColor colorWithDeviceWhite:0.9+delta alpha:1.0],
						   [NSColor colorWithDeviceWhite:0.8+delta alpha:1.0],
						   [NSColor colorWithDeviceWhite:0.7+delta alpha:1.0],
						   nil];
	NSGradient* gradient = [[[NSGradient alloc] initWithColors:colorArray] autorelease];
	[gradient drawInRect:rect angle:90.0];
	
	NSGraphicsContext* gc = [NSGraphicsContext currentContext];
	[gc saveGraphicsState];
	[gc setShouldAntialias:NO];
	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth:1.0];
	NSPoint p = NSMakePoint(rect.origin.x, rect.origin.y+2.0);
	[path moveToPoint:p];
	
	p.y += rect.size.height-2.0;
	[path lineToPoint:p];
	p.x += rect.size.width;
	[path lineToPoint:p];
	
	p = NSMakePoint(rect.origin.x, rect.origin.y+1.0);
	[path moveToPoint:p];
	p.x += rect.size.width;
	[path lineToPoint:p];
	
	[[NSColor colorWithDeviceWhite:0.0 alpha:0.2] set];
	[path stroke];
	
	[gc restoreGraphicsState];
	
	
	// [2] draw string
	NSRect stringFrame = rect;
	if (_priority == 0) {
		stringFrame.size.width -= TRIANGLE_WIDTH;
	}
	stringFrame.origin.y += LINE_MARGIN_Y;
	stringFrame.origin.x += LINE_MARGIN_X;
	
	[[self attributedStringValue] drawInRect:stringFrame];
}


#pragma mark -
#pragma mark Overridden methods (NSCell)
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self _drawInRect:cellFrame hilighted:NO];
	[self drawSortIndicatorWithFrame:cellFrame
							  inView:controlView
						   ascending:_ascending
							priority:_priority];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self _drawInRect:cellFrame hilighted:YES];
	[self drawSortIndicatorWithFrame:cellFrame
							  inView:controlView
						   ascending:_ascending
							priority:_priority];
}


- (void)drawSortIndicatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView ascending:(BOOL)ascending priority:(NSInteger)priority
{
	NSBezierPath* path = [NSBezierPath bezierPath];
	
	if (ascending) {
		NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - TRIANGLE_WIDTH - MARGIN_X,
								cellFrame.origin.y + cellFrame.size.height - MARGIN_Y);
		[path moveToPoint:p];
		
		
		p.x += TRIANGLE_WIDTH/2.0;
		p.y -= TRIANGLE_HEIGHT;
		[path lineToPoint:p];
		
		p.x += TRIANGLE_WIDTH/2.0;
		p.y += TRIANGLE_HEIGHT;
		[path lineToPoint:p];
		
	} else {
		NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - TRIANGLE_WIDTH - MARGIN_X,
								cellFrame.origin.y + MARGIN_Y);
		[path moveToPoint:p];
		
		
		p.x += TRIANGLE_WIDTH/2.0;
		p.y += TRIANGLE_HEIGHT;
		[path lineToPoint:p];
		
		p.x += TRIANGLE_WIDTH/2.0;
		p.y -= TRIANGLE_HEIGHT;
		[path lineToPoint:p];
		
	}
	
	[path closePath];
	
	if (_priority == 0) {
		[[NSColor whiteColor] set];
	} else {
		[[NSColor clearColor] set];
	}
	[path fill];
}

- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority
{
	_ascending = ascending;
	_priority = priority;
}
@end
