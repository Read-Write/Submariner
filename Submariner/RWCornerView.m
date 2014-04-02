//
//  RWCornerView.m
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
